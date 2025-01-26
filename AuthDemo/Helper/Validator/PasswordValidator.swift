//
//  PasswordValidator.swift
//  AuthDemo
//
//  Created by Keyur Patel on 26/01/25.
//

import Foundation

struct PasswordValidator: Validator {
    func isValid(value: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/`~]).{6,}$"
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return regexPredicate.evaluate(with: value)
    }
    
    func invalidMessage(value: String) -> String {
        if value.count < 6 {
            return "Password must be at least 6 characters long"
        } else if !value.contains(where: { $0.isUppercase }) {
            return "Password must contain at least one uppercase letter"
        } else if !value.contains(where: { $0.isNumber }) {
            return "Password must contain at least one number"
        } else if !value.contains(where: { "!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/`~".contains($0) }) {
            return "Password must contain at least one special character"
        }
        return ""
    }
    
    func invalidMessage(fieldName: String, value: String) -> String {
        return "\(fieldName) " + invalidMessage(value: value)
    }
}

extension String {
    var isValidPassword: Bool {
        let passwordValidator = PasswordValidator()
        return passwordValidator.isValid(value: self)
    }
}
