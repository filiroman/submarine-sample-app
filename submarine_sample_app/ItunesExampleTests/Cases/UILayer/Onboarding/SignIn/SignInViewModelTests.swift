//
//  SignInViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 22.12.2020.
//

import XCTest
@testable import ItunesExample

class SignInViewModelTests: XCTestCase {
    
    var sut: SignInViewModelImpl!
    var repository: UserSessionRepositoryMock!
    var signedInResponder: SignedInResponderMock!
    
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        repository = UserSessionRepositoryMock()
        signedInResponder = SignedInResponderMock()
        sut = SignInViewModelImpl(userSessionRepository: repository, signedInResponder: signedInResponder)
    }
    
    override func tearDownWithError() throws {
        repository = nil
        signedInResponder = nil
        sut = nil
    }
    
    //MARK: - Helpers
    func signInErrorExpectation() -> XCTestExpectation {
        let exp = expectation(description: "Error generated expectation")
        
        _ = sut.errorMessages.subscribe(onNext: { (_) in
            exp.fulfill()
        })
        
        return exp
    }
    
    //MARK: - When
    
    func whenCredentialsSet() {
        sut.emailInput.onNext("test")
        sut.passwordInput.onNext("test")
    }
    
    func whenReadUserSessionNotNil() {
        repository.userSession = UserSession.makeFakeSession()
    }
    
    func whenReadUserSessionError() {
        repository.readUserSessionError = NSError(domain: "Test error!", code: -1, userInfo: nil)
    }
    
    //MARK: - Tests
    func testViewModel_whenCredentialsSetAndUserSessionNotNil_signedInIsCalled() {
        whenCredentialsSet()
        whenReadUserSessionNotNil()
        
        let exp = expectation(forNotification: Notification.signedInNotification, object: nil)
        
        sut.signIn()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, signedInResponder.signedInCalled)
    }
    
    func testViewModel_whenSignInError_errorIsGenerated() {
        whenReadUserSessionError()
        
        let exp = signInErrorExpectation()
        
        sut.signIn()
        
        wait(for: [exp], timeout: 1)
    }
    
    func testViewModel_whenCredentialsSetToNil_returnsEmptyCredentials() {
        sut.emailInput.dispose()
        sut.passwordInput.dispose()
        
        let res = sut.getEmailPassword()
        
        XCTAssertEqual(res.0, "")
        XCTAssertEqual(res.1, "")
    }
    
    func testViewModel_whenIndicateSignIn_emailInputDisabled() throws {
        sut.indicateSigningIn()
        
        let inputEnabled = try XCTUnwrap(sut.emailInputEnabled.value())
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, false)
    }
    
    func testViewModel_whenIndicateSignIn_passwordInputDisabled() throws {
        sut.indicateSigningIn()
        
        let inputEnabled = try XCTUnwrap(sut.passwordInputEnabled.value())
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, false)
    }
    
    func testViewModel_whenIndicateSignIn_signInButtonDisabled() throws {
        sut.indicateSigningIn()
        
        let btnEnabled = try XCTUnwrap(sut.signInButtonEnabled.value())
        
        XCTAssertNotNil(btnEnabled)
        XCTAssertEqual(btnEnabled, false)
    }
    
    func testViewModel_whenIndicateSignIn_activityIndicatorAnimating() {
        sut.indicateSigningIn()
        
        let activityIndicatorAnimating = try? sut.signInActivityIndicatorAnimating.value()
        
        XCTAssertNotNil(activityIndicatorAnimating)
        XCTAssertEqual(activityIndicatorAnimating, true)
    }
    
    func testViewModel_whenSignInError_emailInputEnabled() {
        whenReadUserSessionError()
        
        let exp = signInErrorExpectation()
        
        sut.signIn()
        
        wait(for: [exp], timeout: 1)
        
        let inputEnabled = try? sut.emailInputEnabled.value()
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, true)
    }
    
    func testViewModel_whenSignInError_passwordInputEnabled() {
        whenReadUserSessionError()
        
        let exp = signInErrorExpectation()
        
        sut.signIn()
        
        wait(for: [exp], timeout: 1)
        
        let inputEnabled = try? sut.passwordInputEnabled.value()
        
        XCTAssertNotNil(inputEnabled)
        XCTAssertEqual(inputEnabled, true)
    }
    
    func testViewModel_whenSignInError_signInButtonEnabled() {
        whenReadUserSessionError()
        
        let exp = signInErrorExpectation()
        
        sut.signIn()
        
        wait(for: [exp], timeout: 1)
        
        let btnEnabled = try? sut.signInButtonEnabled.value()
        
        XCTAssertNotNil(btnEnabled)
        XCTAssertEqual(btnEnabled, true)
    }
    
    func testViewModel_whenSignInError_activityIndicatorNotAnimating() throws {
        whenReadUserSessionError()
        
        let exp = signInErrorExpectation()
        
        sut.signIn()
        
        wait(for: [exp], timeout: 1)
        
        let activityIndicatorAnimating = try XCTUnwrap(sut.signInActivityIndicatorAnimating.value())
        
        XCTAssertNotNil(activityIndicatorAnimating)
        XCTAssertEqual(activityIndicatorAnimating, false)
    }
}

