//
//  CopyLabel.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 15.08.2024.
//

import UIKit

class CopyLabel: UILabel, UIEditMenuInteractionDelegate {
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.sharedInit()
        }
    
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.sharedInit()
        }
    
        func sharedInit() {
            self.isUserInteractionEnabled = true
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
