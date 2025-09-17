//
//  ExpenseSettingsView.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import SwiftUI

struct ExpenseSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    // CoreData
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject private var viewModel = ExpenseSettingsViewModel()
    @State private var selectCurrency = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    ToolbarView(title: Constants.settingsText) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                    VStack {
                        HStack {
                            TextView(
                                text: "Enable \(viewModel.getBiometricType())",
                                type: .button
                            ).foregroundColor(Color.text_primary_color)
                            Spacer()
                            Toggle("", isOn: $viewModel.enableBiometric)
                                .toggleStyle(SwitchToggleStyle(tint: Color.main_color))
                        }.padding(8)
                        
                        Button(action: {
                            selectCurrency = true
                        }, label: {
                            HStack {
                                Spacer()
                                TextView(text: "\(Constants.currencyText) - \(viewModel.currency)", type: .button).foregroundColor(Color.text_primary_color)
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color.secondary_color)
                        .cornerRadius(4)
                        .foregroundColor(Color.text_primary_color)
                        .accentColor(Color.text_primary_color)
                        .actionSheet(isPresented: $selectCurrency) {
                            var buttons: [ActionSheet.Button] = Constants.CurrencyList.map { curr in
                                ActionSheet.Button.default(Text(curr)) { viewModel.saveCurrency(currency: curr) }
                            }
                            buttons.append(.cancel())
                            return ActionSheet(title: Text(Constants.selectCurrencyText), buttons: buttons)
                        }
                        
                        Button(action: { viewModel.exportTransactions(moc: managedObjectContext) }, label: {
                            HStack {
                                Spacer()
                                TextView(text: Constants.exportTransactionsText,
                                         type: .button
                                ).foregroundColor(Color.text_primary_color)
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color.secondary_color)
                        .cornerRadius(4)
                        .foregroundColor(Color.text_primary_color)
                        .accentColor(Color.text_primary_color)
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(Constants.tickIcon)
                                    .resizable()
                                    .frame(width: 32.0, height: 32.0)
                            }).padding()
                                .background(Color.main_color)
                                .cornerRadius(35)
                        }
                    }
                    .padding(.horizontal, 8).padding(.top, 1)
                    .alert(isPresented: $viewModel.showAlert,
                           content: { Alert(title: Text(Constants.AppName), message: Text(viewModel.alertMsg), dismissButton: .default(Text(Constants.okText))) })
                }.edgesIgnoringSafeArea(.top)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ExpenseSettingsView()
}

