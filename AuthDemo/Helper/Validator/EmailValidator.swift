//
//  EmailValidator.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation

struct EmailAddressValidator: Validator {
    func isValid(value: String) -> Bool {
        let regex = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)(\\.[A-Za-z]{2,})*$"
        let regexPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexPredicate.evaluate(with: value)
    }
    
    func invalidMessage(value: String) -> String {
        if value.isEmpty {
            return "Please enter a email"
        } else if self.isValid(value: value) {
            return "Please enter a valid email"
        }
        return ""
    }
}

extension String {
    var isValidEmail: Bool {
        let emailValidator = EmailAddressValidator()
        return emailValidator.isValid(value: self)
    }
}
