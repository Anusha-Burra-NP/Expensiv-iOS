//
//  ExpenseChartView.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI
import Charts

struct ExpenseChartView: View {
    
    @AppStorage(Constants.UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    var isIncome: Bool
    var transactionType: String
    var fetchRequest: FetchRequest<ExpensivCD>
    var expense: FetchedResults<ExpensivCD> { fetchRequest.wrappedValue }
    
    init(isIncome: Bool, filter: ExpensivCDFilterTime) {
        self.isIncome = isIncome
        self.transactionType = isIncome ? TransactionType.income.rawValue : TransactionType.expense.rawValue
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        if filter == .all {
            let predicate = NSPredicate(format: "type == %@", transactionType)
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week { startDate = Date().getLast7Day()! as NSDate }
            else if filter == .month { startDate = Date().getLast30Day()! as NSDate }
            else { startDate = Date().getLast6Month()! as NSDate }
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", startDate, endDate, transactionType)
            fetchRequest = FetchRequest<ExpensivCD>(entity: ExpensivCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    private func getChartData() -> [pieChartModel] {
        var transactions = [String: Double]()
        
        for i in expense {
            guard let tag = i.tag else { continue }
            if let value = transactions[tag] {
                transactions[tag] = value + i.amount
            } else {
                transactions[tag] = i.amount
            }
        }
        
        var data = [pieChartModel]()
        for i in transactions {
            let type = ExpenseCategoryTagType(rawValue: i.key)?.getTagTitle() ?? ""
            data.append(pieChartModel(transType: type, transAmount: i.value))
        }
        return data
    }
    
    private func getTotalValue() -> Int {
        var totalValue: Int = 0
        for i in expense {
            totalValue = totalValue + Int(i.amount)
        }
        return totalValue
    }
    
    var body: some View {
        VStack {
            Chart(getChartData(), id: \.transType) { item in
                SectorMark(
                    angle: .value("Count", item.transAmount),
                    innerRadius: .ratio(0.7),
                    angularInset: 2
                )
                .foregroundStyle(by: .value("Category", item.transType))
                .opacity(0.8)
            }.scaledToFit()
                .chartLegend(alignment: .center, spacing: 16)
                .chartBackground { chartProxy in
                    GeometryReader { geometry in
                        if let anchor = chartProxy.plotFrame {
                            let frame = geometry[anchor]
                            VStack {
                                Text(isIncome ? Constants.incomeText : Constants.expenseText)
                                    .font(.callout)
                                Text("\(getTotalValue())")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            .position(x: frame.midX, y: frame.midY)
                        }
                    }
                }
        }.frame(height: 250)
            .padding(20)
            .background(Color.white.cornerRadius(15))
    }
}
