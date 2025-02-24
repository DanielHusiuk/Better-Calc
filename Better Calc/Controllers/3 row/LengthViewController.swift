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
    private var eraseTimer: Timer?
    
    var selectedUnits: [UIButton: UnitLength] = [:]
    let converterId: Int16 = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferences()
        loadViewState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadViewState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveViewState()
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
        
        if selectedUnits[FromButtonOutlet] == nil {
            selectedUnits[FromButtonOutlet] = .kilometers
        }
        if selectedUnits[ToButtonOutlet] == nil {
            selectedUnits[ToButtonOutlet] = .miles
        }
        
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
    
    func saveViewState() {
        guard UserDefaults.standard.bool(forKey: "KeepState") else { return }
        let fromText = FromLabelOutlet.text
        let toText = ToLabelOutlet.text
        
        let sortedUnits = UnitsModel().lengthDictionary.keys.sorted{ ($0.description) < ($1.description) }
        let fromUnitIndex = selectedUnits[FromButtonOutlet].flatMap{ sortedUnits.firstIndex(of: $0) } ?? 0
        let toUnitIndex = selectedUnits[ToButtonOutlet].flatMap { sortedUnits.firstIndex(of: $0) } ?? 0
        
        CoreDataManager.shared.saveConverterState(
            id: converterId,
            fromText: fromText!,
            toText: toText!,
            fromUnit: Int16(fromUnitIndex),
            toUnit: Int16(toUnitIndex)
        )
    }
    
    func loadViewState() {
        guard UserDefaults.standard.bool(forKey: "KeepState") else { return }
        if let state = CoreDataManager.shared.loadConverterState(with: converterId) {
            FromLabelOutlet.text = state.fromText ?? "0"
            ToLabelOutlet.text = state.toText ?? "0"
            
            let sortedUnits = UnitsModel().lengthDictionary.keys.sorted{ ($0.description) < ($1.description) }
            if sortedUnits.indices.contains(Int(state.fromUnit)) {
                let fromUnit = sortedUnits[Int(state.fromUnit)]
                selectedUnits[FromButtonOutlet] = fromUnit
                FromButtonOutlet.setTitle("\(fromUnit.symbol) ", for: .normal)
                print(fromUnit.symbol)
            }
            if sortedUnits.indices.contains(Int(state.toUnit)) {
                let toUnit = sortedUnits[Int(state.toUnit)]
                selectedUnits[ToButtonOutlet] = toUnit
                ToButtonOutlet.setTitle("\(toUnit.symbol) ", for: .normal)
                print(toUnit.symbol)
            }
            
            UnitMenu(in: FromButtonOutlet)
            UnitMenu(in: ToButtonOutlet)
            convertFunc()
            print("View state loaded.")
        } else {
            print("No saved view state found.")
        }
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
    
    @IBAction func EraseButtonLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            eraseTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(EraseButton), userInfo: nil, repeats: true)
            RunLoop.current.add(eraseTimer!, forMode: .common)
        case .ended:
            eraseTimer?.invalidate()
            eraseTimer = nil
        default:
            break
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
            saveViewState()
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
        saveViewState()
    }
    
    @IBAction func AllClearButton(_ sender: UIButton) {
        if FromLabelOutlet.text == "0" { return }
        AnimationManager().animateTextSlide(label: FromLabelOutlet, newText: "0")
        AnimationManager().animateTextSlide(label: ToLabelOutlet, newText: "0")
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        saveViewState()
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
        saveViewState()
    }
    
    @IBAction func DecimalButton(_ sender: UIButton) {
        if let fromText = FromLabelOutlet.text {
            guard !fromText.contains(".") else { return }
            FromLabelOutlet.text = fromText + "."
            saveViewState()
        }
    }
    
    
    //MARK: - Units Logic
    
    func UnitMenu(in button: UIButton) {
        let isFromButton = (button == FromButtonOutlet)
        let selectedUnit = selectedUnits[button]!
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
                    DispatchQueue.main.async {
                        self.saveViewState()
                    }
                    self.UnitMenu(in: self.FromButtonOutlet)
                    self.UnitMenu(in: self.ToButtonOutlet)
                    print("Selected index: \(index)")
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
        ToLabelOutlet.text = LabelFormattingManager().formatNumber(Double(formattedResult) ?? 0)
    }
    
}
