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

//MARK: - Small Widget

struct SmallWidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetRenderingMode) var renderingMode
    
    var body: some View {
        ZStack {
            switch renderingMode {
            case .fullColor:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Button() {
                            print("basic button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.forwardslash.minus")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_basic", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .cornerRadius(12)
                        
                        //length
                        Button() {
                            print("length button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "ruler")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 18)
                                    .padding(.bottom, 5)
                                
                                Text(NSLocalizedString("button_length", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .cornerRadius(12)
                    }
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //area
                        Button() {
                            print("area button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 14)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_area", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .cornerRadius(12)
                        
                        //volume
                        Button() {
                            print("cube button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "cube")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 10)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_volume", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .cornerRadius(12)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .accented:
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        Button {
                            print("basic button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.forwardslash.minus")
                                    .widgetAccentable()
                                    .foregroundColor(Color(#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_basic", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .cornerRadius(12)
                        
                        Button {
                            print("length button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "ruler")
                                    .widgetAccentable()
                                    .foregroundColor(Color(#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 18)
                                    .padding(.bottom, 5)
                                
                                Text(NSLocalizedString("button_length", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .cornerRadius(12)
                    }
                    
                    HStack(spacing: 10) {
                        Button {
                            print("area button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                    .widgetAccentable()
                                    .foregroundColor(Color(#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 14)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_area", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .cornerRadius(12)
                        
                        Button {
                            print("cube button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "cube")
                                    .widgetAccentable()
                                    .foregroundColor(Color(#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 10)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_volume", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            default:
                Text("Unsupported")
            }
        }
        .padding(-6)
    }
}

//MARK: - Medium Widget

struct MediumWidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetRenderingMode) var renderingMode
    
    var body: some View {
        ZStack() {
            switch renderingMode {
            case .fullColor:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Button() {
                            print("basic button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.forwardslash.minus")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_basic", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //length
                        Button() {
                            print("length button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "ruler")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 19)
                                    .padding(.bottom, 7)
                                
                                Text(NSLocalizedString("button_length", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //area
                        Button() {
                            print("area button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 14)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_area", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //volume
                        Button() {
                            print("cube button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "cube")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_volume", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //temperature
                        Button() {
                            print("temperature button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "thermometer.medium")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_temperature", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //time
                        Button() {
                            print("time button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 4)
                                
                                Text(NSLocalizedString("button_time", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .accented:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Button() {
                            print("basic button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.forwardslash.minus")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_basic", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //length
                        Button() {
                            print("length button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "ruler")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 19)
                                    .padding(.bottom, 7)
                                
                                Text(NSLocalizedString("button_length", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //area
                        Button() {
                            print("area button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 14)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_area", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //volume
                        Button() {
                            print("cube button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "cube")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_volume", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //temperature
                        Button() {
                            print("temperature button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "thermometer.medium")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 2)
                                
                                Text(NSLocalizedString("button_temperature", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                        //time
                        Button() {
                            print("time button pressed")
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: "clock")
                                    .widgetAccentable()
                                    .foregroundColor(Color (#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1)))
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.top, 12)
                                    .padding(.bottom, 4)
                                
                                Text(NSLocalizedString("button_time", comment: ""))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 5)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 3)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            default:
                Text("Unsupported")
            }

        }
        .padding(-6)
    }
}

//MARK: - Large Widget

struct LargeWidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetRenderingMode) var renderingMode
    
    var body: some View {
        ZStack() {
            switch renderingMode {
            case .fullColor:
                VStack(spacing: 12) {
                    
                    //top stack
                    HStack(spacing: 12) {
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    
                    
                    //middle stack
                    HStack(spacing: 12) {
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 12) {
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(Color (#colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .accented:
                VStack(spacing: 12) {
                    
                    //top stack
                    HStack(spacing: 12) {
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    
                    
                    //middle stack
                    HStack(spacing: 12) {
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 12) {
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        
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
                                    .scaledToFit()
                                    .minimumScaleFactor(0.5)
                                    .padding(.bottom, 8)
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .buttonStyle(.plain)
                        .background(.fill.secondary.opacity(0.35))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            default:
                Text("Unsupported")
            }

        }
        .padding(-4)
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
