//
//  WelcomeRootViewTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 06.03.2021.
//

import XCTest
@testable import ItunesExample

class WelcomeRootViewTests: XCTestCase {
    // MARK: - Properties
    var sut: WelcomeRootView!
    var vm: WelcomeViewModelMock!
    // MARK: - Tests Lifecycle
    override func setUpWithError() throws {
        vm = WelcomeViewModelMock()
        sut = WelcomeRootView(viewModel: vm)
    }

    override func tearDownWithError() throws {
        vm = nil
        sut = nil
    }

    // MARK: - Tests
    func testView_initialized_hasBackgroundColorSet() {
        XCTAssertEqual(sut.backgroundColor, AppColors.background)
    }
    
    func testView_initialized_hasCorrectAppLabel() {
        XCTAssertEqual(sut.appNameLabel.text, "SUBMARINE".localized)
    }
    
    func testView_initialized_hasCorrectSignUpButtonTitle() {
        XCTAssertEqual(sut.signUpButton.title(for: .normal), "Sign Up".localized)
    }
    
    func testView_initialized_hasCorrectSignInButtonTitle() {
        XCTAssertEqual(sut.signInButton.title(for: .normal), "Sign In".localized)
    }
    
    func testView_didMoveToSuperview_setupsButtonBindings() {
        sut.didMoveToSuperview()
        
        sut.signUpButton.sendActions(for: .touchUpInside)
        sut.signInButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(vm.showSignInCalled, true)
        XCTAssertEqual(vm.showSignUpCalled, true)
    }
}
