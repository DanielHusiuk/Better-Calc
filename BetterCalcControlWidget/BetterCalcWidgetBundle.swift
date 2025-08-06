//
//  BetterCalcWidgetBundle.swift
//  BetterCalcWidget
//
//  Created by Daniel Husiuk on 17.04.2025.
//

import WidgetKit
import SwiftUI

@main
struct BetterCalcWidgetBundle: WidgetBundle {
    var body: some Widget {
        BetterCalcWidget()
        BetterCalcControlWidget()
        
        BetterCalcControlWidgetBasic()
        BetterCalcControlWidgetLength()
        BetterCalcControlWidgetArea()
        BetterCalcControlWidgetVolume()
        BetterCalcControlWidgetTemperature()
        BetterCalcControlWidgetTime()
        BetterCalcControlWidgetSpeed()
        BetterCalcControlWidgetMass()
        BetterCalcControlWidgetData()
    }
}
