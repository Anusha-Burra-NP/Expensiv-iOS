//
//  ExpenseDetailedViewModel.swift
//  Expensiv
//
//  Created by Anusha NP on 9/9/2025.
//

import CoreData

class ExpenseDetailedViewModel: ObservableObject {
    @Published var expenseObj: ExpensivCD
    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var closePresenter = false
    
    init(expenseObj: ExpensivCD) {
        self.expenseObj = expenseObj
    }
    
    func deleteExepnseObj(managedObjectContext: NSManagedObjectContext) {
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
