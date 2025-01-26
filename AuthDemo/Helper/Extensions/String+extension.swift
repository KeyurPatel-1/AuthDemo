//
//  String+extension.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }   
}
