//
//  MockNetworkManager.swift
//  AuthDemoTests
//
//  Created by Keyur Patel on 26/01/25.
//

import Foundation
@testable import AuthDemo

class MockNetworkManager: NetworkManagerProtocol {
    var shouldReturnSuccess: Bool = true

    func request<T, U>(url: AuthDemo.APIEndpoints, method: AuthDemo.HTTPMethod, requestBody: U?, headers: [String : String]?, responseType: T.Type) async throws -> T where T : Decodable, U : Encodable {
        if shouldReturnSuccess {
            switch url {
            case .signIn:
                let mockResponse = LoginResponse(type: "success", user: .init(fullName: "ALEX", email: "alexgmail.com"))
                return mockResponse as! T
                
            case .signUp:
                let mockResponse = SignupResponse(success: true, message: "User registered successfully!")
                return mockResponse as! T
            }
            
        } else {
            throw NSError(domain: "NetworkError", code: -1, userInfo: nil)
        }
    }

}
