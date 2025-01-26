//
//  NavigationState.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation
import SwiftUI
import LocalAuthentication

class NavigationState: ObservableObject {
    @Published var authState: AuthState = .notAuthenticated
    @AppStorage("isBiometricsEnabled") private var isBiometricsEnabled: Bool = false

    init() {
        if let _ = KeychainHelper.shared.retrieveFromKeychain(key: .isUserLoggedIn) {
            self.authState = .authenticated
        } else {
            self.authState = .notAuthenticated
        }
    }
    
    enum AuthState {
        case authenticated
        case notAuthenticated
    }

    func goToHomeScreen() {
        KeychainHelper.shared.saveToKeychain(key: .isUserLoggedIn, value: "true")
        authState = .authenticated
    }
    
    
    func logOutUser() {
        KeychainHelper.shared.deleteFromKeychain(key: .isUserLoggedIn)
        authState = .notAuthenticated
    }
    
    func toggleBiometricsSetting() {
        isBiometricsEnabled.toggle()
    }
    
    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }
    
}
