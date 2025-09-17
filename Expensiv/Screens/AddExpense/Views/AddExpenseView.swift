//
//  AddExpenseView.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var confirmDelete = false
    @State var showAttachSheet = false
    
    @StateObject var viewModel: AddExpenseViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.primary_color.edgesIgnoringSafeArea(.all)
                VStack {
                    getToolBarView()
                    getFormView()
                }
                getBottomButtonView()
            }.ignoresSafeArea()
        }
        .dismissKeyboardOnTap()
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$closePresenter) { close in
            if close {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    func getToolBarView() -> some View {
        Group {
            if viewModel.expenseObj == nil {
                ToolbarView(title: Constants.addTransactionText) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                ToolbarView(title: Constants.editTransactionText,
                            button1Icon: Constants.deleteIcon) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                button1Method: {
                    self.confirmDelete = true
                }
            }
        }.alert(isPresented: $confirmDelete, content: {
            Alert(title: Text(Constants.AppName),
                  message: Text(Constants.deleteTransactionDetailText),
                  primaryButton: .destructive(Text(Constants.deleteText)) {
                viewModel.deleteTransaction(managedObjectContext: self.managedObjectContext)
            }, secondaryButton: Alert.Button.cancel(Text(Constants.cancelText), action: {
                confirmDelete = false
            })
            )
        })
    }
    
    func getFormView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                getTitleView()
                getAmountView()
                getTypeTitleView()
                getTagTitleView()
                getDateView()
                getNotesView()
                getAttachImageView()
                if let image = viewModel.imageAttached {
                    getAttachedImageView(image: image)
                }
                Spacer().frame(height: 150)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .alert(
                isPresented: $viewModel.showAlert,
                content: {
                    Alert(
                        title: Text(Constants.AppName),
                        message: Text(viewModel.alertMsg),
                        dismissButton: .default(Text(Constants.okText))
                    )
                })
        }
    }
    
    func getTitleView() -> some View {
        TextField(
            Constants.titleText,
            text: $viewModel.title
        ).modifier(InterFont(.regular, size: 16))
            .accentColor(Color.text_primary_color)
            .frame(height: 50).padding(.leading, 16)
            .background(Color.secondary_color)
            .cornerRadius(8)
    }
    
    func getAmountView() -> some View {
        TextField(
            Constants.amountText,
            text: $viewModel.amount
        ).modifier(InterFont(.regular, size: 16))
            .accentColor(Color.text_primary_color)
            .frame(height: 50).padding(.leading, 16)
            .background(Color.secondary_color)
            .cornerRadius(4).keyboardType(.decimalPad)
    }
    
    func getTypeTitleView() -> some View {
        DropdownButton(
            shouldShowDropdown: $viewModel.showTypeDrop,
            displayText: $viewModel.typeTitle,
            options: viewModel.transactionTypeOptions,
            mainColor: Color.text_primary_color,
            backgroundColor: Color.secondary_color,
            cornerRadius: 8,
            buttonHeight: 50
        ) { key in
            let selectedObj = viewModel.transactionTypeOptions.filter({ $0.key == key }).first
            if let object = selectedObj {
                viewModel.typeTitle = object.val
                viewModel.selectedType = TransactionType(rawValue: key) ?? TransactionType.income //key
            }
            viewModel.showTypeDrop = false
        }
        
    }
    
    func getTagTitleView() -> some View {
        DropdownButton(
            shouldShowDropdown: $viewModel.showTagDrop,
            displayText: $viewModel.tagTitle,
            options: viewModel.categoryTagTypeOptions,
            mainColor: Color.text_primary_color,
            backgroundColor: Color.secondary_color,
            cornerRadius: 8,
            buttonHeight: 50
        ) { key in
            let selectedObj = viewModel.categoryTagTypeOptions.filter({ $0.key == key }).first
            if let object = selectedObj {
                viewModel.tagTitle = object.val
                viewModel.selectedTag = key
            }
            viewModel.showTagDrop = false
        }
    }
    
    func getDateView() -> some View {
        HStack {
            TextView(text: Constants.dateText, type: .body_1)
            Spacer()
            DatePicker("PickerView", selection: $viewModel.occuredOn,
                       displayedComponents: [.date]).labelsHidden().padding(.leading, 16)
        }
        .frame(height: 50).frame(maxWidth: .infinity)
        .accentColor(Color.text_primary_color)
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .background(Color.secondary_color)
        .cornerRadius(8)
        
    }
    
    func getNotesView() -> some View {
        TextField(Constants.noteText, text: $viewModel.note)
            .modifier(InterFont(.regular, size: 16))
            .accentColor(Color.text_primary_color)
            .frame(height: 50).padding(.leading, 16)
            .background(Color.secondary_color)
            .cornerRadius(8)
    }
    
    func getAttachImageView() -> some View {
        Button(
            action: {
                viewModel.attachImage()
            },
            label: {
                HStack {
                    Image(systemName: "paperclip")
                        .font(.system(size: 18.0, weight: .bold))
                        .foregroundColor(Color.text_secondary_color)
                        .padding(.leading, 16)
                    TextView(text: Constants.attachImageText, type: .button).foregroundColor(Color.text_secondary_color)
                    Spacer()
                }
            })
        .frame(height: 50).frame(maxWidth: .infinity)
        .background(Color.secondary_color)
        .cornerRadius(4)
        .actionSheet(isPresented: $showAttachSheet) {
            ActionSheet(
                title: Text(Constants.removeImageText),
                buttons: [
                    .default(
                        Text(Constants.removeText)
                    ) {
                        viewModel.removeImage()
                    },
                    .cancel()
                ])
        }
    }
    
    func getAttachedImageView(image: UIImage) -> some View {
        Button(
            action: {
                showAttachSheet = true
            },
            label: {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250).frame(maxWidth: .infinity)
                    .background(Color.secondary_color)
                    .cornerRadius(4)
            }
        )
    }
    
    func getBottomButtonView() -> some View {
        VStack {
            Spacer()
            VStack {
                Button {
                    viewModel.saveTransaction(managedObjectContext: managedObjectContext)
                } label: {
                    HStack {
                        Spacer()
                        TextView(text: viewModel.getBottomButtonText(), type: .button).foregroundColor(.white)
                        Spacer()
                    }
                }.padding(.vertical, 12).background(Color.main_color).cornerRadius(8)
            }.padding(.bottom, 32).padding(.horizontal, 16)
        }
    }
}

#Preview {
    AddExpenseView(viewModel: AddExpenseViewModel())
}
