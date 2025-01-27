//
//  PasteLabel.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 25.08.2024.
//

import UIKit

let basicController = BasicViewController()
let navController = NavigationController()

class PasteLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    
    //MARK: - Preferences
    
    func findNavigationController() -> NavigationController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let navigationController = nextResponder as? NavigationController {
                return navigationController
            }
            responder = nextResponder
        }
        return nil
    }
    
    func findBasicController() -> BasicViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let basicController = nextResponder as? BasicViewController {
                return basicController
            }
            responder = nextResponder
        }
        return nil
    }
    
    
    //MARK: - PasteUI

    func sharedInit() {
        self.isUserInteractionEnabled = true
        if traitCollection.userInterfaceStyle == .dark {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
        }
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }

    @objc func showMenu(sender: AnyObject?) {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: self.bounds)
        }
    }

    override func paste(_ sender: Any?) {
        let board = UIPasteboard.general
        if let pastedText = board.string {
            let normalizedText = normalizeDecimalSeparator(pastedText)
            if isValidNumber(normalizedText) && countCheck(for: normalizedText) {
                if self.text == "0" {
                    self.text = normalizedText
                    if let basicController = findBasicController() {
                        basicController.checkEraseButton()
                    }
                } else if let currentText = self.text {
                    self.text = currentText + normalizedText
                }
            } else {
                if let navController = findNavigationController() {
                    navController.cannotPasteError()
                }
                print("Cannot paste")
            }
        }
        let menu = UIMenuController.shared
        menu.showMenu(from: self, rect: self.bounds)
    }

    func countCheck(for text: String) -> Bool {
        let hasDecimalPoint = text.contains(".")
        if hasDecimalPoint {
            let parts = text.components(separatedBy: ".")
            if parts.count == 2 {
                let beforeDecimal = parts[0].count
                let afterDecimal = parts[1].count
                if beforeDecimal <= 9 && afterDecimal <= 6 {
                    return true
                }
            }
        } else {
            if text.count <= 9 {
                return true
            }
        }
        return false
    }

    func isValidNumber(_ text: String) -> Bool {
        let numberRegEx = "^-?\\d*(\\.\\d+)?$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return predicate.evaluate(with: text)
    }

    func normalizeDecimalSeparator(_ text: String) -> String {
        var normalizedText = text
        normalizedText = normalizedText.replacingOccurrences(of: ",", with: ".")
        let unwantedSymbols = ["%", "*", "/", "÷", "×"]
        for symbol in unwantedSymbols {
            normalizedText = normalizedText.replacingOccurrences(of: symbol, with: "")
        }
        return normalizedText
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.paste)
    }
}
