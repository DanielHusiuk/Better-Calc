//
//  BetterCalcWidgetControl.swift
//  BetterCalcWidget
//
//  Created by Daniel Husiuk on 08.08.2025.
//

import AppIntents
import SwiftUI
import WidgetKit

    //MARK: - App

@available(iOS 18.0, *)
struct BetterCalcControlWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("Menu", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidget: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidget"
    static var calcIcon: String? { "better.calc.icon" }
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetIntent()) {
                Label("Open Better Calc", image: BetterCalcControlWidget.calcIcon!)
            }
        }
        .displayName("Better Calc")
    }
}


    //MARK: - Basic

@available(iOS 18.0, *)
struct BetterCalcControlWidgetBasicIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("BasicSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://basic")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetBasic: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetBasic"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetBasicIntent()) {
                Label("Open Basic calculator", systemImage: "plus.forwardslash.minus")
            }
        }
        .displayName(LocalizedStringResource("button_basic", comment: ""))
    }
}


    //MARK: - Length

@available(iOS 18.0, *)
struct BetterCalcControlWidgetLengthIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("LengthSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://length")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetLength: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetLength"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetLengthIntent()) {
                Label("Open Length converter", systemImage: "ruler")
            }
        }
        .displayName(LocalizedStringResource("button_length", comment: ""))
    }
}


    //MARK: - Area

@available(iOS 18.0, *)
struct BetterCalcControlWidgetAreaIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("AreaSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://area")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetArea: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetArea"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetAreaIntent()) {
                Label("Open Area converter", systemImage: "arrow.down.left.and.arrow.up.right.square")
            }
        }
        .displayName(LocalizedStringResource("button_area", comment: ""))
    }
}


    //MARK: - Volume

@available(iOS 18.0, *)
struct BetterCalcControlWidgetVolumeIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("VolumeSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://volume")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetVolume: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetVolume"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetVolumeIntent()) {
                Label("Open Volume converter", systemImage: "cube")
            }
        }
        .displayName(LocalizedStringResource("button_volume", comment: ""))
    }
}


    //MARK: - Temperature

@available(iOS 18.0, *)
struct BetterCalcControlWidgetTemperatureIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("TemperatureSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://temperature")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetTemperature: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetTemperature"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetTemperatureIntent()) {
                Label("Open Temperature converter", systemImage: "thermometer.medium")
            }
        }
        .displayName(LocalizedStringResource("button_temperature", comment: ""))
    }
}


    //MARK: - Time

@available(iOS 18.0, *)
struct BetterCalcControlWidgetTimeIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("TimeSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://time")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetTime: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetTime"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetTimeIntent()) {
                Label("Open Time converter", systemImage: "clock")
            }
        }
        .displayName(LocalizedStringResource("button_time", comment: ""))
    }
}


    //MARK: - Speed

@available(iOS 18.0, *)
struct BetterCalcControlWidgetSpeedIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("SpeedSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://speed")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetSpeed: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetSpeed"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetSpeedIntent()) {
                Label("Open Speed converter", systemImage: "gauge.open.with.lines.needle.33percent")
            }
        }
        .displayName(LocalizedStringResource("button_speed", comment: ""))
    }
}


    //MARK: - Mass

@available(iOS 18.0, *)
struct BetterCalcControlWidgetMassIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("MassSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://mass")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetMass: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetMass"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetMassIntent()) {
                Label("Open Mass converter", systemImage: "scalemass")
            }
        }
        .displayName(LocalizedStringResource("button_mass", comment: ""))
    }
}


    //MARK: - Data Size

@available(iOS 18.0, *)
struct BetterCalcControlWidgetDataIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Better Calc"
    
    static var isDiscoverable: Bool = false
    static var openAppWhenRun: Bool = true
    
    func perform() async throws -> some IntentResult & OpensIntent {
        UserDefaults.standard.set("DataSegue", forKey: "SelectedURLString")
        let url = URL(string: "bettercalc://data")!
        return .result(opensIntent: OpenURLIntent(url))
    }
    
}

@available(iOS 18.0, *)
struct BetterCalcControlWidgetData: ControlWidget {
    let kind: String = "com.danielhusiuk.Better-Calc.BetterCalcWidgetData"
    
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: kind) {
            ControlWidgetButton(action: BetterCalcControlWidgetDataIntent()) {
                Label("Open Data Size converter", systemImage: "externaldrive")
            }
        }
        .displayName(LocalizedStringResource("button_data", comment: ""))
    }
}
