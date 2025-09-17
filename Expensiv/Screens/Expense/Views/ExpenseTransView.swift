//
//  ExpenseTransView.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI

struct ExpenseTransView: View {
    
    @ObservedObject var transactionObj: ExpensivCD
    @AppStorage(Constants.UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    var body: some View {
        HStack {
            NavigationLink(
                destination: NavigationLazyView(ExpenseFilterView(categTag: transactionObj.tag)),
                label: {
                    Image(ExpenseCategoryTagType(rawValue: transactionObj.tag ?? "")?.getTagIcon() ?? "")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(16)
                        .background(Color.primary_color)
                        .cornerRadius(8)
                }
            )
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    TextView(text: transactionObj.title ?? "", type: .subtitle_1, lineLimit: 1).foregroundColor(Color.text_primary_color)
                    Spacer()
                    TextView(text: "\(transactionObj.type == TransactionType.income.rawValue ? "+" : "-")\(CURRENCY)\(transactionObj.amount)", type: .subtitle_1)
                        .foregroundColor(transactionObj.type == TransactionType.income.rawValue ? Color.main_green : Color.main_red)
                }
                
                HStack {
                    TextView(text: ExpenseCategoryTagType(rawValue: transactionObj.tag ?? "")?.getTagTitle() ?? "", type: .body_2).foregroundColor(Color.text_primary_color)
                    Spacer()
                    TextView(text: Helpers.getDateFormatter(date: transactionObj.occuredOn, format: "MMM dd, yyyy"), type: .body_2).foregroundColor(Color.text_primary_color)
                }
            }.padding(.leading, 4)
            
            Spacer()
        }.padding(8)
            .background(Color.secondary_color)
            .cornerRadius(8)
    }
}

