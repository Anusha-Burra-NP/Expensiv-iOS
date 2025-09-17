//
//  ExpenseBalanceView.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI

struct ExpenseBalanceView: View {
    
    var filter: ExpensivCDFilterTime
    var fetchRequest: FetchRequest<ExpensivCD>
    var expense: FetchedResults<ExpensivCD> { fetchRequest.wrappedValue }
    @AppStorage(Constants.UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    init(filter: ExpensivCDFilterTime) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        self.filter = filter
        if filter == .all {
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor])
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
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    private func getTotalBalance() -> String {
        var value = Double(0)
        for i in expense {
            if i.type == TransactionType.income.rawValue { value += i.amount }
            else if i.type ==  TransactionType.expense.rawValue { value -= i.amount }
        }
        return "\(String(format: "%.2f", value))"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if fetchRequest.wrappedValue.isEmpty {
                VStack {
                    TextView(text: Constants.noTransactionYetText, type: .h6).foregroundColor(Color.text_primary_color)
                    TextView(text: Constants.addTransactionDetailText, type: .body_1).foregroundColor(Color.text_secondary_color).padding(.top, 2)
                }.padding(.horizontal)
                    .padding(.top, 20)
            } else {
                VStack(spacing: 16) {
                    TextView(text: Constants.totalBalanceText, type: .overline).foregroundColor(Color.init(hex: "828282")).padding(.top, 30)
                    TextView(text: "\(CURRENCY)\(getTotalBalance())", type: .h5).foregroundColor(Color.text_primary_color).padding(.bottom, 30)
                }.frame(maxWidth: .infinity).background(Color.secondary_color).cornerRadius(4)
                
                HStack(spacing: 8) {
                    NavigationLink(destination: NavigationLazyView(ExpenseFilterView(isIncome: true)),
                                   label: { ExpenseTypeView(isIncome: true, filter: filter) })
                    NavigationLink(destination: NavigationLazyView(ExpenseFilterView(isIncome: false)),
                                   label: { ExpenseTypeView(isIncome: false, filter: filter) })
                }.frame(maxWidth: .infinity)
                
                Spacer().frame(height: 16)
                
                HStack {
                    TextView(text: Constants.recentTransactionsText, type: .subtitle_1)
                        .foregroundColor(Color.text_primary_color)
                        .fontWeight(.bold)
                    Spacer()
                }.padding(4)
                
                ForEach(self.fetchRequest.wrappedValue) { transObject in
                    NavigationLink {
                        NavigationLazyView(ExpenseDetailedView(expenseObj: transObject))
                    } label: {
                        ExpenseTransView(transactionObj: transObject)
                    }
                }
            }
        }.padding(.horizontal, 8).padding(.top, 0)
    }
}

#Preview {
    ExpenseBalanceView(filter: .all)
}
