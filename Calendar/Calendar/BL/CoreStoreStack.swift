//
//  CoreStoreStack.swift
//  Calendar
//
//  Created by Developer on 2/26/19.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import Foundation
import CoreStore

struct CoreStoreStack {
    
    static let configuration = "Default"
    
    static let stack: DataStack = {
        let dataStack = DataStack(xcodeModelName: "Calendar")
        
        do {
            try dataStack.addStorageAndWait(
                SQLiteStore(
                    fileName: "Calendar.sqlite", // set the target file URL for the sqlite file
                    localStorageOptions: .recreateStoreOnModelMismatch // if migration paths cannot be resolved, recreate the sqlite file
                )
            )
            
        } catch {
            print("Error coredata \(error)")
        }
        
        return dataStack
    }()
    
    static func getDays(month:Int, year:Int) -> [Day] {
        guard let date = NSDate.from(day: 1, month: month, year: year) else {
            return []
        }
        
        guard let startDate = date.startOfMonth() else {
            return []
        }
        
        guard let endDate = date.endOfMonth() else {
            return []
        }
        
        let days = try? CoreStoreStack.stack.fetchAll(
            From<Day>(Day.self),
            Where<Day>("date >= %@ AND date <= %@", startDate, endDate),
            OrderBy<Day>(.ascending("date"))
        )
        
        return days ?? []
    }
    
    static func deleteAll() {
        CoreStoreStack.stack.perform(
            asynchronous: { (transaction) -> Void in
                try transaction.deleteAll(
                    From<Day>()
                )
            },
            completion: { _ in }
        )
    }
}
