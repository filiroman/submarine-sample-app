//
//  SignUpViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 22.12.2020.
//

import XCTest
@testable import ItunesExample

class SignUpViewModelTests: XCTestCase {
    
    var sut: SignUpViewModelImpl!
    var repository: UserSessionRepositoryMock!
    var signedInResponder: SignedInResponderMock!
    
    override func setUpWithError() throws {
        repository = UserSessionRepositoryMock()
        signedInResponder = SignedInResponderMock()
        sut = SignUpViewModelImpl(userSessionRepository: repository, signedInResponder: signedInResponder)
    }
    
    override func tearDownWithError() throws {
        repository = nil
        signedInResponder = nil
        sut = nil
    }
    
    //MARK: - Helpers
    func signUpErrorExpectation() -> XCTestExpectation {
        let exp = expectation(description: "Error generated expectation")
        
        _ = sut.errorMessages.subscribe(onNext: { (_) in
            exp.fulfill()
        })
        
        return exp
    }
    //MARK: - When
    
    func whenCredentialsSet() {
        sut.nameInput.onNext("test")
        sut.emailInput.onNext("test")
        sut.passwordInput.onNext("test")
    }
    
    func whenReadUserSessionNotNil() {
        repository.userSession = UserSession.makeFakeSession()
    }
    
    func whenReadUserSessionError() {
        repository.readUserSessionError = NSError.testError
    }
    
    //MARK: - Tests
    func testViewModel_whenCredentialsSetAndUserSessionNotNil_signedInIsCalled() {
        whenCredentialsSet()
        whenReadUserSessionNotNil()
        
        let exp = expectation(forNotification: Notification.signedInNotification, object: nil)
        
        sut.signUp()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, signedInResponder.signedInCalled)
    }
    
    func testViewModel_whenSignUpError_errorIsGenerated() {
        whenReadUserSessionError()
        
        let exp = expectation(description: "Error generated expectation")
        var expectedError: ErrorMessage?
        
        _ = sut.errorMessages.subscribe(onNext: { (error) in
            expectedError = error
            exp.fulfill()
        })
        
        sut.signUp()
        
        wait(for: [exp], timeout: 1)
        XCTAssertNotNil(expectedError)
    }
    
    func testViewModel_whenCredentialsSetToNil_returnsEmptyCredentials() {
        sut.emailInput.dispose()
        sut.passwordInput.dispose()
        sut.nameInput.dispose()
        
        let res = sut.getFieldValues()
        
        XCTAssertEqual(res.0, "")
        XCTAssertEqual(res.1, "")
        XCTAssertEqual(res.2, "")
    }
    
    func testViewModel_whenIndicateSignUp_emailInputDisabled() throws {
        sut.indicateSigningUp()
        
        let inputEnabled = try XCTUnwrap(sut.emailInputEnabled.value())
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, false)
    }
    
    func testViewModel_whenIndicateSignUp_passwordInputDisabled() throws {
        sut.indicateSigningUp()
        
        let inputEnabled = try XCTUnwrap(sut.passwordInputEnabled.value())
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, false)
    }
    
    func testViewModel_whenIndicateSignUp_signInButtonDisabled() throws {
        sut.indicateSigningUp()
        
        let btnEnabled = try XCTUnwrap(sut.signUpButtonEnabled.value())
        
        XCTAssertNotNil(btnEnabled)
        XCTAssertEqual(btnEnabled, false)
    }
    
    func testViewModel_whenIndicateSignUp_activityIndicatorAnimating() {
        sut.indicateSigningUp()
        
        let activityIndicatorAnimating = try? sut.signUpActivityIndicatorAnimating.value()
        
        XCTAssertNotNil(activityIndicatorAnimating)
        XCTAssertEqual(activityIndicatorAnimating, true)
    }
    
    func testViewModel_whenSignUpError_emailInputEnabled() {
        whenReadUserSessionError()
        
        let exp = signUpErrorExpectation()
        
        sut.signUp()
        
        wait(for: [exp], timeout: 1)
        
        let inputEnabled = try? sut.emailInputEnabled.value()
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, true)
    }
    
    func testViewModel_whenSignUpError_passwordInputEnabled() {
        whenReadUserSessionError()
        
        let exp = signUpErrorExpectation()
        
        sut.signUp()
        
        wait(for: [exp], timeout: 1)
        
        let inputEnabled = try? sut.passwordInputEnabled.value()
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, true)
    }
    
    func testViewModel_whenSignUpError_signInButtonEnabled() {
        whenReadUserSessionError()
        
        let exp = signUpErrorExpectation()
        
        sut.signUp()
        
        wait(for: [exp], timeout: 1)
        
        let btnEnabled = try? sut.signUpButtonEnabled.value()
        
        XCTAssertNotNil(btnEnabled)
        XCTAssertEqual(btnEnabled, true)
    }
    
    func testViewModel_whenSignUpError_activityIndicatorNotAnimating() throws {
        whenReadUserSessionError()
        
        let exp = signUpErrorExpectation()
        
        sut.signUp()
        
        wait(for: [exp], timeout: 1)
        
        let activityIndicatorAnimating = try XCTUnwrap(sut.signUpActivityIndicatorAnimating.value())
        
        XCTAssertNotNil(activityIndicatorAnimating)
        XCTAssertEqual(activityIndicatorAnimating, false)
    }
}
