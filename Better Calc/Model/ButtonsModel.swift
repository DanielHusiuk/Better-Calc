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
        Button( id: 1,    text: NSLocalizedString("button_basic", comment: ""),        image: UIImage(named: "plus.forwardslash.minus.svg")!,   segue: "BasicSegue"),
//        Button( id: 2,    text: NSLocalizedString("button_scientific", comment: ""),    image: UIImage(named: "x.squareroot.svg")!,            segue: "ScientificSegue"),
//        Button( id: 3,    text: NSLocalizedString("button_currency", comment: ""),     image: UIImage(named: "dollarsign.svg")!,               segue: "CurrencySegue"),
//        Button( id: 4,    text: NSLocalizedString("button_crypto", comment: ""),       image: UIImage(named: "bitcoinsign.svg")!,              segue: "CryptoSegue"),
        Button( id: 5,    text: NSLocalizedString("button_length", comment: ""),       image: UIImage(named: "ruler.svg")!,                   segue: "LengthSegue"),
        Button( id: 6,    text: NSLocalizedString("button_area", comment: ""),         image: UIImage(named: "arrow.down.left.and.arrow.up.right.square.svg")!,   segue: "AreaSegue"),
        Button( id: 7,    text: NSLocalizedString("button_volume", comment: ""),       image: UIImage(named: "cube.svg")!,                    segue: "VolumeSegue"),
        Button( id: 8,    text: NSLocalizedString("button_temperature", comment: ""),   image: UIImage(named: "thermometer.medium.svg")!,        segue: "TemperatureSegue"),
//        Button( id: 9,    text: NSLocalizedString("button_date", comment: ""),         image: UIImage(named: "calendar.svg")!,                segue: "DateSegue"),
//        Button( id: 10,   text: NSLocalizedString("button_age", comment: ""),          image: UIImage(named: "birthday.cake.svg")!,            segue: "AgeSegue"),
        Button( id: 11,   text: NSLocalizedString("button_time", comment: ""),         image: UIImage(named: "clock.svg")!,                   segue: "TimeSegue"),
        Button( id: 12,   text: NSLocalizedString("button_speed", comment: ""),        image: UIImage(named: "gauge.open.with.lines.needle.33percent.svg")!,      segue: "SpeedSegue"),
        Button( id: 13,   text: NSLocalizedString("button_mass", comment: ""),         image: UIImage(named: "scalemass.svg")!,                segue: "MassSegue"),
//        Button( id: 14,   text: NSLocalizedString("button_count_system", comment: ""),  image: UIImage(named: "01.square.svg")!,                segue: "CountSegue"),
//        Button( id: 15,   text: NSLocalizedString("button_resolution", comment: ""),    image: UIImage(named: "4k.tv.svg")!,                   segue: "ResolutionSegue"),
        Button( id: 16,   text: NSLocalizedString("button_data", comment: ""),         image: UIImage(named: "externaldrive.svg")!,            segue: "DataSegue"),
//        Button( id: 17,   text: NSLocalizedString("button_discount", comment: ""),      image: UIImage(named: "tag.svg")!,                     segue: "DiscountSegue"),
//        Button( id: 18,   text: NSLocalizedString("button_investment", comment: ""),    image: UIImage(named: "chart.line.uptrend.xyaxis.svg")!,  segue: "InvestitionSegue"),
//        Button( id: 19,   text: NSLocalizedString("button_loan", comment: ""),         image: UIImage(named: "creditcard.svg")!,               segue: "LoanSegue"),
//        Button( id: 20,   text: NSLocalizedString("button_tips", comment: ""),         image: UIImage(named: "centsign.circle.svg")!,           segue: "TipsSegue"),
//        Button( id: 21,   text: NSLocalizedString("button_bmi", comment: ""),          image: UIImage(named: "heart.text.square.svg")!,         segue: "BmiSegue"),
        Button( id: 22,   text: NSLocalizedString("button_settings", comment: ""),      image: UIImage(named: "gear.svg")!,                    segue: "SettingsSegue")
    ]
    
    private(set) var filteredButtons: [Button] = []
}

//MARK: - Search Extensions

extension ButtonsModel {
    
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActive && !searchText.isEmpty
    }
    
    public mutating func updateSearchController(searchBarText: String?) {
        self.filteredButtons = buttons
        
        if let searchText = searchBarText?.lowercased(), !searchText.isEmpty {
            self.filteredButtons = self.filteredButtons.filter({ $0.text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).localizedCaseInsensitiveContains(searchText.trimmingCharacters(in: .whitespacesAndNewlines)) })
        } else {
            self.filteredButtons = buttons
        }
    }
    
}
