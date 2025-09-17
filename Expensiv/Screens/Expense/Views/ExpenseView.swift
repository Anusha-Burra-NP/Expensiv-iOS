//
//  ExpenseView.swift
//  Expensiv
//
//  Created by Anusha NP on 7/9/2025.
//

import SwiftUI
import CoreData

struct ExpenseView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var navigationPath = NavigationPath()
    @State private var filter: ExpensivCDFilterTime = .all
    @State private var showFilterSheet = false
    @State private var showOptionsSheet = false
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    getToolbarView()
                    Spacer()
                    getBalanceView()
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
                
                floatingActionButton()
            }
            .navigationDestination(for: String.self) { pathItem in
                if pathItem == Constants.settingsPath {
                    ExpenseSettingsView()
                } else if pathItem == Constants.aboutPath {
                    AboutView()
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
    
    func getToolbarView() -> some View {
        ToolbarView(title: Constants.DashboardText, hasBackButt: false, button1Icon: Constants.optionIcon, button2Icon: Constants.filterIcon) {
            self.presentationMode.wrappedValue.dismiss()
        } button1Method: {
            self.showOptionsSheet = true
        } button2Method: {
            self.showFilterSheet = true
        }
        .actionSheet(isPresented: $showFilterSheet) {
            ActionSheet(title: Text(Constants.selectFilterText), buttons: [
                .default(Text(Constants.overallText)) { filter = .all },
                .default(Text(Constants.lastSevenDaysText)) { filter = .week },
                .default(Text(Constants.lastThirtyDaysText)) { filter = .month },
                .cancel()
            ])
        }
    }
    
    func getBalanceView() -> some View {
        ExpenseBalanceView(filter: filter)
            .confirmationDialog(Constants.selectOptionText, isPresented: $showOptionsSheet, titleVisibility: .visible) {
                Button(Constants.aboutText) {
                    navigationPath.append(Constants.aboutPath)
                }
                Button(Constants.settingsText) {
                    navigationPath.append(Constants.settingsPath)
                }
            }
    }
    
    func floatingActionButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: NavigationLazyView(AddExpenseView(viewModel: AddExpenseViewModel()))) {
                    Image(Constants.plusIcon)
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                }.padding()
                    .background(Color.main_color)
                    .cornerRadius(35)
            }
        }.padding()
    }
}

#Preview {
    ExpenseView()
}
