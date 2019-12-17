//
//  Day.swift
//  Calendar
//
//  Created by Developer on 2/26/19.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import Foundation
import CoreData
import CoreStore

enum Fasting: Int {
    case none = 0
    case simple = 1
    case strong = 2
    case free = 3
}

enum Holiday: Int {
    case none = 0
    case simple = 1
    case lord = 2
    case lady = 3
}

enum Text: Int {
    case rule = 0
    case morning = 1
    case evening = 2
    case hours = 3
    case liturgy = 4
    case holiday = 5
    case quotes = 6
}

extension Day {
    func fillText(type:Text, text:String) {
        switch type {
        case .holiday:
            self.txtHoliday = text
        case .quotes:
            self.txtQuotes = text
        case .rule:
            self.txtRule = text
        case .evening:
            self.txtEvening = text
        case .morning:
            self.txtMorning = text
        case .hours:
            self.txtHours = text
        case .liturgy:
            self.txtLiturgy = text
        }
    }
}

class Day: NSManagedObject, ImportableUniqueObject {
    
    @NSManaged public var date: NSDate
    @NSManaged public var holiday: String
    @NSManaged public var readings: String
    @NSManaged public var echos: String
    @NSManaged public var colorText: String
    @NSManaged public var colorTitleBg: String
    @NSManaged public var colorMainBg: String
    @NSManaged public var typeFasting: Int16
    @NSManaged public var typeHoliday: Int16
    @NSManaged public var txtHoliday: String?
    @NSManaged public var txtQuotes: String?
    @NSManaged public var txtRule: String?
    @NSManaged public var txtEvening: String?
    @NSManaged public var txtMorning: String?
    @NSManaged public var txtHours: String?
    @NSManaged public var txtLiturgy: String?
    
    // MARK: ImportableUniqueObject
    typealias ImportSource = [String]
    
    class var uniqueIDKeyPath: String {
        return #keyPath(Day.date)
    }
    
    var uniqueIDValue: NSDate {
        get { return self.date }
        set { self.date = newValue }
    }
    
    class func uniqueID(from source: ImportSource, in transaction: BaseDataTransaction) throws -> NSDate? {
        guard let year = Int(source[0]), let month = Int(source[1]), let day = Int(source[2]) else {
            throw CalendarError.unsupportedFormat
        }
        return NSDate.from(day: day, month: month, year: year)
    }
    
    func update(from source: ImportSource, in transaction: BaseDataTransaction) throws {
        guard let year = Int(source[0]), let month = Int(source[1]), let day = Int(source[2]) else {
            throw CalendarError.unsupportedFormat
        }
        guard let date = NSDate.from(day: day, month: month, year: year) else {
            throw CalendarError.unsupportedFormat
        }
        self.date = date
        
        guard let typeHoliday = Int16(source[4]), let typeSomething = Int16(source[5]), let typeFasting = Int16(source[6]) else {
            throw CalendarError.unsupportedFormat
        }

        self.typeHoliday = typeHoliday
        self.typeFasting = typeFasting
        self.holiday = source[7]
        self.readings = source[8]
        self.echos = source[9]
        
        self.colorMainBg = ""
        self.colorText = ""
        self.colorTitleBg = ""
    }
    
    
    func getContentButtonImage(_ type:Text) -> (String?, UIImage?) {
        var text:String? = nil
        var btnImage = ""
        switch type {
            case .rule:
                text = self.txtRule
                btnImage = "day_txt_rule"
                break
            case .morning:
                text = self.txtMorning
                btnImage = "day_txt_morning"
                break
            case .evening:
                text = self.txtEvening
                btnImage = "day_txt_evening"
                break
            case .hours:
                text = self.txtHours
                btnImage = "day_txt_hours"
                break
            case .liturgy:
                text = self.txtLiturgy
                btnImage = "day_txt_liturgy"
                break
            case .holiday:
                text = self.txtHoliday
                btnImage = "day_txt_holiday"
                break
            case .quotes:
                text = self.txtQuotes
                btnImage = "day_txt_quotes"
                break
        }
        let image  = UIImage.init(imageLiteralResourceName: btnImage)
        return (text, image)
    }
    
    func getContentTitleText(_ type:Text) -> (String?, String) {
        var text:String? = ""
        var title = ""
        switch type {
            case .rule:
                text = self.txtRule
                title = "Устав"
                break
            case .morning:
                text = self.txtMorning
                title = "Утреня"
                break
            case .evening:
                text = self.txtEvening
                title = "Вечірня"
                break
            case .hours:
                text = self.txtHours
                title = "Часи"
                break
            case .liturgy:
                text = self.txtLiturgy
                title = "Літургія"
                break
            case .holiday:
                text = self.txtHoliday
                title = "Свято"
                break
            case .quotes:
                text = self.txtQuotes
                title = "Перлини"
                break
        }
        return (text, title)
    }
}
