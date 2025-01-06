//
//  Untitled.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 10.10.2024.
//

import UIKit

class PickerModel: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let pickers = [
                   ("None",         ""),
                   ("Standard",     "StandardSegue"),
                   ("Scientific",    "ScientificSegue"),
                   ("Currency",     "CurrencySegue"),
                   ("Crypto",       "CryptoSegue"),
                   ("Lenght",       "LenghtSegue"),
                   ("Area",         "AreaSegue"),
                   ("Volume",       "VolumeSegue"),
                   ("Temperature",   "TemperatureSegue"),
                   ("Date",         "DateSegue"),
                   ("Age",          "AgeSegue"),
                   ("Time",         "TimeSegue"),
                   ("Speed",        "SpeedSegue"),
                   ("Mass",         "MassSegue"),
                   ("Count System",  "CountSegue"),
                   ("Discount",     "DiscountSegue"),
                   ("Investition",   "InvestitionSegue"),
                   ("Loan",         "LoanSegue"),
                   ("Tips",         "TipsSegue"),
                   ("BMI",          "BmiSegue")
    ]
    
    var pickerOptions: [String] {
        return pickers.map { $0.0 }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickers.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickers[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedSegueIdentifier = pickers[row].1
//        print("Selected segue: \(selectedSegueIdentifier ?? "None")")
    }
    
}

