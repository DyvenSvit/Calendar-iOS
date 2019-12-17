//
//  DayCell.swift
//  Calendar
//
//  Created by Maksym Gontar on 02.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

class DayCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgFasting: UIImageView!
    @IBOutlet weak var lbOldStyleDate: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbDayOfWeek: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbReading: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    
    var day:Day? {
        
        didSet {
            if let day = self.day {
                lbTitle.attributedText = ((day.typeHoliday != 0) ? "<font color='#FF0000'>\(day.holiday)</font>" : day.holiday).htmlToAttributedString
                lbReading.attributedText = ("\(day.echos == "*" ? "" : day.echos) \(day.readings == "*" ? "" : day.readings)").htmlToAttributedString
                lbOldStyleDate.text = day.date.getOldStyleDayString()
                lbDate.text = day.date.getDayString()
                lbDayOfWeek.text = day.date.getDayOfWeekString()
                
                bgView.backgroundColor = getDayMainBgColor()
                infoView.alpha = getDayBgAlpha()
                dateView.alpha = getDayBgAlpha()
                imgFasting.image = getFastingImage()
            }
        }
    }
    
    
    func getDayMainBgColor() -> UIColor
    {
       var result =  UIColor("#9FFF00")
        
        guard let day = day else {
            return result
        }
        
        guard let holiday = Fasting(rawValue:Int(day.typeHoliday)) else {
            return result
        }
        
        if(holiday != .none || day.date.isWeekend())
        {
            result = UIColor("#FF7400")
        }
        
        let fasting = getFastingTypeU(day:day)
        
        switch fasting {
        case .none:
                break;
        case .simple:
                result = UIColor("#AA00FF")
                break;
        case .strong:
                result = UIColor("#AB47BC")
                break;
        case .free:
                break;
        }
        return result;
    }

    func getDayBgAlpha() -> CGFloat
    {
        let result = day?.date.isToday() ?? false ? 0.90:0.70;
        
        return CGFloat(result);
    }

    func getFastingTypeU(day: Day) -> Fasting
    {
        var result = Fasting.none
        guard let fasting = Fasting(rawValue:Int(day.typeFasting)) else {
            return result
        }
        
        switch (fasting) {
        case .none:
            result = .none
            break
        case .simple:
                let year = day.date.getYear()
                let month = day.date.getMonth()
                let dday = day.date.getDay()
                let wday = day.date.getDayOfWeek()
                
                if ((month > 1 && month < 6) && (wday == 2||wday == 4||wday == 6))
                {
                    result = .simple
                }
                else if (wday == 4||wday == 6)
                {
                    result = .strong
                }
                else if (year == 2017 && ((month == 2 && dday == 28) ||
                                          (month == 3 && dday == 2) ||
                                          (month == 4 && dday == 11) ||
                                          (month == 4 && dday == 13) ||
                                          (month == 4 && dday == 15)))
                {
                    result = .simple
                }
                else
                {
                    result = .free
                }

                break
        case .strong:
            result = .strong
                break;
        case .free:
            result = .free
                break
        }
        return result
    }

    func getFastingImage() -> UIImage?
    {
        var result: UIImage? = nil
        
        guard let day = day else {
            return result
        }
        
        switch (getFastingTypeU(day: day)) {
        case .none:
                result = nil;
                break;
        case .simple:
            result = UIImage.init(imageLiteralResourceName:"fasting")
            result = #imageLiteral(resourceName: "fasting.png")
                break
        case .strong:
                result = UIImage.init(imageLiteralResourceName:"fasting_strong")
                result = #imageLiteral(resourceName: "fasting_strong.png")
                break
        case .free:
                result = nil
                break
        }
        return result
    }
}
