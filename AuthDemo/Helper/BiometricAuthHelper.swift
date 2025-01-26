//
//  BiometricAuthHelper.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation
import LocalAuthentication

class BiometricAuthHelper {
    
    static let shared = BiometricAuthHelper()
    
    // Check if biometric authentication is available
    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        // Check if Face ID or Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }
    
    // Attempt biometric authentication
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        let reason = "Authenticate with Face ID to access your account"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}
