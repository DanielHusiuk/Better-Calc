//
//  LabelFormattingManager.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 14.02.2025.
//

class LabelFormattingManager {
    
    func formatNumber(_ number: Double) -> String {
        if abs(number) >= 1e6 || (abs(number) < 1e-6 && number != 0) {
            return String(format: "%.8e", number)
        } else {
            let formattedString = String(format: "%.6f", number)
            return formattedString.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
        }
    }
    
}
