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
        .picometers          : NSLocalizedString("unit_length_picometers", comment: ""),
        .nanometers          : NSLocalizedString("unit_length_nanometers", comment: ""),
        .micrometers         : NSLocalizedString("unit_length_micrometers", comment: ""),
        .millimeters         : NSLocalizedString("unit_length_millimeters", comment: ""),
        .centimeters         : NSLocalizedString("unit_length_centimeters", comment: ""),
        .decimeters          : NSLocalizedString("unit_length_decimeters", comment: ""),
        .meters              : NSLocalizedString("unit_length_meters", comment: ""),
        .decameters          : NSLocalizedString("unit_length_decameters", comment: ""),
        .hectometers         : NSLocalizedString("unit_length_hectometers", comment: ""),
        .kilometers          : NSLocalizedString("unit_length_kilometers", comment: ""),
        .megameters          : NSLocalizedString("unit_length_megameters", comment: ""),
        .inches             : NSLocalizedString("unit_length_inches", comment: ""),
        .feet               : NSLocalizedString("unit_length_feet", comment: ""),
        .yards              : NSLocalizedString("unit_length_yards", comment: ""),
        .fathoms            : NSLocalizedString("unit_length_fathoms", comment: ""),
        .furlongs           : NSLocalizedString("unit_length_furlongs", comment: ""),
        .miles              : NSLocalizedString("unit_length_miles", comment: ""),
        .scandinavianMiles   : NSLocalizedString("unit_length_scandinavian_miles", comment: ""),
        .nauticalMiles       : NSLocalizedString("unit_length_nautical_miles", comment: ""),
        .astronomicalUnits   : NSLocalizedString("unit_length_astronomical_units", comment: ""),
        .lightyears         : NSLocalizedString("unit_length_light_years", comment: ""),
        .parsecs            : NSLocalizedString("unit_length_parsecs", comment: "")
    ]
    
    //area
    var areaDictionary: [UnitArea: String] = [
        .squareNanometers    : NSLocalizedString("unit_area_square_nanometers", comment: ""),
        .squareMicrometers   : NSLocalizedString("unit_area_square_micrometers", comment: ""),
        .squareMillimeters   : NSLocalizedString("unit_area_square_millimeters", comment: ""),
        .squareCentimeters   : NSLocalizedString("unit_area_square_centimeters", comment: ""),
        .squareMeters       : NSLocalizedString("unit_area_square_meters", comment: ""),
        .squareInches       : NSLocalizedString("unit_area_square_inches", comment: ""),
        .squareFeet         : NSLocalizedString("unit_area_square_feet", comment: ""),
        .squareYards        : NSLocalizedString("unit_area_square_yards", comment: ""),
        .squareKilometers    : NSLocalizedString("unit_area_square_kilometers", comment: ""),
        .squareMegameters    : NSLocalizedString("unit_area_square_megameters", comment: ""),
        .acres             : NSLocalizedString("unit_area_acres", comment: ""),
        .ares              : NSLocalizedString("unit_area_ares", comment: ""),
        .hectares           : NSLocalizedString("unit_area_hectares", comment: ""),
        .squareMiles        : NSLocalizedString("unit_area_square_miles", comment: "")
    ]
    
    //volume
    var volumeDictionary: [UnitVolume: String] = [
        .cubicMillimeters       : NSLocalizedString("unit_volume_cubic_millimeters", comment: ""),
        .milliliters           : NSLocalizedString("unit_volume_milliliters", comment: ""),
        .centiliters           : NSLocalizedString("unit_volume_centiliters", comment: ""),
        .deciliters            : NSLocalizedString("unit_volume_deciliters", comment: ""),
        .liters               : NSLocalizedString("unit_volume_liters", comment: ""),
        .metricCups            : NSLocalizedString("unit_volume_metric_cups", comment: ""),
        .kiloliters            : NSLocalizedString("unit_volume_kiloliters", comment: ""),
        .megaliters            : NSLocalizedString("unit_volume_megaliters", comment: ""),
        .cubicDecimeters        : NSLocalizedString("unit_volume_cubic_decimeters", comment: ""),
        .cubicMeters           : NSLocalizedString("unit_volume_cubic_meters", comment: ""),
        .cubicKilometers        : NSLocalizedString("unit_volume_cubic_kilometers", comment: ""),
        .teaspoons             : NSLocalizedString("unit_volume_teaspoons", comment: ""),
        .tablespoons           : NSLocalizedString("unit_volume_tablespoons", comment: ""),
        .fluidOunces           : NSLocalizedString("unit_volume_fluid_ounces", comment: ""),
        .cups                 : NSLocalizedString("unit_volume_cups", comment: ""),
        .pints                : NSLocalizedString("unit_volume_pints", comment: ""),
        .quarts               : NSLocalizedString("unit_volume_quarts", comment: ""),
        .gallons              : NSLocalizedString("unit_volume_gallons", comment: ""),
        .imperialTeaspoons      : NSLocalizedString("unit_volume_imperial_teaspoons", comment: ""),
        .imperialTablespoons    : NSLocalizedString("unit_volume_imperial_tablespoons", comment: ""),
        .imperialFluidOunces    : NSLocalizedString("unit_volume_imperial_fluid_ounces", comment: ""),
        .imperialPints         : NSLocalizedString("unit_volume_imperial_pints", comment: ""),
        .imperialQuarts        : NSLocalizedString("unit_volume_imperial_quarts", comment: ""),
        .imperialGallons       : NSLocalizedString("unit_volume_imperial_gallons", comment: ""),
        .cubicInches           : NSLocalizedString("unit_volume_cubic_inches", comment: ""),
        .cubicFeet             : NSLocalizedString("unit_volume_cubic_feet", comment: ""),
        .cubicYards            : NSLocalizedString("unit_volume_cubic_yards", comment: ""),
        .cubicMiles            : NSLocalizedString("unit_volume_cubic_miles", comment: ""),
        .acreFeet             : NSLocalizedString("unit_volume_acre_feet", comment: ""),
        .bushels              : NSLocalizedString("unit_volume_bushels", comment: ""),
    ]
    
    //temperature
    var temperatureDictionary: [UnitTemperature: String] = [
        .kelvin            : NSLocalizedString("unit_temperature_kelvin", comment: ""),
        .celsius           : NSLocalizedString("unit_temperature_celsius", comment: ""),
        .fahrenheit        : NSLocalizedString("unit_temperature_fahrenheit", comment: "")
    ]
    
    //time
    var timeDictionary: [UnitDuration: String] = [
        .picoseconds      : NSLocalizedString("unit_time_picoseconds", comment: ""),
        .nanoseconds      : NSLocalizedString("unit_time_nanoseconds", comment: ""),
        .microseconds     : NSLocalizedString("unit_time_microseconds", comment: ""),
        .milliseconds     : NSLocalizedString("unit_time_milliseconds", comment: ""),
        .seconds         : NSLocalizedString("unit_time_seconds", comment: ""),
        .minutes         : NSLocalizedString("unit_time_minutes", comment: ""),
        .hours           : NSLocalizedString("unit_time_hours", comment: "")
    ]
    
    //speed
    var speedDictionary: [UnitSpeed: String] = [
        .knots             : NSLocalizedString("unit_speed_knots", comment: ""),
        .milesPerHour       : NSLocalizedString("unit_speed_miles_per_hour", comment: ""),
        .kilometersPerHour   : NSLocalizedString("unit_speed_kilometers_per_hour", comment: ""),
        .metersPerSecond     : NSLocalizedString("unit_speed_meters_per_second", comment: "")
    ]
    
    //mass
    var massDictionary: [UnitMass: String] = [
        .picograms      : NSLocalizedString("unit_mass_picograms", comment: ""),
        .nanograms      : NSLocalizedString("unit_mass_nanograms", comment: ""),
        .micrograms     : NSLocalizedString("unit_mass_micrograms", comment: ""),
        .milligrams     : NSLocalizedString("unit_mass_milligrams", comment: ""),
        .centigrams     : NSLocalizedString("unit_mass_centigrams", comment: ""),
        .decigrams      : NSLocalizedString("unit_mass_decigrams", comment: ""),
        .grams          : NSLocalizedString("unit_mass_grams", comment: ""),
        .kilograms       : NSLocalizedString("unit_mass_kilograms", comment: ""),
        .carats         : NSLocalizedString("unit_mass_carats", comment: ""),
        .ouncesTroy      : NSLocalizedString("unit_mass_ounces_troy", comment: ""),
        .ounces         : NSLocalizedString("unit_mass_ounces", comment: ""),
        .pounds         : NSLocalizedString("unit_mass_pounds", comment: ""),
        .stones         : NSLocalizedString("unit_mass_stones", comment: ""),
        .metricTons      : NSLocalizedString("unit_mass_metric_tons", comment: ""),
        .shortTons       : NSLocalizedString("unit_mass_short_tons", comment: ""),
        .slugs          : NSLocalizedString("unit_mass_slugs", comment: "")
    ]
    
    //storage
    var storageDictionary: [UnitInformationStorage: String] = [
        .bits           : NSLocalizedString("unit_storage_bits", comment: ""),
        .bytes          : NSLocalizedString("unit_storage_bytes", comment: ""),
        .kilobits       : NSLocalizedString("unit_storage_kilobits", comment: ""),
        .megabits       : NSLocalizedString("unit_storage_megabits", comment: ""),
        .gigabits       : NSLocalizedString("unit_storage_gigabits", comment: ""),
        .terabits       : NSLocalizedString("unit_storage_terabits", comment: ""),
        .petabits       : NSLocalizedString("unit_storage_petabits", comment: ""),
        .exabits        : NSLocalizedString("unit_storage_exabits", comment: ""),
        .zettabits      : NSLocalizedString("unit_storage_zettabits", comment: ""),
        .yottabits      : NSLocalizedString("unit_storage_yottabits", comment: ""),
        .kilobytes      : NSLocalizedString("unit_storage_kilobytes", comment: ""),
        .megabytes      : NSLocalizedString("unit_storage_megabytes", comment: ""),
        .gigabytes      : NSLocalizedString("unit_storage_gigabytes", comment: ""),
        .terabytes      : NSLocalizedString("unit_storage_terabytes", comment: ""),
        .petabytes      : NSLocalizedString("unit_storage_petabytes", comment: ""),
        .exabytes       : NSLocalizedString("unit_storage_exabytes", comment: ""),
        .zettabytes      : NSLocalizedString("unit_storage_zettabytes", comment: ""),
        .yottabytes      : NSLocalizedString("unit_storage_yottabytes", comment: ""),
        .exbibits       : NSLocalizedString("unit_storage_exbibits", comment: ""),
        .exbibytes      : NSLocalizedString("unit_storage_exbibytes", comment: ""),
        .mebibits       : NSLocalizedString("unit_storage_mebibits", comment: ""),
        .mebibytes      : NSLocalizedString("unit_storage_mebibytes", comment: "")
    ]
    
}
