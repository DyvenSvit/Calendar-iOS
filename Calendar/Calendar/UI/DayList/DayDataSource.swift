//
//  DayDataSource.swift
//  Calendar
//
//  Created by Maksym Gontar on 16.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit

class DayDataSource: NSObject, UITableViewDataSource {
    
    var days = [Day]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath)
        if let dayCell = cell as? DayCell {
            dayCell.day = days[indexPath.row]
        }
        return cell
    }
    
    func day(at index:Int) -> Day {
        return days[index]
    }
    
    func setDays(_ days:[Day]) {
        self.days = days
    }
    
    func getTodaysIndex() -> Int? {
        let filtered = self.days.filter{ $0.date.isToday() }
        if let today = filtered.first, let index = self.days.firstIndex(of: today) {
            return index
        }
        else {
            return nil
        }
    }
}
