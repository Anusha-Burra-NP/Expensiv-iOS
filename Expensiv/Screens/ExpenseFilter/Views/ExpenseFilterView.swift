//
//  ExpenseFilterView.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import SwiftUI
import Charts

struct ExpenseFilterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: ExpensivCD.getAllExpenseData(sortBy: ExpensivCDSort.occuredOn, ascending: false)) var expense: FetchedResults<ExpensivCD>
    
    @State var filter: ExpensivCDFilterTime = .all
    @State var showingSheet = false
    
    var isIncome: Bool?
    var categoryTag: ExpenseCategoryTagType?
    
    init(isIncome: Bool? = nil, categTag: String? = nil) {
        self.isIncome = isIncome
        if let tag = categTag {
            self.categoryTag = ExpenseCategoryTagType(rawValue: tag)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                VStack {
                    getToolbarView()
                    
                    ScrollView(showsIndicators: false) {
                        if let isIncome = isIncome {
                            ExpenseChartView(isIncome: isIncome, filter: filter)
                                .frame(width: 350, height: 350)
                            ExpenseFilterTransList(isIncome: isIncome, filter: filter)
                        }
                        
                        if let tag = categoryTag {
                            HStack(spacing: 8) {
                                ExpenseTypeView(isIncome: true, filter: filter, categTag: tag.rawValue)
                                ExpenseTypeView(isIncome: false, filter: filter, categTag: tag.rawValue)
                            }.frame(maxWidth: .infinity)
                            
                            ExpenseFilterTransList(filter: filter, tag: tag.rawValue)
                        }
                        Spacer()
                            .frame(height: 150)
                    }.padding(.horizontal, 8)
                        .padding(.top, 0)
                    
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func getToolbarTitle() -> String {
        if let isIncome = isIncome {
            return isIncome ? Constants.incomeText : Constants.expenseText
        } else if let tag = categoryTag {
            return tag.getTagTitle()
        }
        return Constants.DashboardText
    }
    
    func getToolbarView() -> some View {
        ToolbarView(
            title: getToolbarTitle(),
            button1Icon: Constants.filterIcon
        ) {
            self.presentationMode.wrappedValue.dismiss()
        } button1Method: {
            self.showingSheet = true
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text(Constants.selectFilterText), buttons: [
                .default(Text(Constants.overallText)) { filter = .all },
                .default(Text(Constants.lastSevenDaysText)) { filter = .week },
                .default(Text(Constants.lastThirtyDaysText)) { filter = .month },
                    .cancel()
            ])
        }
    }
}

#Preview {
    ExpenseFilterView()
}
