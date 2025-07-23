//
//  AppIntent.swift
//  BetterCalcControlWidget
//
//  Created by Daniel Husiuk on 17.04.2025.
//

import WidgetKit
import AppIntents

@available(iOS 18.0, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Better Calc widget" }
    
    static var openAppWhenRun: Bool { true }

    func perform() async throws -> some IntentResult {
        .result()
    }
}
