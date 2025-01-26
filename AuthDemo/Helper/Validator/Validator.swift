//
//  Validator.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation

protocol Validator<ValueType> {
    associatedtype ValueType
    
    func isValid(value: ValueType) -> Bool
    func invalidMessage(value: ValueType) -> String
    func invalidMessage(fieldName: String, value: ValueType) -> String
}


extension Validator {
    func invalidMessage(fieldName: String, value: ValueType) -> String {
        return "\(fieldName)" + invalidMessage(value: value)
    }
}


struct EmptyFieldValidator: Validator {
    func isValid(value: String) -> Bool {
        return !value.isEmpty
    }
    
    func invalidMessage(value: String) -> String {
        return "is required"  // Simple message if the field is empty
    }
}
