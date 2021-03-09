//
//  OnboardingViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import XCTest
@testable import ItunesExample

class OnboardingViewModelTests: XCTestCase {
    var sut: OnboardingViewModel!
        
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        sut = OnboardingViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    //MARK: - Tests
    func testViewModel_whenInitialized_viewInPresentWelcomeState() {
        let exp = XCTestExpectation(description: "observable element returned")
        var retAction: OnboardingNavigationAction?
        let sub = sut.view.subscribe(onNext: { (action) in
            retAction = action
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        sub.dispose()

        XCTAssertEqual(retAction, .present(view: .welcome))
    }
    
    func testViewModel_whenGoToSignInCalled_viewInPresentSignInState() {
        let exp = XCTestExpectation(description: "observable element returned")
        exp.expectedFulfillmentCount = 2
        var retAction: OnboardingNavigationAction?
        let sub = sut.view.subscribe(onNext: { (action) in
            retAction = action
            exp.fulfill()
        })
        
        sut.navigateToSignIn()
        wait(for: [exp], timeout: 1)
        sub.dispose()
        
        XCTAssertEqual(retAction, .present(view: .signin))
    }
    
    func testViewModel_whenGoToSignUpCalled_viewInPresentSignUpState() {
        let exp = XCTestExpectation(description: "observable element returned")
        exp.expectedFulfillmentCount = 2
        var retAction: OnboardingNavigationAction?
        let sub = sut.view.subscribe(onNext: { (action) in
            retAction = action
            exp.fulfill()
        })
        
        sut.navigateToSignUp()
        wait(for: [exp], timeout: 1)
        sub.dispose()
        
        XCTAssertEqual(retAction, .present(view: .signup))
    }
}
