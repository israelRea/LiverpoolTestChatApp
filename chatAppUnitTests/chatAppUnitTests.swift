//
//  chatAppUnitTests.swift
//  chatAppUnitTests
//
//  Created by Praxis on 14/10/24.
//

import XCTest
@testable import chatApp

class chatAppUnitTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var loginUserUseCase: LoginUserUseCase!

    override func setUp() {
        super.setUp()
        loginUserUseCase = LoginUserUseCase(authRepository: AuthRepository())
        viewModel = LoginViewModel(loginUserUseCase: loginUserUseCase)
    }

    func testLoginSuccess() {
        let expectation = self.expectation(description: "Login should succeed")
        
        viewModel.onLoginSuccess = { [weak self] uid in
            expectation.fulfill()
        }

        viewModel.onLoginError = { error in
            XCTFail("Login should not fail")
        }

        viewModel.login(email: "ing.israelrea@gmail.com", password: "MyTest.2024")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLoginFailure() {
        let expectation = self.expectation(description: "Login should fail")

        viewModel.onLoginSuccess = { [weak self] uid in
            XCTFail("Login should not succeed")
        }

        viewModel.onLoginError = { error in
            XCTAssertEqual(error.localizedDescription, "Invalid credentials")
            expectation.fulfill()
        }

        viewModel.login(email: "test@example.com", password: "wrongpassword")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testLoginEmptyFields() {
        let expectation = self.expectation(description: "Login should fail due to empty fields")

        viewModel.onLoginSuccess =  { [weak self] uid in
            XCTFail("Login should not succeed")
        }

        viewModel.onLoginError = { errorMessage in
            XCTAssertEqual(errorMessage.localizedDescription, "Email and password cannot be empty")
            expectation.fulfill()
        }

        viewModel.login(email: "", password: "")
        waitForExpectations(timeout: 1, handler: nil)
    }
}
