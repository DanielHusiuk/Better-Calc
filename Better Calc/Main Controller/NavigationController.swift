//
//  NavigationController.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 05.08.2024.
//

import UIKit
import PillboxView

class NavigationController: UINavigationController {
    
    let pill = PillView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didSelectTintColor()
    }
    
    func didSelectTintColor() {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            navigationBar.tintColor = selectedTintColor
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func resButtonPill() {
        pill.isNavigationControllerPresent = true
        pill.showTask(message: "Reset done", vcView: self.view)
        pill.completedTask(state: true)
    }
    
    func delHistoryPill() {
        pill.isNavigationControllerPresent = true
        pill.showTask(message: "History deleted", vcView: self.view)
        pill.completedTask(state: true)
    }
    
    func cannotPasteError() {
        pill.isNavigationControllerPresent = true
        pill.showTask(message: "Cannot paste", vcView: self.view)
        pill.completedTask(state: false)
    }
    
    func coppiedPill() {
        pill.isNavigationControllerPresent = true
        pill.showTask(message: "Result copied", vcView: self.view)
        pill.completedTask(state: true)
    }
    
}
