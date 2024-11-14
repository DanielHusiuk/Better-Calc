//
//  StandardViewController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 06.08.2024.
//

import UIKit
import CoreData

class StandardViewController: UIViewController {
    
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
    
    private var currentOperation: Operation?
    private var firstOperand: Double?
    
    private var eraseTimer: Timer?
    private var isErasing = false
    
    var coreData = CoreDataManager.shared
    var isTypingNumber = false
    
    enum Operation: Int {
        case addition = 11
        case subtraction = 12
        case multiplication = 13
        case division = 14
        case percentage = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonShadows()
        applyShadowWithInsets(to: NumbersViewOutlet, cornerRadius: 20)
        applyShadowWithInsets(to: CalculatorImageOutlet, cornerRadius: 30)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyButton()
    }
    
    //MARK: - View Shadow
    
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
            button.layer.shadowColor = shadowColor
            button.layer.shadowOffset = shadowOffset
            button.layer.shadowOpacity = shadowOpacity
            button.layer.shadowRadius = shadowRadius
            button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.layer.cornerRadius).cgPath
            button.layer.masksToBounds = false
        }
    }
    
    func historyButton() {
        let historyButton = HistoryButtonOutlet
        if coreData.fetchObjects(with: 1).count == 0 {
            historyButton!.isEnabled = false
        } else {
            historyButton!.isEnabled = true
        }
    }
    
    @IBAction func EraseButtonLongPress(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            isErasing = true
            eraseTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(eraseButton), userInfo: nil, repeats: true)
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
        WorkingsLabelOutlet.text = "0"
        ResultsLabelOutlet.text = "0"
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
            }
        }
    }
    
    @IBAction func operationButtonPressed(_ sender: UIButton) {
        if (WorkingsLabelOutlet.text == "0") {
            return
        } else {
            guard let operation = Operation(rawValue: sender.tag) else {
                print("Operation button pressed but tag is not valid")
                return
            }
            
            if let lastDot = WorkingsLabelOutlet.text, lastDot.last == "." {
                return
            } else {
                if let text = WorkingsLabelOutlet.text, !text.isEmpty {
                    if currentOperation != nil {
                        let components = text.components(separatedBy: " ")
                        guard components.count > 2 else { return }
                        
                        let secondOperandString = components[2]
                        if operation == .percentage {
                            if let secondOperand = Double(secondOperandString) {
                                let percentageValue = firstOperand! * (secondOperand / 100)
                                let roundedPercentageValue = Double(round(1000000 * percentageValue) / 1000000)
                                WorkingsLabelOutlet.text = components[0] + " \(components[1]) " + String(roundedPercentageValue)
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
                                let percentageValue = value / 100
                                WorkingsLabelOutlet.text = String(percentageValue)
                                currentOperation = nil
                            }
                        }
                    }
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
                    secondOperand = firstOperand * (percentageValue / 100)
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
            if secondOperand == 0 {
                return
            }
            result = firstOperand / secondOperand
        case .percentage:
            result = secondOperand
        }
        
        if let result = result {
            if result >= 1e9 || result <= -1e9 {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .scientific
                numberFormatter.maximumFractionDigits = 2
                numberFormatter.exponentSymbol = "e"
                
                if let formattedResult = numberFormatter.string(from: NSNumber(value: result)) {
                    ResultsLabelOutlet.text = formattedResult
                }
            } else if result.truncatingRemainder(dividingBy: 1) != 0 {
                let roundedResult = Double(round(1000000 * result) / 1000000)
                ResultsLabelOutlet.text = String(roundedResult)
            } else {
                ResultsLabelOutlet.text = String(format: "%.0f", result)
            }
            isTypingNumber = false
            
            if let resultText = ResultsLabelOutlet.text, resultText.contains("e") {
                return
            } else if PasteResultButtonOutlet.isHidden == true {
                PasteResultButtonOutlet.alpha = 0.0
                PasteResultButtonOutlet.isHidden = false
                UIView.animate(withDuration: 0.1, animations: {
                    self.PasteResultButtonOutlet.alpha = 1.0
                })
            }
            
            let historyItems = coreData.fetchObjects(with: 1)
            if let lastOperation = WorkingsLabelOutlet.text, lastOperation.last == " " {
                return
            } else {
                if historyItems.contains(where: { $0.working == WorkingsLabelOutlet.text }) {
                    return
                } else {
                    CoreDataManager.shared.createHistoryObject(1, date: Date(), result: ResultsLabelOutlet.text!, working: WorkingsLabelOutlet.text!)
                    historyButton()
                }
            }
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
            }
        }
    }
    
    //MARK: - Other Buttons
    
    @IBAction @objc func eraseButton(_ sender: UIButton) {
        if var text = WorkingsLabelOutlet.text, !text.isEmpty {
            let operations = "+−×÷"
            let trimmedText = text.trimmingCharacters(in: .whitespaces)
            
            if !trimmedText.isEmpty {
                let lastChar = trimmedText.last
                if let lastChar = lastChar, operations.contains(lastChar) {
                    let range = trimmedText.range(of: " \(lastChar)", options: .backwards)
                    if let range = range {
                        text.removeSubrange(range)
                    } else {
                        text.removeLast()
                    }
                    
                    WorkingsLabelOutlet.text = text.trimmingCharacters(in: .whitespaces)
                    currentOperation = nil
                    isTypingNumber = true
                } else {
                    text = String(text.dropLast())
                    if text.last == " " {
                        text = String(text.dropLast())
                    }
                    
                    WorkingsLabelOutlet.text = text.trimmingCharacters(in: .whitespaces)
                    
                    if text.isEmpty {
                        WorkingsLabelOutlet.text = "0"
                        ResultsLabelOutlet.text = "0"
                        isTypingNumber = false
                        
                        UIView.animate(withDuration: 0.1, animations: {
                            self.PasteResultButtonOutlet.alpha = 0.0
                            self.EraseButtonOutlet.alpha = 0.0
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.PasteResultButtonOutlet.isHidden = true
                            self.EraseButtonOutlet.isHidden = true
                        }
                    }
                }
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
        } else {
            if let currentText = WorkingsLabelOutlet.text, currentOperation != nil {
                WorkingsLabelOutlet.text = currentText + "\(number)"
            } else {
                WorkingsLabelOutlet.text = "\(number)"
            }
            isTypingNumber = true
            
            if EraseButtonOutlet.isHidden == true {
                EraseButtonOutlet.alpha = 0.0
                EraseButtonOutlet.isHidden = false
                UIView.animate(withDuration: 0.1, animations: {
                    self.EraseButtonOutlet.alpha = 1.0
                })
            }
        }
    }
    
    @IBAction func pasteResult(_ sender: UIButton) {
            if let resultText = ResultsLabelOutlet.text, resultText != "0" {
                WorkingsLabelOutlet.text = resultText
                ResultsLabelOutlet.text = "0"
                firstOperand = nil
                currentOperation = nil
                isTypingNumber = true
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                self.PasteResultButtonOutlet.alpha = 0.0
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.PasteResultButtonOutlet.isHidden = true
            }
        }
    
    
}

    //MARK: - Extensions

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious

        let shadowBounds = containerView.bounds.insetBy(dx: 12, dy: 20)
        containerView.layer.shadowPath = UIBezierPath(roundedRect: shadowBounds, cornerRadius: cornerRadious).cgPath

        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
