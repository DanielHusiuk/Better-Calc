//
//  GestureManager.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 18.04.2025.
//

import UIKit

class GestureManager {
    
    static func dismissSwipe(to viewController: UIViewController, edge: UIRectEdge = .left) {
        let gesture = UIScreenEdgePanGestureRecognizer(
            target: viewController,
            action: #selector(viewController.swipedRight(_:))
        )
        gesture.edges = edge
        viewController.view.addGestureRecognizer(gesture)
    }
}

extension UIViewController {
    
    @objc func swipedRight(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
