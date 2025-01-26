//
//  RequestModel.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation

struct SignupResponse: Codable {
    let success: Bool
    let message: String
}

// Signin API Response Model
struct LoginResponse: Codable {
    let type: String
    let user: UserResponse
}

struct UserResponse: Codable {
    let fullName: String
    let email: String
}

struct LoginReqestModel: Codable {
    let email: String
    let password: String
}

struct SignupReqestModel: Codable {
    let fullName: String
    let email: String
    let password: String
    let dateOfBirth: String
    let gender: String
}

