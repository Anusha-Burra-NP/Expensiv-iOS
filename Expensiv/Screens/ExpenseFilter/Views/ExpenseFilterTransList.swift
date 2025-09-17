//
//  ExpenseFilterTransList.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI

struct ExpenseFilterTransList: View {
    var isIncome: Bool?
    var tag: String?
    var fetchRequest: FetchRequest<ExpensivCD>
    var expense: FetchedResults<ExpensivCD> { fetchRequest.wrappedValue }
    
    init(isIncome: Bool? = nil, filter: ExpensivCDFilterTime, tag: String? = nil) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        if filter == .all {
            let predicate: NSPredicate!
            if let isIncome = isIncome {
                predicate = NSPredicate(format: "type == %@", (isIncome ? TransactionType.income.rawValue : TransactionType.expense.rawValue))
            } else if let tag = tag { predicate = NSPredicate(format: "tag == %@", tag) }
            else { predicate = NSPredicate(format: "occuredOn <= %@", NSDate()) }
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week {
                startDate = Date().getLast7Day()! as NSDate
            }
            else if filter == .month { startDate = Date().getLast30Day()! as NSDate }
            else { startDate = Date().getLast6Month()! as NSDate }
            let predicate: NSPredicate!
            if let isIncome = isIncome {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", startDate, endDate, (isIncome ? TransactionType.income.rawValue : TransactionType.expense.rawValue))
            } else if let tag = tag {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND tag == %@", startDate, endDate, tag)
            } else { predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate) }
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    var body: some View {
        ForEach(self.fetchRequest.wrappedValue) { expenseObj in
            NavigationLink {
                ExpenseDetailedView(expenseObj: expenseObj)
            } label: {
                ExpenseTransView(transactionObj: expenseObj)
            }
        }
    }
}


