//
//  HomeViewModel.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation
import CoreData
import LocalAuthentication

class HomeViewModel: ObservableObject {
    
    @Published var isBiometricEnabled: Bool

    init() {
        self.isBiometricEnabled = UserDefaults.standard.bool(forKey: "isBiometricEnabled")
    }
    
    func handleBiometricToggle(_ isEnabled: Bool, completion: @escaping (Bool) -> Void) {
        if isEnabled {
            authenticate { success in
                if success {
                    UserDefaults.standard.set(true, forKey: "isBiometricEnabled")
                    self.isBiometricEnabled = true
                } else {
                    self.isBiometricEnabled = false
                }
                completion(success)
            }
        } else {
            UserDefaults.standard.set(false, forKey: "isBiometricEnabled")
            self.isBiometricEnabled = false
        }
    }

    func authenticateIfNeeded(completion: @escaping (Bool) -> Void) {
        if isBiometricEnabled {
            authenticate(completion: completion)
        } else {
            completion(true)
        }
    }

    private func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your account."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            // Biometrics not available
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }

    // Logout Action
    func logoutAction() {
        let context = AuthDemoApp.persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                context.delete(user)
            }
            try context.save()
            print("All users deleted successfully.")
        } catch {
            print("Failed to delete all users: \(error)")
        }
    }
}

