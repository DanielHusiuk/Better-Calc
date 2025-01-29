//
//  Untitled.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 10.10.2024.
//

import UIKit

let buttonModel = ButtonsModel()
let modelButtons = buttonModel.buttons

class PickerModel: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedSegueIdentifier: String?

    lazy var pickers: [(String, String)] = {
        var allPickers: [(String, String)] = [(NSLocalizedString("settings_none", comment: ""), "")]
        let dynamicPickers = modelButtons.map { ($0.text, $0.segue) }
        allPickers.append(contentsOf: dynamicPickers)
        allPickers.removeLast()
        return allPickers
    }()

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
        selectedSegueIdentifier = pickers[row].1
        print("Selected segue: \(selectedSegueIdentifier ?? NSLocalizedString("settings_none", comment: ""))")
    }
    
}

