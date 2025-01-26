//
//  EndPoints.swift
//  AuthDemo
//
//  Created by Keyur Patel on 25/01/25.
//

import Foundation

enum APIEndpoints: String {
    static let baseURL = "https://authdemo.free.beeceptor.com"
    
    case signIn = "/signin"
    case signUp = "/signup"

    var urlString: String {
        return APIEndpoints.baseURL + self.rawValue
    }
}
