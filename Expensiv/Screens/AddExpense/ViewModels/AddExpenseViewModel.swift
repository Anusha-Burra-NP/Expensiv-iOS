//
//  AddExpenseViewModel.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import CoreData
import UIKit

class AddExpenseViewModel: ObservableObject {
    
    var expenseObj: ExpensivCD?
    var transactionTypeOptions: [DropdownOption] = []
    var categoryTagTypeOptions: [DropdownOption] = []
    
    @Published var title = ""
    @Published var amount = ""
    @Published var occuredOn = Date()
    @Published var note = ""
    @Published var typeTitle = Constants.incomeText
    @Published var tagTitle = ExpenseCategoryTagType.transport.getTagTitle()
    @Published var showTypeDrop = false
    @Published var showTagDrop = false
    
    @Published var selectedType = TransactionType.income
    @Published var selectedTag = ExpenseCategoryTagType.transport.rawValue
    
    @Published var imageUpdated = false // When transaction edit, check if attachment is updated?
    @Published var imageAttached: UIImage? = nil
    
    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var closePresenter = false
    
    init(expenseObj: ExpensivCD? = nil) {
        
        self.transactionTypeOptions = self.getTransactionTypes()
        self.categoryTagTypeOptions = self.getCategoryTagTypes()
        self.expenseObj = expenseObj
        self.title = expenseObj?.title ?? ""
        
        if let expenseObj = expenseObj {
            self.amount = String(expenseObj.amount)
            self.typeTitle = expenseObj.type == TransactionType.income.rawValue ? Constants.incomeText : Constants.expenseText
        } else {
            self.amount = ""
            self.typeTitle = Constants.incomeText
        }
        
        self.occuredOn = expenseObj?.occuredOn ?? Date()
        self.note = expenseObj?.note ?? ""
        
        if let tag = expenseObj?.tag, let selectedTag = ExpenseCategoryTagType(rawValue: tag) {
            self.tagTitle = selectedTag.getTagTitle()
        } else {
            self.tagTitle = ExpenseCategoryTagType.transport.getTagTitle()
        }
        
        if let type = expenseObj?.type, let transactionType = TransactionType(rawValue: type) {
            self.selectedType = transactionType
        } else {
            self.selectedType = TransactionType.income
        }
        self.selectedTag = expenseObj?.tag ?? ExpenseCategoryTagType.transport.rawValue
        
        if let data = expenseObj?.imageAttached {
            self.imageAttached = UIImage(data: data)
        }
        
        AttachmentHandler.shared.imagePickedBlock = { [weak self] image in
            self?.imageUpdated = true
            self?.imageAttached = image
        }
    }
    
    private func getTransactionTypes() -> [DropdownOption] {
        var transactionTypes: [DropdownOption] = []
        for type in TransactionType.allCases {
            transactionTypes.append(DropdownOption(key: type.rawValue, val: type.getTitle())) 
        }
        return transactionTypes
    }
    
    private func getCategoryTagTypes() -> [DropdownOption] {
        var tagTypes: [DropdownOption] = []
        for tagType in ExpenseCategoryTagType.allCases {
            tagTypes.append(DropdownOption(key: tagType.rawValue, val: tagType.getTagTitle()))
        }
        return tagTypes
    }
    
    func getBottomButtonText() -> String {
        if selectedType == TransactionType.income {
            return "\(expenseObj == nil ? "\(Constants.addText)" : "\(Constants.editText)") \(Constants.incomeText.uppercased())"
        } else if selectedType == TransactionType.expense {
            return "\(expenseObj == nil ? "\(Constants.addText)" : "\(Constants.editText)") \(Constants.expenseText.uppercased())"
        } else {
            return "\(expenseObj == nil ? "\(Constants.addText)" : "\(Constants.editText)") \(Constants.transactionText)"
        }
    }
    
    func attachImage() {
        AttachmentHandler.shared.showAttachmentActionSheet()
    }
    
    func removeImage() {
        imageAttached = nil
    }
    
    func saveTransaction(managedObjectContext: NSManagedObjectContext) {
        let expense: ExpensivCD
        let titleStr = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let amountStr = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //TODO: Handle Alerts
        if titleStr.isEmpty || titleStr == "" {
            alertMsg = "Enter Title"
            showAlert = true
            return
        }
        
        if amountStr.isEmpty || amountStr == "" {
            alertMsg = "Enter Amount"
            showAlert = true
            return
        }
        
        guard let amount = Double(amountStr) else {
            alertMsg = "Enter valid number"
            showAlert = true
            return
        }
        
        guard amount >= 0 else {
            alertMsg = "Amount can't be negative"
            showAlert = true
            return
        }
        
        guard amount <= 1000000000 else {
            alertMsg = "Enter a smaller amount"
            showAlert = true
            return
        }
        
        if expenseObj != nil {
            expense = expenseObj!
            if let image = imageAttached {
                if imageUpdated {
                    if let _ = expense.imageAttached {
                        //TODO: Delete Previous Image from CoreData
                    }
                    expense.imageAttached = image.jpegData(compressionQuality: 1.0)
                }
            } else {
                if let _ = expense.imageAttached {
                    //TODO: Delete Previous Image from CoreData
                }
                expense.imageAttached = nil
            }
        } else {
            expense = ExpensivCD(context: managedObjectContext)
            expense.createdAt = Date()
            if let image = imageAttached {
                expense.imageAttached = image.jpegData(compressionQuality: 1.0)
            }
        }
        expense.updatedAt = Date()
        expense.type = selectedType.rawValue
        expense.title = titleStr
        expense.tag = selectedTag
        expense.occuredOn = occuredOn
        expense.note = note
        expense.amount = amount
        do {
            try managedObjectContext.save()
            closePresenter = true
        } catch {
            alertMsg = "\(error)"
            showAlert = true
        }
    }
    
    func deleteTransaction(managedObjectContext: NSManagedObjectContext) {
        guard let expenseObj = expenseObj else { return }
        managedObjectContext.delete(expenseObj)
        do {
            try managedObjectContext.save()
            closePresenter = true
        } catch {
            alertMsg = "\(error)"
            showAlert = true
        }
    }
}
