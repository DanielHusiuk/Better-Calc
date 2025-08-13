//
//  BetterCalcWidget.swift
//  BetterCalcWidget
//
//  Created by Daniel Husiuk on 08.08.2025.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), selectedTintId: 1)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), selectedTintId: 1)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let currentDate = Date()
        let selectedTintID = UserDefaults(suiteName: "group.com.danielhusiuk.bettercalc")
        
        let selectedTintInt = selectedTintID?.integer(forKey: "selectedTintInt") ?? 1
        let entry = [SimpleEntry(date: currentDate, selectedTintId: selectedTintInt)]
        
        return Timeline(entries: entry, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let selectedTintId: Int
}

struct BetterCalcWidgetEntryView : View {
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
    let tintModel = [#colorLiteral(red: 0.9490196078, green: 0.6392156863, blue: 0.2352941176, alpha: 1),#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1),#colorLiteral(red: 0.09411764706, green: 0.537254902, blue: 0.4823529412, alpha: 1),#colorLiteral(red: 0.5176470588, green: 0.2901960784, blue: 0.4509803922, alpha: 1),#colorLiteral(red: 0.5450980392, green: 0.6117647059, blue: 0.1333333333, alpha: 1),#colorLiteral(red: 0.6431372549, green: 0.0862745098, blue: 0.1137254902, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.3098039216, blue: 0.5882352941, alpha: 1),#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1),#colorLiteral(red: 0.05098039216, green: 0.5019607843, blue: 0.6078431373, alpha: 1)]
    
    var body: some View {
        ZStack {
            switch renderingMode {
            case .fullColor:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    }
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .accented:
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button { } label: {
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .widgetAccentable()
                                        .foregroundColor(Color(tintModel[entry.selectedTintId]))
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
                    }
                    
                    HStack(spacing: 10) {
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .widgetAccentable()
                                        .foregroundColor(Color(tintModel[entry.selectedTintId]))
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
                        }
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .widgetAccentable()
                                        .foregroundColor(Color(tintModel[entry.selectedTintId]))
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .vibrant:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                    }
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
    let tintModel = [#colorLiteral(red: 0.9490196078, green: 0.6392156863, blue: 0.2352941176, alpha: 1),#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1),#colorLiteral(red: 0.09411764706, green: 0.537254902, blue: 0.4823529412, alpha: 1),#colorLiteral(red: 0.5176470588, green: 0.2901960784, blue: 0.4509803922, alpha: 1),#colorLiteral(red: 0.5450980392, green: 0.6117647059, blue: 0.1333333333, alpha: 1),#colorLiteral(red: 0.6431372549, green: 0.0862745098, blue: 0.1137254902, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.3098039216, blue: 0.5882352941, alpha: 1),#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1),#colorLiteral(red: 0.05098039216, green: 0.5019607843, blue: 0.6078431373, alpha: 1)]
    
    var body: some View {
        ZStack() {
            switch renderingMode {
            case .fullColor:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //temperature
                        Link(destination: URL(string: "bettercalc://temperature")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "thermometer.medium")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //time
                        Link(destination: URL(string: "bettercalc://time")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "clock")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .accented:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //temperature
                        Link(destination: URL(string: "bettercalc://temperature")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "thermometer.medium")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //time
                        Link(destination: URL(string: "bettercalc://time")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "clock")
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .vibrant:
                VStack(spacing: 10) {
                    
                    //top stack
                    HStack(spacing: 10) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 10) {
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //temperature
                        Link(destination: URL(string: "bettercalc://temperature")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "thermometer.medium")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //time
                        Link(destination: URL(string: "bettercalc://time")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "clock")
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
    let tintModel = [#colorLiteral(red: 0.9490196078, green: 0.6392156863, blue: 0.2352941176, alpha: 1),#colorLiteral(red: 0.8156862745, green: 0.537254902, blue: 0.3294117647, alpha: 1),#colorLiteral(red: 0.09411764706, green: 0.537254902, blue: 0.4823529412, alpha: 1),#colorLiteral(red: 0.5176470588, green: 0.2901960784, blue: 0.4509803922, alpha: 1),#colorLiteral(red: 0.5450980392, green: 0.6117647059, blue: 0.1333333333, alpha: 1),#colorLiteral(red: 0.6431372549, green: 0.0862745098, blue: 0.1137254902, alpha: 1),#colorLiteral(red: 0.07058823529, green: 0.3098039216, blue: 0.5882352941, alpha: 1),#colorLiteral(red: 0.6823529412, green: 0.6823529412, blue: 0.6823529412, alpha: 1),#colorLiteral(red: 0.05098039216, green: 0.5019607843, blue: 0.6078431373, alpha: 1)]
    
    var body: some View {
        ZStack() {
            switch renderingMode {
            case .fullColor:
                VStack(spacing: 12) {
                    
                    //top stack
                    HStack(spacing: 12) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    }
                    
                    
                    //middle stack
                    HStack(spacing: 12) {
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //temperature
                        Link(destination: URL(string: "bettercalc://temperature")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "thermometer.medium")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //time
                        Link(destination: URL(string: "bettercalc://time")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "clock")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 12) {
                        
                        //speed
                        Link(destination: URL(string: "bettercalc://speed")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "gauge.open.with.lines.needle.33percent")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //mass
                        Link(destination: URL(string: "bettercalc://mass")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "scalemass")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //data size
                        Link(destination: URL(string: "bettercalc://data")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "externaldrive")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .accented:
                VStack(spacing: 12) {
                    
                    //top stack
                    HStack(spacing: 12) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    }
                    
                    
                    //middle stack
                    HStack(spacing: 12) {
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //temperature
                        Link(destination: URL(string: "bettercalc://temperature")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "thermometer.medium")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //time
                        Link(destination: URL(string: "bettercalc://time")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "clock")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 12) {
                        
                        //speed
                        Link(destination: URL(string: "bettercalc://speed")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "gauge.open.with.lines.needle.33percent")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //mass
                        Link(destination: URL(string: "bettercalc://mass")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "scalemass")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                        }
                        
                        //data size
                        Link(destination: URL(string: "bettercalc://data")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "externaldrive")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color (tintModel[entry.selectedTintId]))
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .vibrant:
                VStack(spacing: 12) {
                    
                    //top stack
                    HStack(spacing: 12) {
                        
                        //basic
                        Link(destination: URL(string: "bettercalc://basic")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "plus.forwardslash.minus")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //length
                        Link(destination: URL(string: "bettercalc://length")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "ruler")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //area
                        Link(destination: URL(string: "bettercalc://area")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.down.left.and.arrow.up.right.square")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                    }
                    
                    
                    //middle stack
                    HStack(spacing: 12) {
                        
                        //volume
                        Link(destination: URL(string: "bettercalc://volume")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "cube")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //temperature
                        Link(destination: URL(string: "bettercalc://temperature")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "thermometer.medium")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //time
                        Link(destination: URL(string: "bettercalc://time")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "clock")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                    }
                    
                    
                    //bottom stack
                    HStack(spacing: 12) {
                        
                        //speed
                        Link(destination: URL(string: "bettercalc://speed")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "gauge.open.with.lines.needle.33percent")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //mass
                        Link(destination: URL(string: "bettercalc://mass")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "scalemass")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                        }
                        
                        //data size
                        Link(destination: URL(string: "bettercalc://data")!) {
                            Button() { } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "externaldrive")
                                        .resizable()
                                        .widgetAccentable()
                                        .foregroundColor(Color.white)
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
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            default:
                Text("Unsupported")
            }
            
        }
        .padding(-4)
    }
}


//MARK: - Configuration

struct BetterCalcWidget: Widget {
    let kind: String = "BetterCalcWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            BetterCalcWidgetEntryView(entry: entry)
                .containerBackground(Color(#colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)), for: .widget)
        }
        .configurationDisplayName("Better Calc")
        .description(NSLocalizedString("widget_description", comment: ""))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    BetterCalcWidget()
} timeline: {
    SimpleEntry(date: .now, selectedTintId: 1)
}
