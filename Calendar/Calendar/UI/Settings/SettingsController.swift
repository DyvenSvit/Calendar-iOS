//
//  SettingsController.swift
//  Calendar
//
//  Created by Developer on 02.01.2021.
//  Copyright © 2021 DyvenSvit. All rights reserved.
//

import UIKit

class SettingsController: UIViewController, Storyboarded {

    
    @IBOutlet weak var swStartDayFromEvening: UISwitch!
    @IBOutlet weak var swCalendarGregorian: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Налаштування"
        
        swStartDayFromEvening.isOn = AppSettings.boolValue(.startDayFromEvening)
        swStartDayFromEvening.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        swCalendarGregorian.isOn = AppSettings.boolValue(.calendarGregorian)
        swCalendarGregorian.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchChanged(mySwitch: UISwitch) throws {
        let value = mySwitch.isOn
        switch mySwitch {
        case swStartDayFromEvening:
            AppSettings[.startDayFromEvening] = value
            AppSettings[.calendarReload] = true
        case swCalendarGregorian:
            AppSettings[.calendarGregorian] = value
            AppSettings[.calendarReload] = true
            CoreStoreStack.deleteAll()
        default:
            throw CalendarError.invalidArgument
        }
    }

}
