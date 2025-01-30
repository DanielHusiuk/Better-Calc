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
    let tintModel = TintModel()
    let settingsVC = SettingsViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didSelectTintColor()
        settingsVC.updatePreferences()
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
        pill.showTask(message: NSLocalizedString("pill_reset_done", comment: ""), vcView: self.view)
        pill.completedTask(state: true)
    }
    
    func delHistoryPill() {
        pill.isNavigationControllerPresent = true
        pill.showTask(message: NSLocalizedString("pill_history_deleted", comment: ""), vcView: self.view)
        pill.completedTask(state: true)
    }
    
    func cannotPasteError() {
        pill.isNavigationControllerPresent = true
        pill.showTask(message: NSLocalizedString("pill_cannot_paste", comment: ""), vcView: self.view)
        pill.completedTask(state: false)
    }
    
    func coppiedPill() {
        pill.isNavigationControllerPresent = true
        pill.showTask(message: NSLocalizedString("pill_result_copied", comment: ""), vcView: self.view)
        pill.completedTask(state: true)
    }
    
}
