//
//  AppIntent.swift
//  BetterCalcWidget
//
//  Created by Daniel Husiuk on 08.08.2025.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Better Calc widget" }
    
    static var openAppWhenRun: Bool { true }
    
    func perform() async throws -> some IntentResult & OpensIntent {
        .result()
    }
}
