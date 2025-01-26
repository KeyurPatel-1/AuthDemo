//
//  LoginViewModel.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation
import CoreData

class LoginViewModel: ObservableObject {
    
    @Published var txtEmail: String
    @Published var txtPassword: String
    @Published var isShowPasswordText: Bool
    @Published var emailError: String
    
    @Published var isLoading: Bool
    
    var isValidField: Bool {
        if self.txtEmail.trim().isEmpty {
            return false
        } else if !self.txtEmail.isValidEmail {
            return false
        } else if self.txtPassword.isEmpty {
            return false
        }
        return true
    }
    
    
    init() {
        self.txtEmail = ""
        self.txtPassword = ""
        self.isShowPasswordText = false
        self.emailError = ""
        self.isLoading = false
    }
    
    func togglePasswordText() {
        self.isShowPasswordText.toggle()
    }
    
    func loginButtonAction() async -> Bool {
        
        let requestModel = LoginReqestModel(email: self.txtEmail, password: self.txtPassword)
        do {
            let response: LoginResponse = try await NetworkManager.shared.request(
                url: .signIn,
                method: .POST,
                requestBody: requestModel,
                headers: nil,
                responseType: LoginResponse.self
            )
            DispatchQueue.main.async {
                self.isLoading = false
            }
            if response.type == "success" {
                self.saveUserIntoDataBase()
                return true
            }
            return false
        } catch {
            print("error")
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return false
        }
       
    }
    
    func saveUserIntoDataBase() {
        let context = AuthDemoApp.persistenceController.container.viewContext
        let user = User(context: context)
        user.fullName = "Alex \(Int.random(in: 0...10))"
        user.email = self.txtEmail
        user.dob = "01/01/1998"
        user.gender = "Male"
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}
