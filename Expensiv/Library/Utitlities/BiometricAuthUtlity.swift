//
//  BiometricAuthUtlity.swift
//  Expensiv
//
//  Created by Anusha NP on 8/9/2025.
//

import Foundation
import LocalAuthentication
import Combine

struct BiometericAuthError: LocalizedError {
    
    var description: String
    
    init(description: String){
        self.description = description
    }
    
    init(error: Error){
        self.description = error.localizedDescription
    }
    
    var errorDescription: String?{
        return description
    }
}

class BiometricAuthUtlity {
    
    
    static let shared = BiometricAuthUtlity()

    private init(){}
    
    /// Authenticate the user with device Authentication system.
    /// If the .deviceOwnerAuthenticationWithBiometrics is not available, it will fallback to .deviceOwnerAuthentication
    /// - Returns: future which passes `Bool` when the authentication suceeds or `BiometericAuthError` when failed to authenticate
    public func authenticate() -> Future<Bool, BiometericAuthError> {
        //promise is how the result (success or failure) is sent back to the caller.
        Future { promise in
            
            func handleReply(success: Bool, error: Error?) -> Void {
                if let error = error {
                    return promise(
                        .failure(BiometericAuthError(error: error))
                    )
                }
                
                promise(.success(success))
            }
            
            let context = LAContext()  //Apple’s class for handling local (device-level) authentication.
            var error: NSError?
            let reason = "Please authenticate yourself to unlock \(Constants.AppName)"
            
            /// Checks if biometric auth (Face ID / Touch ID) is available. If yes, it evaluates that policy
            /// If biometric isn't available, it falls back to device passcode authentication.
            /// If neither biometric nor passcode authentication is possible, it fails the authentication with a generic error.
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: handleReply)
            } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: handleReply)
            } else {
                let error = BiometericAuthError(description: "Something went wrong while authenticating. Please try again")
                promise(.failure(error))
            }
        }
    }


}

