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
    
    static func popSwipeGesture(to viewController: UIViewController) {
        let popGestureRecognizer = viewController.navigationController?.interactivePopGestureRecognizer
        if let targets = popGestureRecognizer?.value(forKey: "targets") as? NSMutableArray {
            let gestureRecognizer = UIPanGestureRecognizer()
            gestureRecognizer.setValue(targets, forKey: "targets")
            viewController.view.addGestureRecognizer(gestureRecognizer)
        }
    }
}

extension UIViewController {
    
    @objc func swipedRight(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
