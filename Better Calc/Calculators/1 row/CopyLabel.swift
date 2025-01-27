//
//  CopyLabel.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 15.08.2024.
//

import UIKit

let navControllr = NavigationController()

class CopyLabel: UILabel, UIEditMenuInteractionDelegate {
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.sharedInit()
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.sharedInit()
        }
    
    //MARK: - Preference
    
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
    
    
    //MARK: - CopyUI
    
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
    
        override func copy(_ sender: Any?) {
            let board = UIPasteboard.general
            board.string = text
            
            if let navController = findNavigationController() {
                navController.coppiedPill()
            }
            
            let menu = UIMenuController.shared
            menu.showMenu(from: self, rect: self.bounds)
        }
    
        override var canBecomeFirstResponder: Bool {
            return true
        }
    
        override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            return action == #selector(UIResponderStandardEditActions.copy)
        }
}
