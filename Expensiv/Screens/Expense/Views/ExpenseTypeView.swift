//
//  ExpenseTypeView.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI

struct ExpenseTypeView: View {
    var isIncome: Bool
    var type: String
    var fetchRequest: FetchRequest<ExpensivCD>
    var expense: FetchedResults<ExpensivCD> { fetchRequest.wrappedValue }
    @AppStorage(Constants.UD_EXPENSE_CURRENCY) 
    var CURRENCY: String = ""
    
    init(isIncome: Bool, filter: ExpensivCDFilterTime, categTag: String? = nil) {
        self.isIncome = isIncome
        self.type = isIncome ? TransactionType.income.rawValue : TransactionType.expense.rawValue
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        if filter == .all {
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "type == %@ AND tag == %@", type, tag)
            } else {
                predicate = NSPredicate(format: "type == %@", type)
            }
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week {
                startDate = Date().getLast7Day()! as NSDate
            } else if filter == .month {
                startDate = Date().getLast30Day()! as NSDate
            } else {
                startDate = Date().getLast6Month()! as NSDate
            }
            
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@ AND tag == %@", startDate, endDate, type, tag)
            } else {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", startDate, endDate, type)
            }
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    private func getTotalValue() -> String {
        var value = Double(0)
        for i in expense { value += i.amount }
        return "\(String(format: "%.2f", value))"
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Image(isIncome ? Constants.incomeIcon : Constants.expenseIcon).resizable().frame(width: 40.0, height: 40.0).padding(12)
            }
            
            HStack {
                TextView(text: isIncome ? Constants.incomeText.uppercased() : Constants.expenseText.uppercased(), type: .overline).foregroundColor(Color.init(hex: "828282"))
                Spacer()
            }.padding(.horizontal, 12)
            
            HStack {
                TextView(text: "\(CURRENCY)\(getTotalValue())", type: .h5, lineLimit: 1).foregroundColor(Color.text_primary_color)
                Spacer()
            }.padding(.horizontal, 12)
            
        }.padding(.bottom, 12).background(Color.secondary_color).cornerRadius(4)
    }
}
