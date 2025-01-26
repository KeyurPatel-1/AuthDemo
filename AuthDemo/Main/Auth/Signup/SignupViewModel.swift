//
//  SignupViewModel.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation

class SignupViewModel: ObservableObject {
    
    @Published var txtFullName: String
    @Published var txtEmail: String
    @Published var txtPassword: String
    @Published var txtConfirmPassword: String
    @Published var txtGender: String
    @Published var isShowPasswordText: Bool
    @Published var isShowConfirmPasswordText: Bool
    @Published var emailError: String
    @Published var passwordError: String
    @Published var confirmPasswordError: String
    @Published var isLoading: Bool
    @Published var selectedDateOfBirth: Date
    
    var dateOfBirthText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: selectedDateOfBirth)
    }
    
    var isValidField: Bool {
        if self.txtEmail.trim().isEmpty {
            return false
        } else if !self.txtEmail.isValidEmail {
            return false
        } else if self.txtPassword.isEmpty {
            return false
        } else if !self.txtPassword.isValidPassword {
            return false
        } else if self.txtConfirmPassword.isEmpty {
            return false
        } else if self.txtPassword != self.txtConfirmPassword {
            return false
        } else if self.txtGender.isEmpty {
            return false
        }
        
        return true
    }
    
    init() {
        self.txtFullName = ""
        self.txtEmail = ""
        self.txtPassword = ""
        self.txtConfirmPassword = ""
        self.txtGender = ""
        self.isShowPasswordText = false
        self.isShowConfirmPasswordText = false
        self.emailError = ""
        self.passwordError = ""
        self.confirmPasswordError = ""
        self.isLoading = false
        self.selectedDateOfBirth = Date()
    }
    
    func togglePasswordText() {
        self.isShowPasswordText.toggle()
    }
    
    func toggleConfirmPasswordText() {
        self.isShowConfirmPasswordText.toggle()
    }
    
    func validate() -> Bool {
        if self.txtEmail.isEmpty {
            return false
        } else if self.txtPassword.isEmpty {
            return false
        }
        return true
    }
    
    func signupButtonAction() async -> Bool {
        
        guard validate() else { return false }
        
        let requestModel = SignupReqestModel(
            fullName: self.txtFullName,
            email: self.txtEmail,
            password: self.txtPassword,
            dateOfBirth: self.dateOfBirthText,
            gender: self.txtGender
        )
        do {
            let response: SignupResponse = try await NetworkManager.shared.request(
                url: .signUp,
                method: .POST,
                requestBody: requestModel,
                headers: nil,
                responseType: SignupResponse.self
            )
            DispatchQueue.main.async {
                self.isLoading = false
            }
            if response.success {
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
        user.fullName = self.txtFullName
        user.email = self.txtEmail
        user.dob = self.dateOfBirthText
        user.gender = self.txtGender
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}
