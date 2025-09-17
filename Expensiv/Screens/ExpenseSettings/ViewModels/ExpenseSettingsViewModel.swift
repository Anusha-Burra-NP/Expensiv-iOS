//
//  ExpenseSettingsView.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import Foundation
import Combine
import LocalAuthentication
import CoreData
import UIKit

class ExpenseSettingsViewModel: ObservableObject {
    var csvModelArr = [ExpenseCSVModel]()
    var cancellableBiometricTask: AnyCancellable? = nil
    
    @Published var currency = UserDefaults.standard.string(forKey: Constants.UD_EXPENSE_CURRENCY) ?? ""
    @Published var alertMsg = String()
    @Published var showAlert = false
    @Published var enableBiometric = UserDefaults.standard.bool(forKey: Constants.UD_USE_BIOMETRIC) {
        didSet {
            if enableBiometric { authenticate() }
            else { UserDefaults.standard.setValue(false, forKey: Constants.UD_USE_BIOMETRIC) }
        }
    }
    
    func authenticate() {
        showAlert = false
        alertMsg = ""
        cancellableBiometricTask = BiometricAuthUtlity.shared.authenticate()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.showAlert = true
                    self.alertMsg = error.description
                    self.enableBiometric = false
                default: return
                }
            }) { _ in
                UserDefaults.standard.setValue(true, forKey: Constants.UD_USE_BIOMETRIC)
            }
    }
    
    func getBiometricType() -> String {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                switch context.biometryType {
                    case .faceID: return "Face ID"
                    case .touchID: return "Touch ID"
                    case .none: return "App Lock"
                    default: return "App Lock"
                }
            }
        }
        return "App Lock"
    }
    
    func saveCurrency(currency: String) {
        self.currency = currency
        UserDefaults.standard.set(currency, forKey: Constants.UD_EXPENSE_CURRENCY)
    }
    
    func exportTransactions(moc: NSManagedObjectContext) {
        let request = ExpensivCD.fetchRequest()
        var results: [ExpensivCD]
        do {
            results = try moc.fetch(request) 
            if results.count <= 0 { alertMsg = "No data to export"; showAlert = true }
            else {
                for i in results {
                    let csvModel = ExpenseCSVModel()
                    csvModel.title = i.title ?? ""
                    csvModel.amount = "\(currency)\(i.amount)"
                    csvModel.transactionType = "\(i.type == TransactionType.income.rawValue ? Constants.incomeText : Constants.expenseText)"
                    csvModel.tag = ExpenseCategoryTagType(rawValue: i.tag ?? "")?.getTagTitle() ?? ""
                    csvModel.occuredOn = "\(Helpers.getDateFormatter(date: i.occuredOn, format: "yyyy-mm-dd hh:mm a"))"
                    csvModel.note = i.note ?? ""
                    csvModelArr.append(csvModel)
                }
                self.generateCSV()
            }
        } catch { alertMsg = "\(error)"; showAlert = true }
    }
    
    func generateCSV() {
        let fileName = "Expense.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Title,Amount,Type,Tag,Occured On,Note\n"
        
        for csvModel in csvModelArr {
            let row = "\"\(csvModel.title)\",\"\(csvModel.amount)\",\"\(csvModel.transactionType)\",\"\(csvModel.tag)\",\"\(csvModel.occuredOn)\",\"\(csvModel.note)\"\n"
            csvText.append(row)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let av = UIActivityViewController(activityItems: [path!], applicationActivities: nil)
            if let scene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let window = scene.windows.first(where: { $0.isKeyWindow }),
               let rootVC = window.rootViewController {
                
                rootVC.present(av, animated: true, completion: nil)
            }
        } catch {
            alertMsg = "\(error)"
            showAlert = true
        }
        
        print(path ?? "not found")
    }
    
    deinit {
        cancellableBiometricTask = nil
    }
}
