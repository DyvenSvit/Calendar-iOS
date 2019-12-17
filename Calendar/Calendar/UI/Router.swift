//
//  Router.swift
//  Calendar
//
//  Created by Maksym Gontar on 16.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit

class Router {
   
    static func openDay(_ day:Day, from navigationController: UINavigationController?) {
        let dayViewController = DayViewController.instantiate()
        dayViewController.day = day
        navigationController?.pushViewController(dayViewController, animated: true)
    }
    
    static func openInfo(from navigationController: UINavigationController?) {
        let infoViewController = InfoViewController.instantiate()
        navigationController?.pushViewController(infoViewController, animated: true)
    }
    
    static func openPrayerApp() {
        let customURL = "praycatholic://"
        guard let url = URL.init(string: customURL) else {return}
        if UIApplication.shared.canOpenURL(url)
        {
            openURL(url)
        }
        else {
            openURLString("https://itunes.apple.com/us/app/catholic-prayer-molitovnik/id1087833268?mt=8")
        }
    }
    
    static func openCalendarWeb() {
        openURLString("http://calendar.dyvensvit.org")
    }
    
    static func openCalendarFBGroup() {
        openURLString("https://www.facebook.com/groups/ugcc.calendar/")
    }
    
    static func openURLString(_ urlString:String) {
        guard let url = URL(string: urlString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func openURL(_ url:URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
