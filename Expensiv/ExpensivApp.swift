//
//  ExpensivApp.swift
//  Expensiv
//
//  Created by Anusha NP on 7/9/2025.
//

import SwiftUI

@main
struct ExpensivApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        self.setDefaultPreferences()
    }
    
    private func setDefaultPreferences() {
        let currency = UserDefaults.standard.string(forKey: Constants.UD_EXPENSE_CURRENCY)
        if currency == nil {
            UserDefaults.standard.set("$", forKey: Constants.UD_EXPENSE_CURRENCY)
        }
    }

    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.bool(forKey: Constants.UD_USE_BIOMETRIC) {
                AuthenticationView(viewModel: AuthenticationViewModel())
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                ExpenseView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
