//
//  DayListViewController.swift
//  Calendar
//
//  Created by Maksym Gontar on 28.11.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit
import JGProgressHUD

class DayListViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableDays: UITableView!
    
    var selectedMonth = 1
    var selectedYear = 1
    var selectedMonthTmp = 1
    var selectedYearTmp = 1
    
    let dataSource = DayDataSource()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        let biMonth = UIUtils.getBarItemWithImageNamed("appbar_month", action:#selector(monthClick), target:self)!
        let biInfo = UIUtils.getBarItemWithImageNamed("appbar_info", action:#selector(infoClick), target:self)!
        let biPray = UIUtils.getBarItemWithImageNamed("appbar_pray", action:#selector(prayClick), target:self)!
        let biWWW = UIUtils.getBarItemWithImageNamed("appbar_www", action:#selector(wwwClick), target:self)!
        let biFB = UIUtils.getBarItemWithImageNamed("appbar_fb", action:#selector(fbClick), target:self)!

        self.navigationItem.rightBarButtonItems = [biInfo, biMonth]
        self.navigationItem.leftBarButtonItems = [biWWW, biFB, biPray]
        
        tableDays.register(UINib(nibName: "DayCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        tableDays.dataSource = dataSource
        tableDays.delegate = self

        selectedMonth = NSDate.init().getMonth()
        selectedYear = NSDate.init().getYear()
        loadSelectedYearMonth()
    }
    
    func loadSelectedYearMonth() {
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Завантаження"
        hud.show(in: self.view)
        self.navigationItem.title = NSDate.from(day: 1, month: selectedMonth, year: selectedYear)!.getMonthName()
        WebAPI.shared.getAllData(month: selectedMonth,
                                 year: selectedYear,
                                 progress: {
                                    progress in
                                    print("progress: \(Int(progress*100)) %")
                                    hud.progress = progress
                                    hud.detailTextLabel.text = "\(Int(progress*100))%"
                                    
        }, completion: {
            result, error in
            if let error = error {
                print(error)
            }
            
            self.dataSource.setDays(CoreStoreStack.getDays(month: self.selectedMonth, year: self.selectedYear))
            self.tableDays.reloadData()
            
            
            if let index = self.dataSource.getTodaysIndex() {
                self.tableDays.scrollToRow(at: IndexPath.init(row: index, section: 0), at: .top, animated: true)
            }
            else {
                self.tableDays.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            }
            
            hud.dismiss()
        })
    }
    
    @objc func monthClick() {
        AKMonthYearPickerView.sharedInstance.barTintColor = UIColor("#003000")
        AKMonthYearPickerView.sharedInstance.show(vc: self, selectedMonth: selectedMonth,
                                                  selectedYear: selectedYear, doneHandler: {
            print("done")
            self.selectedMonth = self.selectedMonthTmp
            self.selectedYear = self.selectedYearTmp
            self.loadSelectedYearMonth()
        }, completetionalHandler: {
            month, year in
            print("month \(month) year \(year)")
            self.selectedMonthTmp = month
            self.selectedYearTmp = year
        })
    }
    
    @objc func infoClick() {
        Router.openInfo(from: navigationController)
    }
    
    @objc func prayClick() {
        Router.openPrayerApp()
    }
    
    @objc func wwwClick() {
        Router.openCalendarWeb()
    }
    
    @objc func fbClick() {
        Router.openCalendarFBGroup()
    }
}

extension DayListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = dataSource.day(at: indexPath.row)
        Router.openDay(day, from: navigationController)
    }
}
