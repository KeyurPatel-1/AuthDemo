//
//  SignupTest.swift
//  AuthDemo
//
//  Created by Keyur Patel on 26/01/25.
//

import XCTest
@testable import AuthDemo

class SignupTest: XCTestCase {
    
    var viewModel: SignupViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SignupViewModel()
        let mockNetworkManager = MockNetworkManager()
        NetworkManager.shared = mockNetworkManager
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testValidFields() {
        viewModel.txtFullName = "John Doe"
        viewModel.txtEmail = "test@example.com"
        viewModel.txtPassword = "Password123"
        viewModel.txtConfirmPassword = "Password123"
        viewModel.txtGender = "Male"
        
        XCTAssertTrue(viewModel.isValidField, "Valid fields should return true.")
    }
    
    func testInvalidEmail() {
        viewModel.txtFullName = "John Doe"
        viewModel.txtEmail = "invalidEmail"
        viewModel.txtPassword = "Password123"
        viewModel.txtConfirmPassword = "Password123"
        viewModel.txtGender = "Male"
        
        XCTAssertFalse(viewModel.isValidField, "Invalid email should return false.")
    }
    
    func testMismatchedPasswords() {
        viewModel.txtFullName = "John Doe"
        viewModel.txtEmail = "test@example.com"
        viewModel.txtPassword = "Password123"
        viewModel.txtConfirmPassword = "DifferentPassword123"
        viewModel.txtGender = "Male"
        
        XCTAssertFalse(viewModel.isValidField, "Mismatched passwords should return false.")
    }
    
    func testEmptyFields() {
        viewModel.txtFullName = ""
        viewModel.txtEmail = ""
        viewModel.txtPassword = ""
        viewModel.txtConfirmPassword = ""
        viewModel.txtGender = ""
        
        XCTAssertFalse(viewModel.isValidField, "Empty fields should return false.")
    }
    
    // MARK: - Signup Action Tests
    
    func testSignupSuccess() async {
        // Arrange
        viewModel.txtFullName = "John Doe"
        viewModel.txtEmail = "test@example.com"
        viewModel.txtPassword = "Password123"
        viewModel.txtConfirmPassword = "Password123"
        viewModel.txtGender = "Male"
        viewModel.isLoading = true
        
        (NetworkManager.shared as? MockNetworkManager)?.shouldReturnSuccess = true
        
        // Act
        let result = await viewModel.signupButtonAction()
        
        // Assert
        XCTAssertTrue(result, "Signup should succeed with valid input.")
        XCTAssertFalse(viewModel.isLoading, "isLoading should be false after the signup process.")
    }
}
