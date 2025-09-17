//
//  AuthenticationViewModel.swift
//  Expensiv
//
//  Created by Anusha NP on 12/9/2025.
//

import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    
    var cancellableBiometricTask: AnyCancellable? = nil
    @Published var didAuthenticate = false
    var showAlert = false
    var alertMessage = String()
    
    func authenticate(){
        didAuthenticate = false
        showAlert = false
        alertMessage = ""
        cancellableBiometricTask = BiometricAuthUtlity.shared.authenticate()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.showAlert = true
                    self.alertMessage = error.description
                default: return
                }
            }) { _ in
                self.didAuthenticate = true
            }
    }
    
    deinit {
        cancellableBiometricTask = nil
    }
}
