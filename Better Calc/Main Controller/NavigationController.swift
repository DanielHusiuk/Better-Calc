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
    
}
