//
//  Untitled.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 10.10.2024.
//


import UIKit

struct Picker {
    let id: Int16
    var text: String
    var segue: String
}

struct PickerModel {
    var pickers: [Picker] = [
        Picker(id: 0,    text: "None",         segue: ""),
        Picker(id: 1,    text: "Standard",      segue: "StandardSegue"),
        Picker(id: 2,    text: "Scientific",    segue: "ScientificSegue"),
        Picker(id: 3,    text: "Currency",      segue: "CurrencySegue"),
        Picker(id: 4,    text: "Crypto",        segue: "CryptoSegue"),
        Picker(id: 5,    text: "Lenght",        segue: "LenghtSegue"),
        Picker(id: 6,    text: "Area",          segue: "AreaSegue"),
        Picker(id: 7,    text: "Volume",        segue: "VolumeSegue"),
        Picker(id: 8,    text: "Temperature",    segue: "TemperatureSegue"),
        Picker(id: 9,    text: "Date",          segue: "DateSegue"),
        Picker(id: 10,   text: "Age",           segue: "AgeSegue"),
        Picker(id: 11,   text: "Time",          segue: "TimeSegue"),
        Picker(id: 13,   text: "Speed",         segue: "SpeedSegue"),
        Picker(id: 14,   text: "Mass",          segue: "MassSegue"),
        Picker(id: 15,   text: "Count System",   segue: "CountSegue"),
        Picker(id: 16,   text: "Discount",       segue: "DiscountSegue"),
        Picker(id: 17,   text: "Investition",    segue: "InvestitionSegue"),
        Picker(id: 18,   text: "Loan",          segue: "LoanSegue"),
        Picker(id: 19,   text: "Tips",          segue: "TipsSegue"),
        Picker(id: 20,   text: "BMI",           segue: "BmiSegue")
    ]
    
}

