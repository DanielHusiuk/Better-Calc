//
//  LenghtViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 06.08.2024.
//

import UIKit
import CoreData

class LengthViewController: UIViewController {
    
    @IBOutlet weak var CalculatorImageOutlet: UIImageView!
    @IBOutlet var ShadowButtonsOutlet: [UIButton]!
    
    @IBOutlet weak var FromNumberImageOutlet: UIImageView!
    @IBOutlet weak var FromLabelOutlet: UILabel!
    @IBOutlet weak var FromButtonOutlet: UIButton!
    
    @IBOutlet weak var ToNumberImageOutlet: UIImageView!
    @IBOutlet weak var ToLabelOutlet: UILabel!
    @IBOutlet weak var ToButtonOutlet: UIButton!
    
    let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")!
    var selectedUnits: [UIButton: UnitLength] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferences()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyShadowWithInsets(to: FromNumberImageOutlet, cornerRadius: 20)
        applyShadowWithInsets(to: ToNumberImageOutlet, cornerRadius: 20)
        applyShadowWithInsets(to: CalculatorImageOutlet, cornerRadius: 30)
        buttonShadows()
    }
    
    
    //MARK: - View preferences
    
    func updatePreferences() {
        overrideUserInterfaceStyle = .dark
        UnitMenu(in: FromButtonOutlet)
        UnitMenu(in: ToButtonOutlet)
    }
    
    func applyShadowWithInsets(to view: UIView, cornerRadius: CGFloat) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 8
        
        let insetBounds = view.bounds.insetBy(dx: -5, dy: -5)
        let shadowPath = UIBezierPath(roundedRect: insetBounds, cornerRadius: cornerRadius)
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    
    // MARK: - Button Preferences
    
    func buttonShadows() {
        let shadowColor = UIColor.black.cgColor
        let shadowOffset = CGSize(width: 0, height: 0)
        let shadowOpacity: Float = 0.4
        let shadowRadius: CGFloat = 8
        
        for button in ShadowButtonsOutlet {
            if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
                button.tintColor = selectedTintColor
            }
            button.layer.shadowColor = shadowColor
            button.layer.shadowOffset = shadowOffset
            button.layer.shadowOpacity = shadowOpacity
            button.layer.shadowRadius = shadowRadius
            button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
            button.layer.masksToBounds = false
        }
    }
    
    
    //MARK: - Buttons Functions
    
    @IBAction func EraseButton(_ sender: UIButton) {
        if var text = FromLabelOutlet.text, text != "0" {
            if !text.isEmpty {
                text.removeLast()
            }
            FromLabelOutlet.text = text
            if text.isEmpty {
                AnimationManager().animateTextSlide(label: FromLabelOutlet, newText: "0")
            }
            
            guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
        }
    }
    
    @IBAction func ChangeUnitButton(_ sender: UIButton) {
        //unit change functionality
    }
    
    @IBAction func AllClearButton(_ sender: UIButton) {
        if FromLabelOutlet.text == "0" { return }
        AnimationManager().animateTextSlide(label: FromLabelOutlet, newText: "0")
        
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    @IBAction func NumberButtons(_ sender: UIButton) {
        guard let buttonNumber = sender.titleLabel?.text else { return }
        guard var currentText = FromLabelOutlet.text else { return }
        
        let parts = currentText.components(separatedBy: ".")
        let hasDecimal = currentText.contains(".")
        
        if hasDecimal, parts[1].count >= 6 { return }
        if !hasDecimal, currentText.count >= 9 { return }
        if currentText == "0" { currentText = "" }
        FromLabelOutlet.text = currentText + buttonNumber
    }
    
    @IBAction func DecimalButton(_ sender: UIButton) {
        if let fromText = FromLabelOutlet.text {
            guard !fromText.contains(".") else { return }
            FromLabelOutlet.text = fromText + "."
        }
    }
    
    
    //MARK: - Units Logic
    
    func UnitMenu(in button: UIButton) {
        if selectedUnits[FromButtonOutlet] == nil {
            selectedUnits[FromButtonOutlet] = .centimeters
        }
        
        if selectedUnits[ToButtonOutlet] == nil {
            selectedUnits[ToButtonOutlet] = .kilometers
        }
        
        let selectedUnit = selectedUnits[button] ?? .meters
        
        let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let actions = UnitsModel().lengthDictionary.keys
            .sorted{ ($0.description) < ($1.description) }
            .enumerated()
            .map { index, option in
            let description = UnitsModel().lengthDictionary[option]
            return UIAction(
                title: option.symbol,
                subtitle: description,
                image: option == selectedUnits[button] ? checkmarkImage!.withTintColor(selectedTintColor, renderingMode: .alwaysOriginal) : nil
            ) { _ in
                self.selectedUnits[button] = option
                button.setTitle("\(option.symbol) ", for: .normal)
                self.UnitMenu(in: button)
            }
        }
        
        let menu = UIMenu(title: "Choose unit:", options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.setTitle("\(selectedUnit.symbol) ", for: .normal)
        
        guard UserDefaults.standard.bool(forKey: "HapticState") else { return }
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
    
    
    
}
