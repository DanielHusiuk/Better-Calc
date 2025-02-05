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
        Button( id: 1,    text: NSLocalizedString("button_basic", comment: ""),        image: UIImage(systemName: "plus.forwardslash.minus")!,   segue: "BasicSegue"),
//        Button( id: 2,    text: NSLocalizedString("button_scientific", comment: ""),    image: UIImage(systemName: "x.squareroot")!,            segue: "ScientificSegue"),
//        Button( id: 3,    text: NSLocalizedString("button_currency", comment: ""),     image: UIImage(systemName: "dollarsign")!,               segue: "CurrencySegue"),
//        Button( id: 4,    text: NSLocalizedString("button_crypto", comment: ""),       image: UIImage(systemName: "bitcoinsign")!,              segue: "CryptoSegue"),
        Button( id: 5,    text: NSLocalizedString("button_length", comment: ""),       image: UIImage(systemName: "ruler")!,                   segue: "LengthSegue"),
        Button( id: 6,    text: NSLocalizedString("button_area", comment: ""),         image: UIImage(systemName: "arrow.down.left.and.arrow.up.right.square")!,   segue: "AreaSegue"),
        Button( id: 7,    text: NSLocalizedString("button_volume", comment: ""),       image: UIImage(systemName: "cube")!,                    segue: "VolumeSegue"),
        Button( id: 8,    text: NSLocalizedString("button_temperature", comment: ""),   image: UIImage(systemName: "thermometer.medium")!,        segue: "TemperatureSegue"),
//        Button( id: 9,    text: NSLocalizedString("button_date", comment: ""),         image: UIImage(systemName: "calendar")!,                segue: "DateSegue"),
//        Button( id: 10,   text: NSLocalizedString("button_age", comment: ""),          image: UIImage(systemName: "birthday.cake")!,            segue: "AgeSegue"),
        Button( id: 11,   text: NSLocalizedString("button_time", comment: ""),         image: UIImage(systemName: "clock")!,                   segue: "TimeSegue"),
        Button( id: 12,   text: NSLocalizedString("button_speed", comment: ""),        image: UIImage(systemName: "gauge.open.with.lines.needle.33percent")!,      segue: "SpeedSegue"),
        Button( id: 13,   text: NSLocalizedString("button_mass", comment: ""),         image: UIImage(systemName: "scalemass")!,                segue: "MassSegue"),
        Button( id: 14,   text: NSLocalizedString("button_count_system", comment: ""),  image: UIImage(systemName: "01.square")!,                segue: "CountSegue"),
//        Button( id: 15,   text: NSLocalizedString("button_resolution", comment: ""),    image: UIImage(systemName: "4k.tv")!,                   segue: "ResolutionSegue"),
//        Button( id: 16,   text: NSLocalizedString("button_data", comment: ""),         image: UIImage(systemName: "externaldrive")!,            segue: "DataSegue"),
//        Button( id: 17,   text: NSLocalizedString("button_discount", comment: ""),      image: UIImage(systemName: "tag")!,                     segue: "DiscountSegue"),
//        Button( id: 18,   text: NSLocalizedString("button_investment", comment: ""),   image: UIImage(systemName: "chart.line.uptrend.xyaxis")!,  segue: "InvestitionSegue"),
//        Button( id: 19,   text: NSLocalizedString("button_loan", comment: ""),         image: UIImage(systemName: "creditcard")!,               segue: "LoanSegue"),
//        Button( id: 20,   text: NSLocalizedString("button_tips", comment: ""),         image: UIImage(systemName: "centsign.circle")!,           segue: "TipsSegue"),
//        Button( id: 21,   text: NSLocalizedString("button_bmi", comment: ""),          image: UIImage(systemName: "heart.text.square")!,         segue: "BmiSegue"),
        Button( id: 22,   text: NSLocalizedString("button_settings", comment: ""),      image: UIImage(systemName: "gear")!,                    segue: "SettingsSegue")
    ]
}
