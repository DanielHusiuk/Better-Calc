//
//  BasicViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 06.08.2024.
//

import UIKit
import CoreData

class BasicViewController: UIViewController {
    
    @IBOutlet weak var WorkingsLabelOutlet: UILabel!
    @IBOutlet weak var ResultsLabelOutlet: UILabel!
    
    @IBOutlet weak var EraseButtonOutlet: UIButton!
    @IBOutlet weak var PasteResultButtonOutlet: UIButton!
    @IBOutlet weak var HistoryButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var CalculatorViewOutlet: UIView!
    @IBOutlet weak var CalculatorImageOutlet: UIImageView!
    @IBOutlet weak var NumbersViewOutlet: UIView!
    @IBOutlet weak var NumbersImageOutlet: UIImageView!
    
    @IBOutlet var ShadowButtonsOutlet: [UIButton]!
    
    var currentOperation: Operation?
    var firstOperand: Double?
    
    private var eraseTimer: Timer?
    private var isErasing = false
    
    var coreData = CoreDataManager.shared
    var calculatorId: Int64 = 1
    
    var isTypingNumber = false
    let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor")!
    let screenHeight = UIScreen.main.bounds.height
    
    enum Operation: Int {
        case addition = 11
        case subtraction = 12
        case multiplication = 13
        case division = 14
        case percentage = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        checkEraseButton()
        checkPasteButton()
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyShadowWithInsets(to: NumbersViewOutlet, cornerRadius: 20)
        applyShadowWithInsets(to: CalculatorImageOutlet, cornerRadius: 30)
        buttonShadows()
    }
    
    
    //MARK: - View Preferences
    
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
    
    
    // MARK: - Save/Load State
    
    func saveViewState() {
        guard UserDefaults.standard.bool(forKey: "KeepState") else { return }
        let workingsObject = WorkingsLabelOutlet.text ?? ""
        let resultsObject = ResultsLabelOutlet.text ?? ""
        let operationValueObject = currentOperation?.rawValue
        
        CoreDataManager.shared.saveBasicState(
            workings: workingsObject,
            results: resultsObject,
            isTypingNumber: isTypingNumber,
            firstOperand: firstOperand,
            currentOperation: operationValueObject
        )
    }
    
    func loadViewState() {
        guard UserDefaults.standard.bool(forKey: "KeepState") else { return }
        if let state = CoreDataManager.shared.loadBasicState() {
            WorkingsLabelOutlet.text = state.workingsText ?? "0"
            ResultsLabelOutlet.text = state.resultsText ?? "0"
            isTypingNumber = state.isTypingNumber
            firstOperand = state.firstOperand
            currentOperation = Operation(rawValue: Int(state.currentOperation))
            
            checkEraseButton()
            if let results = ResultsLabelOutlet.text, results.contains("e") {
                return
            } else {
                checkPasteButton()
            }
        }
    }
    
    
    // MARK: - Button Preferences
    
    func buttonShadows() {
        let shadowColor = UIColor.black.cgColor
        let shadowOffset = CGSize(width: 0, height: 0)
        let shadowOpacity: Float = 0.4
        let shadowRadius: CGFloat = 8
        
        for button in ShadowButtonsOutlet {
            button.tintColor = selectedTintColor
            button.layer.shadowColor = shadowColor
            button.layer.shadowOffset = shadowOffset
            button.layer.shadowOpacity = shadowOpacity
            button.layer.shadowRadius = shadowRadius
            button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
            button.layer.masksToBounds = false
        }
    }
    
    func checkEraseButton() {
        if WorkingsLabelOutlet.text != "0" {
            EraseButtonOutlet.alpha = 0.0
            EraseButtonOutlet.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.EraseButtonOutlet.alpha = 1.0
            })
        }
    }
    
    func checkPasteButton() {
        if ResultsLabelOutlet.text != "0" {
            PasteResultButtonOutlet.alpha = 0.0
            PasteResultButtonOutlet.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.PasteResultButtonOutlet.alpha = 1.0
            })
        }
    }
    
    func historyButton() {
        if coreData.fetchCalculatorObjects(with: calculatorId).count == 0 {
            HistoryButtonOutlet.isEnabled = false
        } else {
            HistoryButtonOutlet.isEnabled = true
        }
    }
    
    @IBAction func EraseButtonLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            isErasing = true
            eraseTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(eraseButton), userInfo: nil, repeats: true)
            RunLoop.current.add(eraseTimer!, forMode: .common)
        case .ended:
            isErasing = false
            eraseTimer?.invalidate()
            eraseTimer = nil
        default:
            break
        }
    }
    
    
    // MARK: - Function Buttons
    
    @IBAction func allClearButton(_ sender: UIButton!) {
        if WorkingsLabelOutlet.text == "0" { return }
        AnimationManager().animateTextSlide(label: WorkingsLabelOutlet, newText: "0")
        
        if ResultsLabelOutlet.text != "0" {
            AnimationManager().animateTextSlide(label: ResultsLabelOutlet, newText: "0")
        }
        
        firstOperand = nil
        currentOperation = nil
        isTypingNumber = false
        
        UIView.animate(withDuration: 0.1, animations: {
            self.PasteResultButtonOutlet.alpha = 0.0
            self.EraseButtonOutlet.alpha = 0.0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.PasteResultButtonOutlet.isHidden = true
            self.EraseButtonOutlet.isHidden = true
        }
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        saveViewState()
    }
    
    @IBAction func plusMinusButton(_ sender: UIButton) {
        if (WorkingsLabelOutlet.text == "0") {
            return
        } else if let lastDot = WorkingsLabelOutlet.text, lastDot.last == "." {
            return
        } else {
            guard var text = WorkingsLabelOutlet.text else { return }
            var components = text.components(separatedBy: " ")
            if let lastComponent = components.last, let value = Double(lastComponent) {
                let newValue = -value
                if newValue.truncatingRemainder(dividingBy: 1) == 0 {
                    components[components.count - 1] = String(format: "%.0f", newValue)
                } else {
                    components[components.count - 1] = String(newValue)
                }
                text = components.joined(separator: " ")
                WorkingsLabelOutlet.text = text
                saveViewState()
            }
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        if (WorkingsLabelOutlet.text == "0") {
            return
        } else {
            guard let operation = Operation(rawValue: sender.tag) else { return }
            
            if let lastDot = WorkingsLabelOutlet.text, lastDot.last == "." {
                return
            } else {
                if let text = WorkingsLabelOutlet.text, !text.isEmpty {
                    if currentOperation != nil {
                        var components = text.components(separatedBy: " ")
                        guard components.count > 1 else { return }
                        
                        if operation == .percentage {
                            if let lastComponent = components.last, let secondOperand = Double(lastComponent) {
                                let percentageValue = firstOperand! * (secondOperand * 0.01)
                                let formattedValue = LabelFormattingManager().formatNumber(percentageValue)
                                components[components.count - 1] = formattedValue
                                WorkingsLabelOutlet.text = components.joined(separator: " ")
                            }
                            return
                        }
                    } else {
                        if let value = Double(text) {
                            firstOperand = value
                            isTypingNumber = false
                            currentOperation = operation
                            
                            switch operation {
                            case .addition:
                                WorkingsLabelOutlet.text = text + " + "
                            case .subtraction:
                                WorkingsLabelOutlet.text = text + " − "
                            case .multiplication:
                                WorkingsLabelOutlet.text = text + " × "
                            case .division:
                                WorkingsLabelOutlet.text = text + " ÷ "
                            case .percentage:
                                let percentageValue = value * 0.01
                                WorkingsLabelOutlet.text = LabelFormattingManager().formatNumber(percentageValue)
                                currentOperation = nil
                            }
                        }
                    }
                    saveViewState()
                }
            }
        }
    }
    
    @IBAction func equalsButton(_ sender: UIButton) {
        guard let operation = currentOperation, let text = WorkingsLabelOutlet.text else { return }
        
        let components = text.components(separatedBy: " ")
        guard components.count >= 2 else { return }
        
        let firstOperandString = components[0]
        guard let firstOperand = Double(firstOperandString) else { return }
        
        var secondOperand: Double = 0.0
        
        if components.count > 2 {
            var secondOperandString = components[2]
            if secondOperandString.contains("%") {
                secondOperandString = secondOperandString.replacingOccurrences(of: "%", with: "")
                if let percentageValue = Double(secondOperandString) {
                    secondOperand = firstOperand * (percentageValue * 0.01)
                }
            } else {
                secondOperand = Double(secondOperandString) ?? 0.0
            }
        }
        
        if secondOperand == 0 {
            return
        }
        
        var result: Double?
        switch operation {
        case .addition:
            result = firstOperand + secondOperand
        case .subtraction:
            result = firstOperand - secondOperand
        case .multiplication:
            result = firstOperand * secondOperand
        case .division:
            if secondOperand != 0 {
                result = firstOperand / secondOperand
            }
        case .percentage:
            result = secondOperand
        }
        
        if let result = result {
            ResultsLabelOutlet.text = LabelFormattingManager().formatNumber(result)
            
            isTypingNumber = false
            
            if let resultText = ResultsLabelOutlet.text, resultText.contains("e") {
                return
            } else if PasteResultButtonOutlet.isHidden {
                checkPasteButton()
            }
            
            let historyItems = coreData.fetchCalculatorObjects(with: calculatorId)
            if let lastOperation = WorkingsLabelOutlet.text, lastOperation.last == " " {
                return
            } else {
                if historyItems.contains(where: { $0.working == WorkingsLabelOutlet.text }) {
                    return
                } else {
                    CoreDataManager.shared.createCalculatorHistoryObject(1, date: Date(), result: ResultsLabelOutlet.text!, working: WorkingsLabelOutlet.text!)
                    historyButton()
                    saveViewState()
                }
            }
        }
        
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
    
    @IBAction func decimalButton(_ sender: UIButton) {
        if let text = WorkingsLabelOutlet.text {
            let components = text.components(separatedBy: " ")
            if let lastComponent = components.last, !lastComponent.contains(".") {
                let parts = lastComponent.components(separatedBy: ".")
                if parts.count == 2, parts[1].count >= 6 {
                    return
                }
                WorkingsLabelOutlet.text = text + "."
                isTypingNumber = true
                saveViewState()
            }
        }
    }
    
    
    //MARK: - Other Buttons
    
    @IBAction @objc func eraseButton(_ sender: UIButton) {
        if var text = WorkingsLabelOutlet.text, text != "0" {
            let operations = "+−×÷"
            
            if text.hasSuffix(" ") {
                text.removeLast()
            }
            
            if let lastChar = text.last, operations.contains(lastChar) {
                text = String(text.dropLast(2))
                currentOperation = nil
                isTypingNumber = true
                saveViewState()
            } else {
                text = String(text.dropLast())
                saveViewState()
            }
            WorkingsLabelOutlet.text = text
            
            if text.isEmpty {
                AnimationManager().animateTextSlide(label: WorkingsLabelOutlet, newText: "0")
                
                if ResultsLabelOutlet.text != "0" {
                    AnimationManager().animateTextSlide(label: ResultsLabelOutlet, newText: "0")
                }
                isTypingNumber = false
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.PasteResultButtonOutlet.alpha = 0.0
                    self.EraseButtonOutlet.alpha = 0.0
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.PasteResultButtonOutlet.isHidden = true
                    self.EraseButtonOutlet.isHidden = true
                }
                saveViewState()
            }
            if UserDefaults.standard.bool(forKey: "HapticState") {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        }
    }
    
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        let number = sender.tag
        let currentText = WorkingsLabelOutlet.text ?? ""
        
        let components = currentText.components(separatedBy: " ")
        guard let lastComponent = components.last else {
            WorkingsLabelOutlet.text = "\(number)"
            isTypingNumber = true
            return
        }
        
        let hasDecimalPoint = lastComponent.contains(".")
        if hasDecimalPoint {
            let parts = lastComponent.components(separatedBy: ".")
            if parts.count == 2, parts[1].count >= 6 {
                return
            }
        } else {
            if lastComponent.count >= 9 {
                return
            }
        }
        
        if isTypingNumber {
            let currentText = WorkingsLabelOutlet.text ?? " "
            WorkingsLabelOutlet.text = currentText + "\(number)"
            saveViewState()
        } else {
            if let currentText = WorkingsLabelOutlet.text, currentOperation != nil {
                WorkingsLabelOutlet.text = currentText + "\(number)"
            } else {
                WorkingsLabelOutlet.text = "\(number)"
            }
            isTypingNumber = true
            
            if EraseButtonOutlet.isHidden == true {
                checkEraseButton()
            }
            saveViewState()
        }
    }
    
    @IBAction func pasteResult(_ sender: UIButton) {
        if let resultText = ResultsLabelOutlet.text, resultText != "0" {
            WorkingsLabelOutlet.text = resultText
            AnimationManager().animateTextSlide(label: ResultsLabelOutlet, newText: "0")
            firstOperand = nil
            currentOperation = nil
            isTypingNumber = true
            saveViewState()
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.PasteResultButtonOutlet.alpha = 0.0
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.PasteResultButtonOutlet.isHidden = true
        }
        if UserDefaults.standard.bool(forKey: "HapticState") {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }
    
}
