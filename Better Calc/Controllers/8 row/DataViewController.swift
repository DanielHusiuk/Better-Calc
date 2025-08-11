//
//  DataViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 14.02.2025.
//

import UIKit
import CoreData

class DataViewController: UIViewController {
    
    @IBOutlet var CalculatorViewOutlet: UIView!
    @IBOutlet weak var CalculatorImageOutlet: UIImageView!
    @IBOutlet var ShadowButtonsOutlet: [UIButton]!
    @IBOutlet weak var HistoryButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var FromNumberImageOutlet: UIImageView!
    @IBOutlet weak var FromTextOutlet: UILabel!
    @IBOutlet weak var FromLabelOutlet: UILabel!
    @IBOutlet weak var FromButtonOutlet: UIButton!
    
    @IBOutlet weak var ToNumberImageOutlet: UIImageView!
    @IBOutlet weak var ToTextOutlet: UILabel!
    @IBOutlet weak var ToLabelOutlet: UILabel!
    @IBOutlet weak var ToButtonOutlet: UIButton!
    
    let coreData = CoreDataManager.shared
    let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")!
    let screenHeight = UIScreen.main.bounds.height
    private var eraseTimer: Timer?
    
    var selectedUnits: [UIButton: UnitInformationStorage] = [:]
    let converterId: Int64 = 9
    var inactivityTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferences()
        isSmallScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyButton()
        loadViewState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveViewState()
        saveCoreData()
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
            selectedUnits[FromButtonOutlet] = .megabytes
        }
        if selectedUnits[ToButtonOutlet] == nil {
            selectedUnits[ToButtonOutlet] = .terabytes
        }
        
        UnitMenu(in: FromButtonOutlet)
        UnitMenu(in: ToButtonOutlet)
        FromTextOutlet.text = NSLocalizedString("from_text", comment: "")
        ToTextOutlet.text = NSLocalizedString("to_text", comment: "")
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
    
    func isSmallScreen() {
        if screenHeight < 737 {
            CalculatorViewOutlet.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            NSLayoutConstraint.activate([
                CalculatorViewOutlet.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10)
            ])
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
    
    @IBAction func HistoryButtonAction(_ sender: UIBarButtonItem) {
        saveCoreData()
        performSegue(withIdentifier: "DataHistory", sender: self)
    }
    
    // MARK: - Save/Load State
    
    func saveViewState() {
        guard UserDefaults.standard.bool(forKey: "KeepState") else { return }
        let fromTextObject = FromLabelOutlet.text
        let toTextObject = ToLabelOutlet.text
        
        let sortedUnits = UnitsModel().storageDictionary.keys.sorted{ ($0.description) < ($1.description) }
        let fromUnitIndexObject = selectedUnits[FromButtonOutlet].flatMap{ sortedUnits.firstIndex(of: $0) } ?? 0
        let toUnitIndexObject = selectedUnits[ToButtonOutlet].flatMap { sortedUnits.firstIndex(of: $0) } ?? 0
        
        CoreDataManager.shared.saveConverterState(
            id: converterId,
            fromText: fromTextObject!,
            toText: toTextObject!,
            fromUnit: Int64(fromUnitIndexObject),
            toUnit: Int64(toUnitIndexObject)
        )
    }
    
    func loadViewState() {
        guard UserDefaults.standard.bool(forKey: "KeepState") else { return }
        if let state = CoreDataManager.shared.loadConverterState(with: converterId) {
            FromLabelOutlet.text = state.fromText ?? "0"
            ToLabelOutlet.text = state.toText ?? "0"
            
            let sortedUnits = UnitsModel().storageDictionary.keys.sorted{ ($0.description) < ($1.description) }
            if sortedUnits.indices.contains(Int(state.fromUnit)) {
                let fromUnits = sortedUnits[Int(state.fromUnit)]
                selectedUnits[FromButtonOutlet] = fromUnits
                FromButtonOutlet.setTitle("\(fromUnits.symbol) ", for: .normal)
            }
            if sortedUnits.indices.contains(Int(state.toUnit)) {
                let toUnits = sortedUnits[Int(state.toUnit)]
                selectedUnits[ToButtonOutlet] = toUnits
                ToButtonOutlet.setTitle("\(toUnits.symbol) ", for: .normal)
            }
            
            UnitMenu(in: FromButtonOutlet)
            UnitMenu(in: ToButtonOutlet)
            convertFunc()
        }
    }
    
    
    //MARK: - History Logic
    
    func historyButton() {
        if coreData.fetchConverterObjects(with: converterId).count == 0 {
            HistoryButtonOutlet.isEnabled = false
        } else {
            HistoryButtonOutlet.isEnabled = true
        }
    }
    
    func saveCoreData() {
        let historyItems = coreData.fetchConverterObjects(with: converterId)
        let sortedUnits = UnitsModel().storageDictionary.keys.sorted{ ($0.description) < ($1.description) }
        let fromUnitIndex = selectedUnits[FromButtonOutlet].flatMap{ sortedUnits.firstIndex(of: $0) } ?? 0
        let toUnitIndex = selectedUnits[ToButtonOutlet].flatMap { sortedUnits.firstIndex(of: $0) } ?? 0
        
        if FromLabelOutlet.text == "0" || FromLabelOutlet.text == "0." {
            return
        } else if historyItems.contains(where: { $0.fromText == FromLabelOutlet.text }) &&
                    historyItems.contains(where: { $0.toText == ToLabelOutlet.text }) &&
                    historyItems.contains(where: { $0.fromUnit == Int64(fromUnitIndex) }) &&
                    historyItems.contains(where: { $0.toUnit == Int64(toUnitIndex) }) {
            return
        } else {
            if FromLabelOutlet.text?.last == "." { FromLabelOutlet.text?.removeLast() }
            CoreDataManager.shared.createConverterHistoryObject(
                converterId,
                date: Date(),
                
                fromText: FromLabelOutlet.text!,
                fromUnit: Int64(fromUnitIndex),
                fromUnitText: (FromButtonOutlet.titleLabel?.text)!,
                
                toText: ToLabelOutlet.text!,
                toUnit: Int64(toUnitIndex),
                toUnitText: (ToButtonOutlet.titleLabel?.text)!)
            
            historyButton()
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
                if coreData.fetchConverterObjects(with: converterId).count == 0 {
                    HistoryButtonOutlet.isEnabled = false
                }
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
        saveCoreData()
    }
    
    @IBAction func AllClearButton(_ sender: UIButton) {
        if FromLabelOutlet.text == "0" { return }
        AnimationManager().animateTextSlide(label: FromLabelOutlet, newText: "0")
        AnimationManager().animateTextSlide(label: ToLabelOutlet, newText: "0")
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        saveViewState()
        if coreData.fetchConverterObjects(with: converterId).count == 0 {
            HistoryButtonOutlet.isEnabled = false
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
        saveViewState()
        if coreData.fetchConverterObjects(with: converterId).count == 0 {
            HistoryButtonOutlet.isEnabled = true
        }
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
        
        let actions = UnitsModel().storageDictionary.keys
            .sorted{ ($0.description) < ($1.description) }
            .enumerated()
            .map { index, option in
                let description = UnitsModel().storageDictionary[option]
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
                    
                    if UserDefaults.standard.bool(forKey: "HapticState") {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    }
                }
            }
        
        let menu = UIMenu(title: NSLocalizedString("choose_unit", comment: ""), options: .displayInline, children: actions)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.titleLabel?.numberOfLines = 2
        button.setTitle("\(selectedUnit.symbol) ", for: .normal)
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
