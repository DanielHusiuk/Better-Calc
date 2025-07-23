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
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            Text("Unsupported")
        }
    }
}

struct SmallWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack() {
            VStack() {
                
                //top stack
                HStack() {
                    
                    //basic
                    Button() {
                        print("basic button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.forwardslash.minus")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 12)
                                .padding(.bottom, 2)
                            
                            Text(NSLocalizedString("button_basic", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //length
                    Button() {
                        print("length button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "ruler")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 19)
                                .padding(.bottom, 7)
                            
                            Text(NSLocalizedString("button_length", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                
                //bottom stack
                HStack() {
                    
                    //area
                    Button() {
                        print("area button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 14)
                                .padding(.bottom, 2)
                            
                            Text(NSLocalizedString("button_area", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //volume
                    Button() {
                        print("cube button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "cube")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 12)
                                .padding(.bottom, 2)
                            
                            Text(NSLocalizedString("button_volume", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(-8)
    }
}

struct MediumWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack() {
            VStack() {
                
                //top stack
                HStack() {
                    
                    //basic
                    Button() {
                        print("basic button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.forwardslash.minus")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 12)
                                .padding(.bottom, 2)
                            
                            Text(NSLocalizedString("button_basic", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //length
                    Button() {
                        print("length button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "ruler")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 19)
                                .padding(.bottom, 7)
                            
                            Text(NSLocalizedString("button_length", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //area
                    Button() {
                        print("area button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 14)
                                .padding(.bottom, 2)
                            
                            Text(NSLocalizedString("button_area", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                
                
                //bottom stack
                HStack() {
                    
                    //volume
                    Button() {
                        print("cube button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "cube")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 12)
                                .padding(.bottom, 2)
                            
                            Text(NSLocalizedString("button_volume", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //temperature
                    Button() {
                        print("temperature button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "thermometer.medium")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 12)
                                .padding(.bottom, 2)
                            
                            Text(NSLocalizedString("button_temperature", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //time
                    Button() {
                        print("time button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "clock")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 12)
                                .padding(.bottom, 4)
                            
                            Text(NSLocalizedString("button_time", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(-8)
    }
}

struct LargeWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack() {
            VStack() {
                
                //top stack
                HStack() {
                    
                    //basic
                    Button() {
                        print("basic button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "plus.forwardslash.minus")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 24)
                                .padding(.bottom, 14)
                            
                            Text(NSLocalizedString("button_basic", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //length
                    Button() {
                        print("length button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "ruler")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 34)
                                .padding(.bottom, 18)
                            
                            Text(NSLocalizedString("button_length", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //area
                    Button() {
                        print("area button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 24)
                                .padding(.bottom, 12)
                            
                            Text(NSLocalizedString("button_area", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                
                
                //middle stack
                HStack() {
                    
                    //volume
                    Button() {
                        print("volume button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "cube")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 22)
                                .padding(.bottom, 12)
                            
                            Text(NSLocalizedString("button_volume", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //temperature
                    Button() {
                        print("temperature button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "thermometer.medium")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 24)
                                .padding(.bottom, 12)
                            
                            Text(NSLocalizedString("button_temperature", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //time
                    Button() {
                        print("time button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "clock")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 22)
                                .padding(.bottom, 14)
                            
                            Text(NSLocalizedString("button_time", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                
                
                //bottom stack
                HStack() {
                    
                    //speed
                    Button() {
                        print("speed button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "gauge.open.with.lines.needle.33percent")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 26)
                                .padding(.bottom, 14)
                            
                            Text(NSLocalizedString("button_speed", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //mass
                    Button() {
                        print("mass button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "scalemass")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 22)
                                .padding(.bottom, 14)
                            
                            Text(NSLocalizedString("button_mass", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                    //data size
                    Button() {
                        print("data size button pressed")
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "externaldrive")
                                .resizable()
                                .widgetAccentable()
                                .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                .aspectRatio(contentMode: .fit)
                                .padding(.top, 28)
                                .padding(.bottom, 15)
                            
                            Text(NSLocalizedString("button_data", comment: ""))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .buttonStyle(.plain)
                    .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(-8)
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
        .description(NSLocalizedString("widget_description", comment: ""))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

extension ConfigurationAppIntent {
    
}

#Preview(as: .systemSmall) {
    BetterCalcControlWidget()
} timeline: {
    SimpleEntry(date: .now)
}
