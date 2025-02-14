//
//  AnimationManager.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 09.02.2025.
//

import UIKit

class AnimationManager {
    
    func animateTextSlide(label: UILabel, newText: String, duration: TimeInterval = 0.08) {
        let translation = CGAffineTransform(translationX: 0, y: -12)
        UIView.animate(withDuration: duration, animations: {
            label.transform = translation
            label.alpha = 0
        }) { _ in
            label.text = newText
            label.transform = CGAffineTransform(translationX: 0, y: 12)
            UIView.animate(withDuration: duration) {
                label.transform = .identity
                label.alpha = 1
            }
        }
    }
    
}
