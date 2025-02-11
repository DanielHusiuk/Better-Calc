//
//  UnitsModel.swift
//  Better Calc
//
//  Created by Daniel Husiuk on 08.02.2025.
//

import UIKit

class UnitsModel {
    
    //length
    var lengthDictionary: [UnitLength: String] = [
        .picometers          : "Picometers",
        .nanometers          : "Nanometers",
        .micrometers         : "Micrometers",
        .millimeters         : "Millimeters",
        .centimeters         : "Centimeters",
        .decimeters          : "Decimeters",
        .meters              : "Meters",
        .decameters          : "Decameters",
        .hectometers         : "Hectometers",
        .kilometers          : "Kilometers",
        .megameters          : "Megameters",
        .inches             : "Inches",
        .feet               : "Feet",
        .yards              : "Yards",
        .fathoms            : "Fathoms",
        .furlongs           : "Furlongs",
        .miles              : "Miles",
        .scandinavianMiles   : "Scandinavian Miles",
        .nauticalMiles       : "Nautical Miles",
        .astronomicalUnits   : "Astronomical Units",
        .lightyears         : "Light-years",
        .parsecs            : "Parsecs"
    ]
    
    //area
    var areaDictionary: [UnitArea: String] = [
        .squareNanometers    : "Square Nanometers",
        .squareMicrometers   : "Square Micrometers",
        .squareMillimeters   : "Square Millimeters",
        .squareCentimeters   : "Square Centimeters",
        .squareMeters       : "Square Meters",
        .squareInches       : "Square Inches",
        .squareFeet         : "Square Feet",
        .squareYards        : "Square Yards",
        .squareKilometers    : "Square Kilometers",
        .squareMegameters    : "Square Megameters",
        .acres             : "Acres",
        .ares              : "Ares",
        .hectares           : "Hectares",
        .squareMiles        : "Square Miles"
    ]
    
    //volume
    var volumeDictionary: [UnitVolume: String] = [
        .cubicMillimeters       : "Cubic Millimeters",
        .milliliters           : "Milliliters",
        .centiliters           : "Centiliters",
        .deciliters            : "Deciliters",
        .liters               : "Liters",
        .metricCups            : "Metric Cups",
        .kiloliters            : "Kiloliters",
        .megaliters            : "Megaliters",
        .cubicDecimeters        : "Cubic Decimeters",
        .cubicMeters           : "Cubic Meters",
        .cubicKilometers        : "Cubic Kilometers",
        .teaspoons             : "Teaspoons",
        .tablespoons           : "Tablespoons",
        .fluidOunces           : "Fluid Ounces",
        .cups                 : "Cups",
        .pints                : "Pints",
        .quarts               : "Quarts",
        .gallons              : "Gallons",
        .imperialTeaspoons      : "Imperial Teaspoons",
        .imperialTablespoons    : "Imperial Tablespoons",
        .imperialFluidOunces    : "Imperial Fluid Ounces",
        .imperialPints         : "Imperial Pints",
        .imperialQuarts        : "Imperial Quarts",
        .imperialGallons       : "Imperial Gallons",
        .cubicInches           : "Cubic Inches",
        .cubicFeet             : "Cubic Feet",
        .cubicYards            : "Cubic Yards",
        .cubicMiles            : "Cubic Miles",
        .acreFeet             : "Acre-Feet",
        .bushels              : "Bushels"
    ]
    
    //temperature
    var temperatureDictionary: [UnitTemperature: String] = [
        .kelvin       : "Kelvin",
        .celsius      : "Celcius",
        .fahrenheit   : "Fahrenheit"
    ]
    
    //time
    var timeDictionary: [UnitDuration: String] = [
        .picoseconds   : "Picoseconds",
        .nanoseconds   : "Nanoseconds",
        .microseconds  : "Microseconds",
        .milliseconds  : "Milliseconds",
        .seconds      : "Seconds",
        .minutes      : "Minutes",
        .hours        : "Hours"
    ]
    
    //speed
    var speedDictionary: [UnitSpeed: String] = [
        .knots             : "Knots",
        .milesPerHour       : "Miles per Hour",
        .kilometersPerHour   : "Kilometers per Hour",
        .metersPerSecond     : "Meters per Second"
    ]
    
    //mass
    var massDictionary: [UnitMass: String] = [
        .picograms      : "Picograms",
        .nanograms      : "Nanograms",
        .micrograms     : "Micrograms",
        .milligrams     : "Milligrams",
        .centigrams     : "Centigrams",
        .decigrams      : "Decigrams",
        .grams          : "Grams",
        .kilograms       : "Kilograms",
        .carats         : "Carats",
        .ouncesTroy      : "Ounces Troy",
        .ounces         : "Ounces",
        .pounds         : "Pounds",
        .stones         : "Stones",
        .metricTons      : "Metric Tons",
        .shortTons       : "Short Tons",
        .slugs          : "Slugs"
    ]
    
    //storage
    var storageDictionary: [UnitInformationStorage: String] = [
        .bits           : "Bits",
        .bytes          : "Bytes",
        .kilobits       : "Kilobits",
        .megabits       : "Megabits",
        .gigabits       : "Gigabits",
        .terabits       : "Terabits",
        .petabits       : "Petabits",
        .exabits        : "Exabits",
        .zettabits      : "Zettabits",
        .yottabits      : "Yottabits",
        .kilobytes      : "Kilobytes",
        .megabytes      : "Megabytes",
        .gigabytes      : "Gigabytes",
        .terabytes      : "Terabytes",
        .petabytes      : "Petabytes",
        .exabytes       : "Exabytes",
        .zettabytes      : "Zettabytes",
        .yottabytes      : "Yottabytes",
        .exbibits       : "Exbibits",
        .exbibytes      : "Exbibytes",
        .mebibits       : "Mebibits",
        .mebibytes      : "Mebibytes",
    ]
    
}
