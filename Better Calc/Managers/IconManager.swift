//
//  IconManager.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 03.10.2024.
//

import UIKit

enum AppIcon: CaseIterable {
    
    case icon0, icon1, icon2, icon3, icon4, icon5, icon6, icon7, icon8
    
    var name: String? {
        switch self {
        case .icon0:
            return "BetterIcon0"
        case .icon1:
            return "BetterIcon1"
        case .icon2:
            return "BetterIcon2"
        case .icon3:
            return "BetterIcon3"
        case .icon4:
            return "BetterIcon4"
        case .icon5:
            return "BetterIcon5"
        case .icon6:
            return "BetterIcon6"
        case .icon7:
            return "BetterIcon7"
        case .icon8:
            return "BetterIcon8"
        }
    }
}

var current: AppIcon {
    return AppIcon.allCases.first(where: {$0.name == UIApplication.shared.alternateIconName}) ?? .icon1
}

func setIcon(_ appIcon: AppIcon, completion: ((Bool) -> Void)? = nil) {
    guard current != appIcon, UIApplication.shared.supportsAlternateIcons
    else { return }
    
    guard UIApplication.shared.supportsAlternateIcons else { return }
    
    UIApplication.shared.setAlternateIconName(appIcon.name) { error in
        if let error = error {
            print("Error setting the alternate icon \(appIcon.name ?? ""): \(error.localizedDescription)")
        }
        completion?(error != nil)
    }
}
