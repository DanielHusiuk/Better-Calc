//
//  ButtonsModel.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 01.08.2024.
//

import UIKit

struct Button {
    let id: Int16
    var text: String
    var image: UIImage
    var segue: String
}

struct ButtonsModel {
    var buttons: [Button] = [
        Button( id: 1,    text: "Basic",      image: UIImage(named: "plus.forwardslash.minus.svg")!,    segue: "BasicSegue"),
//        Button( id: 2,    text: "Scientific",    image: UIImage(named: "x.squareroot.svg")!,              segue: "ScientificSegue"),
//        Button( id: 3,    text: "Currency",      image: UIImage(named: "dollarsign.svg")!,               segue: "CurrencySegue"),
//        Button( id: 4,    text: "Crypto",        image: UIImage(named: "bitcoinsign.svg")!,              segue: "CryptoSegue"),
        Button( id: 5,    text: "Length",        image: UIImage(named: "ruler.svg")!,                   segue: "LengthSegue"),
        Button( id: 6,    text: "Area",          image: UIImage(named: "arrow.left.right.square.svg")!,    segue: "AreaSegue"),
        Button( id: 7,    text: "Volume",        image: UIImage(named: "cube.svg")!,                    segue: "VolumeSegue"),
        Button( id: 8,    text: "Temperature",    image: UIImage(named: "thermometer.medium.svg")!,        segue: "TemperatureSegue"),
//        Button( id: 9,    text: "Date",          image: UIImage(named: "calendar.svg")!,                 segue: "DateSegue"),
//        Button( id: 10,   text: "Age",           image: UIImage(named: "birthday.cake.svg")!,            segue: "AgeSegue"),
        Button( id: 11,   text: "Time",          image: UIImage(named: "clock.svg")!,                   segue: "TimeSegue"),
        Button( id: 12,   text: "Speed",         image: UIImage(named: "gauge.speed.svg")!,              segue: "SpeedSegue"),
        Button( id: 13,   text: "Mass",          image: UIImage(named: "scalemass.svg")!,                segue: "MassSegue"),
        Button( id: 14,   text: "Count System",   image: UIImage(named: "01.square.svg")!,                segue: "CountSegue"),
//        Button( id: 15,   text: "Discount",       image: UIImage(named: "tag.svg")!,                     segue: "DiscountSegue"),
//        Button( id: 16,   text: "Investition",    image: UIImage(named: "chart.line.svg")!,               segue: "InvestitionSegue"),
//        Button( id: 17,   text: "Loan",          image: UIImage(named: "creditcard.svg")!,               segue: "LoanSegue"),
//        Button( id: 18,   text: "Tips",          image: UIImage(named: "centsign.circle.svg")!,           segue: "TipsSegue"),
//        Button( id: 19,   text: "BMI",           image: UIImage(named: "heart.text.square.svg")!,         segue: "BmiSegue"),
        Button( id: 20,   text: "Settings",       image: UIImage(named: "gear.svg")!,                    segue: "SettingsSegue")
    ]
    
}
