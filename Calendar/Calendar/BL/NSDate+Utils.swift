//
//  NSDate+Utils.swift
//  Calendar
//
//  Created by Developer on 2/26/19.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import Foundation

extension NSDate {
    static let MONTH_NAMES = ["Січень", "Лютий", "Березень", "Квітень", "Травень", "Червень", "Липень", "Серпень", "Вересень", "Жовтень", "Листопад", "Грудень"]
    
    class func from(day:Int, month:Int, year:Int) -> NSDate? {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        calendar.timeZone = TimeZone.init(abbreviation: "UTC")!
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        let date = calendar.date(from: components as DateComponents)
        return date! as NSDate
    }
    
    func getYear() -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let components = calendar.components([.year], from: self as Date)
        return components.year!
    }
    
    func getMonth() -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let components = calendar.components([.month], from: self as Date)
        return components.month!
    }
    
    func getDay() -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let components = calendar.components([.day], from: self as Date)
        return components.day!
    }
    
    func getDayOfWeek() -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let components = calendar.components([.weekday], from: self as Date)
        return components.weekday!
    }
    
    func startOfMonth() -> NSDate? {

        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let currentDateComponents = calendar.components([.year, .month], from: self as Date)
        let startOfMonth = calendar.date(from: currentDateComponents)

        return startOfMonth as NSDate?
    }

    func dateByAddingMonths(monthsToAdd: Int) -> NSDate? {

        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let months = NSDateComponents()
        months.month = monthsToAdd

        return calendar.date(byAdding: months as DateComponents, to: self as Date, options: []) as NSDate?
    }

    func endOfMonth() -> NSDate? {

        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        if let plusOneMonthDate = dateByAddingMonths(monthsToAdd: 1) {
            let plusOneMonthDateComponents = calendar.components([.year, .month], from: plusOneMonthDate as Date)

            let plusOneMonthDateComponentsDate = calendar.date(from: plusOneMonthDateComponents) as NSDate?
            let endOfMonth = plusOneMonthDateComponentsDate?.addingTimeInterval(-1)

            return endOfMonth
        }

        return nil
    }
    
    func isWeekend() -> Bool {
        return getDayOfWeek() == 1
    }
    
    func getDayOfWeekString() -> String {
         var result = "";
         switch (getDayOfWeek()) {
             case 1:
                 result = "Нд"
                 break
             case 2:
                 result = "Пн"
                 break
             case 3:
                 result = "Вт"
                 break
             case 4:
                 result = "Ср"
                 break
             case 5:
                 result = "Чт"
                 break
             case 6:
                 result = "Пт"
                 break
             case 7:
                 result = "Сб"
                 break
             default:
                 break
         }
         return result;
     }
    
    func getDayString() -> String {
        let dayInt = getDay()
        return "\(dayInt)"
    }
    
    func getOldStyleDayString() -> String {
        var dayOldInt = getDay() - 13
        if(dayOldInt < 1) {
            switch (getMonth()) {
                case 1, 2, 4, 6, 8, 9, 11:
                    dayOldInt = dayOldInt+31
                    break
                case 3:
                    dayOldInt = dayOldInt+28
                    break
                case 5, 7, 10, 12:
                    dayOldInt = dayOldInt+30
                    break
                default:
                    break
            }
        }
        
        return "\(dayOldInt)"
    }
    
    func isToday() -> Bool
    {
        return isSameDay(date: NSDate.init())
    }


    func isSameDay(date: NSDate) -> Bool
    {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        var components = calendar.components([.year, .month, .day], from: date as Date)
        guard let argDate = calendar.date(from: components) else {
            return false
        }
        components = calendar.components([.year, .month, .day], from: self as Date)
        guard let selfDate =  calendar.date(from: components) else {
            return false
        }
        return argDate.compare(selfDate) == ComparisonResult.orderedSame
    }
    
    func getMonthName() -> String {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let components = calendar.components([.year, .month], from: self as Date)
        
        return "\(NSDate.MONTH_NAMES[components.month!-1]) (\(components.year!))"
    }
}
