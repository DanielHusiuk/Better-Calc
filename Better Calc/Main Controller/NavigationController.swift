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
    
    private static var activePills: [PillView] = []
    private static let queue = DispatchQueue(label: "pillbox.queue", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didSelectTintColor()
        settingsVC.updatePreferences()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - Functions
    
    func didSelectTintColor() {
        if let selectedTintColor = UserDefaults.standard.color(forKey: "selectedTintColor") {
            UIView.transition(with: navigationBar, duration: 0.3, options: .transitionCrossDissolve, animations: {self.navigationBar.tintColor = selectedTintColor})
        }
    }
    
    static func showPill(message: String, state: Bool, vcView: UIView) {
        queue.async(flags: .barrier) {
            DispatchQueue.main.async {
                activePills = activePills.filter { $0.vcView != nil }
                
                if activePills.isEmpty {
                    let pill = PillView()
                    pill.isNavigationControllerPresent = true
                    pill.showTask(message: message, vcView: vcView)
                    pill.completedTask(state: state)
                    activePills.append(pill)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        queue.async(flags: .barrier) {
                            activePills.removeAll { $0 === pill }
                        }
                    }
                }
            }
        }
    }
    
    func resButtonPill() {
        NavigationController.showPill(message: NSLocalizedString("pill_reset_done", comment: ""), state: true, vcView: self.view)
    }
    
    func resetError() {
        NavigationController.showPill(message: NSLocalizedString("pill_positions_already_standard", comment: ""), state: false, vcView: self.view)
    }
    
    func positionsError() {
        NavigationController.showPill(message: NSLocalizedString("pill_positions_already_standard", comment: ""), state: false, vcView: self.view)
    }
    
    func delHistoryPill() {
        NavigationController.showPill(message: NSLocalizedString("pill_history_deleted", comment: ""), state: true, vcView: self.view)
    }
    
    func historyError() {
        NavigationController.showPill(message: NSLocalizedString("pill_history_error", comment: ""), state: false, vcView: self.view)
    }
    
    func cannotPasteError() {
        NavigationController.showPill(message: NSLocalizedString("pill_cannot_paste", comment: ""), state: false, vcView: self.view)
    }
    
    func coppiedPill() {
        NavigationController.showPill(message: NSLocalizedString("pill_result_copied", comment: ""), state: true, vcView: self.view)
    }
}
