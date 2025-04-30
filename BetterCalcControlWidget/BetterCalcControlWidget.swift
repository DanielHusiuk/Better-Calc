//
//  BetterCalcControlWidget.swift
//  BetterCalcControlWidget
//
//  Created by Daniel Husiuk on 17.04.2025.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct BetterCalcControlWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Better Calc:")
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .bold))
            
//            Text(entry.date, style: .time)
//                .foregroundStyle(.white)
            
            Image("AppIcon_small1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
    }
}

struct BetterCalcControlWidget: Widget {
    let kind: String = "BetterCalcControlWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            BetterCalcControlWidgetEntryView(entry: entry)
                .containerBackground(Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)), for: .widget)
        }
        .configurationDisplayName("Better Calc")
        .description("Open BetterCalc using widgets")
    }
}

extension ConfigurationAppIntent {

}

#Preview(as: .systemSmall) {
    BetterCalcControlWidget()
} timeline: {
    SimpleEntry(date: .now)
}
