//
//  ExpensivCDExtension.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import CoreData
import SwiftUI

extension ExpensivCD {
    static func getAllExpenseData(sortBy: ExpensivCDSort = .occuredOn, ascending: Bool = true, filterTime: ExpensivCDFilterTime = .all) -> NSFetchRequest<ExpensivCD> {
        let request: NSFetchRequest<ExpensivCD> = ExpensivCD.fetchRequest() 
        let sortDescriptor = NSSortDescriptor(key: sortBy.rawValue, ascending: ascending)
        if filterTime == .week {
            let startDate: NSDate = Date().getLast7Day()! as NSDate
            let endDate: NSDate = NSDate()
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            request.predicate = predicate
        } else if filterTime == .month {
            let startDate: NSDate = Date().getLast30Day()! as NSDate
            let endDate: NSDate = NSDate()
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            request.predicate = predicate
        }
        request.sortDescriptors = [sortDescriptor]
        return request
    }
}
