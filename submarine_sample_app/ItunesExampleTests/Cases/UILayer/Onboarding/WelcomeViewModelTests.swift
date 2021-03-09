//
//  WelcomeViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import XCTest
@testable import ItunesExample

class WelcomeViewModelTests: XCTestCase {
    var sut: WelcomeViewModelImpl!
    var goToSignIn: GoToSignInNavigatorMock!
    var goToSignUp: GoToSignUpNavigatorMock!
    
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        goToSignIn = GoToSignInNavigatorMock()
        goToSignUp = GoToSignUpNavigatorMock()
        sut = WelcomeViewModelImpl(goToSignUpNavigator: goToSignUp, goToSignInNavigator: goToSignIn)
    }
    
    override func tearDownWithError() throws {
        goToSignIn = nil
        goToSignUp = nil
        sut = nil
    }

    //MARK: - Tests
    func testViewModel_whenShowSignInCalled_signInNavigatorMethodIsCalled() {
        sut.showSignInView()
        XCTAssertEqual(true, goToSignIn.navigateToSignInCalled)
    }
    
    func testViewModel_whenShowSignUpCalled_signUpNavigatorMethodIsCalled() {
        sut.showSignUpView()
        XCTAssertEqual(true, goToSignUp.navigateToSignUpCalled)
    }
}
