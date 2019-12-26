
//
//  AKMonthYearPickerView.swift
//  AKMonthYearPickerView
//
//  Created by Ali Khan on 11/Jul/18.
//  Copyright © 2018 Ali Khan. All rights reserved.
//
/*
 AKMonthYearPickerView is a lightweight, clean and easy-to-use Month picker control in iOS written in Swift language.
 https://github.com/ali-cs/AKMonthYearPickerView
 */

import Foundation
import UIKit

class AKMonthYearPickerView: UIView {
    
    //MARK:- Variables
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var onDoneButtonSelected: (() -> Void)?
    
    private var monthYearPickerView : MonthYearPickerView?
    public  var barTintColor        = UIColor.blue
    
    public static var sharedInstance   = {
        return AKMonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 216)))
    }()
    
    var toolBar : UIToolbar?
    
    //MARK:- Inilizers
    
    convenience init() {
        let frame = CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 216))
        
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = UIColor.white
        
        layer.borderColor   = UIColor(red: 212.0/255.0, green: 212.0/255.0, blue: 212.0/255.0, alpha: 1.0).cgColor
        
        layer.borderWidth   = 1.0
        layer.cornerRadius  = 7.0
        layer.masksToBounds = true
        
        monthYearPickerView = MonthYearPickerView(frame: CGRect(x: frame.origin.x, y: frame.origin.y+40, width: frame.size.width, height: frame.size.height))
    
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- Helper Mehtods
    
    public func show(vc: UIViewController, selectedMonth:Int, selectedYear:Int, doneHandler: @escaping () -> (), completetionalHandler: @escaping (Int, Int) -> () ) {
        
        monthYearPickerView?.onDateSelected = completetionalHandler
        onDoneButtonSelected = doneHandler
        
        if let doneToolBar = toolBar {
            vc.view.addSubview(doneToolBar)
        }
        else {
            toolBar = getToolBar()
            vc.view.addSubview(toolBar!)
        }
        toolBar?.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
        toolBar?.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
        toolBar?.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 0).isActive = true
        toolBar?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        vc.view.addSubview(monthYearPickerView!)
        
        toolBar?.isHidden             = false
        monthYearPickerView?.isHidden = false
        
        monthYearPickerView?.selectRow(selectedMonth - 1, inComponent: 0, animated: false)
        
        if let selectedYearIndex = monthYearPickerView?.years.firstIndex(of: selectedYear) {
            monthYearPickerView?.selectRow(selectedYearIndex, inComponent: 1, animated: false)
        }
    }
    
    public func hide() {
        monthYearPickerView?.hide()
        AKMonthYearPickerView.sharedInstance.removeFromSuperview()
        toolBar?.isHidden = true
        self.isHidden     = true
    }
    
    private func getToolBar() -> UIToolbar {
        
        let customToolbar          = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 40)))
        
        customToolbar.barStyle     = .blackOpaque
        customToolbar.barTintColor = barTintColor
        customToolbar.tintColor    = .white
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePressed(_:)))
        customToolbar.items = [flexButton, doneButton]
        return customToolbar
    }
    
    @objc func donePressed(_ sender: Any) {
        onDoneButtonSelected?()
        hide()
    }
}

struct AKMonthYearPickerConstants {
    
    struct AppFrameSettings {
        
        static var screenHeight : CGFloat {
            if UIDevice.current.orientation.isLandscape {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
        
        static var screenWidth : CGFloat {
            if UIDevice.current.orientation.isLandscape {
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
    }
}

/// This class is responsible for handling the pickerView delegate and datasource
class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK:- Variables
    
    var months          : [String]!
    var years           : [Int]!
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 1, animated: true)
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    static var sharedInstance   = {
        return MonthYearPickerView(frame: CGRect(origin: CGPoint(x: 0, y: (AKMonthYearPickerConstants.AppFrameSettings.screenHeight - 256) / 2), size: CGSize(width: AKMonthYearPickerConstants.AppFrameSettings.screenWidth, height: 216)))
    }()
    
    //MARK:- Inilizers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    //MARK:- Helper Methods
    
    func show(vc: UIViewController, completetionalHandler: @escaping (Int, Int) -> () ) {
        
        MonthYearPickerView.sharedInstance.onDateSelected = completetionalHandler
        commonSetup()
        
        vc.view.addSubview(MonthYearPickerView.sharedInstance)
    }
    
    internal func hide() {
        MonthYearPickerView.sharedInstance.removeFromSuperview()
        self.isHidden = true
    }
    
    func commonSetup() {
        self.years = [2018, 2019, 2020]
        self.months = NSDate.MONTH_NAMES
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        let currentYear = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        self.selectRow(self.years.firstIndex(of: currentYear)!, inComponent: 1, animated: false)
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = selectedRow(inComponent: 0)+1
        let year  = years[selectedRow(inComponent: 1)]
        
        if let block = onDateSelected {
            block(month, year)
        }
        
        self.month = month
        self.year = year
    }
    
}
