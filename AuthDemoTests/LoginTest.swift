//
//  Login.swift
//  AuthDemoTests
//
//  Created by Keyur Patel on 25/01/25.
//

import XCTest
@testable import AuthDemo

class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        let mockNetworkManager = MockNetworkManager()
        NetworkManager.shared = mockNetworkManager
        
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testValidEmailAndPassword() {
        viewModel.txtEmail = "test@example.com"
        viewModel.txtPassword = "Password123"
        XCTAssertTrue(viewModel.isValidField, "Valid email and password should return true.")
    }

    func testEmptyEmail() {
        viewModel.txtEmail = ""
        viewModel.txtPassword = "Password123"
        XCTAssertFalse(viewModel.isValidField, "Empty email should return false.")
    }

    func testInvalidEmail() {
        viewModel.txtEmail = "invalidEmail"
        viewModel.txtPassword = "Password123"
        XCTAssertFalse(viewModel.isValidField, "Invalid email should return false.")
    }

    func testEmptyPassword() {
        viewModel.txtEmail = "test@example.com"
        viewModel.txtPassword = ""
        XCTAssertFalse(viewModel.isValidField, "Empty password should return false.")
    }
    
    func testLoginSuccess() async {
        // Arrange
        viewModel.txtEmail = "test@example.com"
        viewModel.txtPassword = "Password123"
        viewModel.isLoading = true
        
        (NetworkManager.shared as? MockNetworkManager)? .shouldReturnSuccess = true
        
        // Act
        let result = await viewModel.loginButtonAction()
        
        // Assert
        XCTAssertTrue(result, "Login should succeed for valid credentials.")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after the login process.")
    }
    
}

