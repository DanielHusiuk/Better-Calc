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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    
    // MARK: - Save/Load State
    
    

    
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
                AnimationManager().animateTextSlide(label: ToLabelOutlet, newText: "0")
            }
            
            if UserDefaults.standard.bool(forKey: "HapticState") {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
            convertFunc()
        }
    }
    
    @IBAction func ChangeUnitButton(_ sender: UIButton) {
        let selectedUnit1 = selectedUnits[FromButtonOutlet]!
        let selectedUnit2 = selectedUnits[ToButtonOutlet]!
        
        selectedUnits[FromButtonOutlet] = selectedUnit2
        selectedUnits[ToButtonOutlet] = selectedUnit1

        UIView.animate(withDuration: 0.3, animations: {
            UIView.transition(with: self.FromButtonOutlet, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            UIView.transition(with: self.ToButtonOutlet, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            UIView.transition(with: self.ToLabelOutlet, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            self.updatePreferences()
        })
        
        convertFunc()
    }
    
    @IBAction func AllClearButton(_ sender: UIButton) {
        if FromLabelOutlet.text == "0" { return }
        AnimationManager().animateTextSlide(label: FromLabelOutlet, newText: "0")
        AnimationManager().animateTextSlide(label: ToLabelOutlet, newText: "0")
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
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
        
        convertFunc()
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
            selectedUnits[FromButtonOutlet] = .kilometers
        }
        
        if selectedUnits[ToButtonOutlet] == nil {
            selectedUnits[ToButtonOutlet] = .miles
        }
        
        let isFromButton = (button == FromButtonOutlet)
        let selectedUnit = selectedUnits[button] ?? .meters
        let disabledUnit = isFromButton ? selectedUnits[ToButtonOutlet] : selectedUnits[FromButtonOutlet]
        
        let checkmarkImage = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        let actions = UnitsModel().lengthDictionary.keys
            .sorted{ ($0.description) < ($1.description) }
            .enumerated()
            .map { index, option in
                let description = UnitsModel().lengthDictionary[option]
                let isDisabled = (option == disabledUnit)
                return UIAction(
                    title: description!,
                    subtitle: option.symbol,
                    image: option == selectedUnits[button] ? checkmarkImage!.withTintColor(selectedTintColor, renderingMode: .alwaysOriginal) : nil,
                    attributes: isDisabled ? .disabled : []
                ) { _ in
                    self.selectedUnits[button] = option
                    button.setTitle("\(option.symbol) ", for: .normal)
                    self.UnitMenu(in: self.FromButtonOutlet)
                    self.UnitMenu(in: self.ToButtonOutlet)
                }
            }
        
        let menu = UIMenu(title: "Choose unit:", options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.setTitle("\(selectedUnit.symbol) ", for: .normal)
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
        convertFunc()
    }
    
    func convertFunc() {
        guard let doubleValue = Double(FromLabelOutlet.text!) else { return }
        let selectedUnit1 = selectedUnits[FromButtonOutlet]!
        let selectedUnit2 = selectedUnits[ToButtonOutlet]!
        
        let measurement = Measurement(value: doubleValue, unit: selectedUnit1)
        let convertValue = measurement.converted(to: selectedUnit2)
        let formattedResult = String(describing: convertValue).components(separatedBy: " ").first ?? "0"
        ToLabelOutlet.text = formatNumber(Double(formattedResult) ?? 0)
    }
    
    func formatNumber(_ number: Double) -> String {
        if abs(number) >= 1e6 || (abs(number) < 1e-6 && number != 0) {
            return String(format: "%.8e", number)
        } else {
            let formattedString = String(format: "%.6f", number)
            return formattedString.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
        }
    }
    
}
