//
//  AppSettings.swift
//  Calendar
//
//  Created by Developer on 02.01.2021.
//  Copyright © 2021 DyvenSvit. All rights reserved.
//

import Foundation

public enum AppSettings {

    // New enum with the Keys, add all settings key here
    public enum key: String {
        case startDayFromEvening = "settings.start_day_from_evening"
        case calendarGregorian = "settings.calendar.gregorian"
        case calendarReload = "settings.calendar.reload"
  }

    public static subscript(_ key: key) -> Any? { // the parameter key have a enum type `key`
        get { // need use `rawValue` to acess the string
            return UserDefaults.standard.value(forKey: key.rawValue)
        }
        set { // need use `rawValue` to acess the string
            UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
        }
    }
}

extension AppSettings {
    public static func boolValue(_ key: key) -> Bool {
        if let value = AppSettings[key] as? Bool {
            return value
        }
        return false
    }
    
    public static func stringValue(_ key: key) -> String? {
        if let value = AppSettings[key] as? String {
            return value
        }
        return nil
    }
    
    public static func intValue(_ key: key) -> Int? {
        if let value = AppSettings[key] as? Int {
            return value
        }
        return nil
    }
}
