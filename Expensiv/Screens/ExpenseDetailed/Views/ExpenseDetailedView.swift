//
//  ExpenseDetailedView.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import SwiftUI

struct ExpenseDetailedView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @ObservedObject private var viewModel: ExpenseDetailedViewModel
    @AppStorage(Constants.UD_EXPENSE_CURRENCY) var CURRENCY: String = ""
    
    @State private var confirmDelete = false
    
    init(expenseObj: ExpensivCD) {
        viewModel = ExpenseDetailedViewModel(expenseObj: expenseObj)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                VStack {
                    getToolbarView()
                    getDetailsView()
                }.edgesIgnoringSafeArea(.all)
                getEditButtonView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    func getToolbarView() -> some View {
        ToolbarView(title: Constants.detailsText, button1Icon: Constants.deleteIcon) {
            self.presentationMode.wrappedValue.dismiss()
        }  button1Method: {
            self.confirmDelete = true
        }
    }
    
    func getDetailsView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                ExpenseDetailedListView(title: Constants.titleText, description: viewModel.expenseObj.title ?? "")
                ExpenseDetailedListView(title: Constants.amountText, description: "\(CURRENCY)\(viewModel.expenseObj.amount)")
                ExpenseDetailedListView(title: Constants.transactionTypeText, description: viewModel.expenseObj.type == TransactionType.income.rawValue ? Constants.incomeText : Constants.expenseText )
                ExpenseDetailedListView(title: Constants.tagTitle, description: ExpenseCategoryTagType(rawValue: viewModel.expenseObj.tag ?? "")?.getTagTitle() ?? "")
                ExpenseDetailedListView(title: Constants.whenText, description: Helpers.getDateFormatter(date: viewModel.expenseObj.occuredOn, format: "EEEE, dd MMM hh:mm a"))
                
                if let note = viewModel.expenseObj.note, note != "" {
                    ExpenseDetailedListView(title: Constants.noteText, description: note)
                }
                
                if let data = viewModel.expenseObj.imageAttached {
                    VStack(spacing: 8) {
                        HStack {
                            TextView(text: Constants.attachmentText, type: .caption).foregroundColor(Color.init(hex: "828282"))
                            Spacer()
                        }
                        Image(uiImage: UIImage(data: data)!)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250).frame(maxWidth: .infinity)
                            .background(Color.secondary_color)
                            .cornerRadius(4)
                    }
                }
            }.padding(16)
            
            Spacer().frame(height: 24)
            Spacer()
        }.alert(
            isPresented: $confirmDelete,
            content: {
                Alert(
                    title: Text(Constants.AppName),
                    message: Text(Constants.deleteTransactionDetailText),
                    primaryButton: .destructive(Text(Constants.deleteText)) {
                        viewModel.deleteExepnseObj(managedObjectContext: managedObjectContext)
                    },
                    secondaryButton: Alert.Button.cancel (
                        Text(Constants.cancelText),
                        action: {
                            confirmDelete = false
                        }
                    )
                )
            })
    }
    
    func getEditButtonView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    NavigationLazyView(AddExpenseView(viewModel: AddExpenseViewModel(expenseObj: viewModel.expenseObj)))
                } label: {
                    Image(Constants.pencilIcon)
                        .resizable()
                        .frame(width: 28.0, height: 28.0)
                    
                    Text(Constants.editText)
                        .modifier(InterFont(.semiBold, size: 18))
                        .foregroundColor(.white)
                }
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 20))
                .background(Color.main_color)
                .cornerRadius(25)
            }.padding(24)
        }
    }
}

