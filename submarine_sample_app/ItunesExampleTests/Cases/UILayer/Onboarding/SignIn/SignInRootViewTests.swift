//
//  SignInRootViewTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 04.03.2021.
//

import XCTest
import RxSwift
@testable import ItunesExample

class SignInRootViewTests: XCTestCase {
    // MARK: - Properties
    var sut: SignInRootView!
    var viewModel: SignInViewModelMock!
    
    var disposeBag: DisposeBag!
    
    // MARK: - Tests Lifecycle
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        viewModel = SignInViewModelMock()
        sut = SignInRootView()
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        viewModel = nil
        sut = nil
    }
    
    // MARK: - Given
    func givenInitializedView() {
        sut.didMoveToSuperview()
        sut.setupBindings(viewModel: viewModel)
    }
    
    // MARK: - Tests
    func testView_initialized_hasEmailIconSet() {
        XCTAssertNotNil(sut.emailIcon.image)
    }

    func testView_initialized_hasPasswordIconSet() {
        XCTAssertNotNil(sut.passwordIcon.image)
    }
    
    func testView_initialized_hasSignInButtonTitle() {
        XCTAssertEqual(sut.signInButton.title(for: .normal), "Sign In".localized)
    }
    
    func testView_initialized_hasAppBackgroundSet() {
        XCTAssertEqual(sut.backgroundColor, AppColors.background)
    }
    
    func testView_didMoveToSuperview_callsViewModelSignInOnButtonTap() {
        givenInitializedView()
        sut.signInButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(viewModel.signInCalled, true)
    }
    
    func testView_didMoveToSuperview_activityIndicatorIsNotAnimating() {
        givenInitializedView()
        
        XCTAssertEqual(sut.signInActivityIndicator.isAnimating, false)
    }
    
    func testView_subscribesToActivityIndicatorSequence() {
        givenInitializedView()
        XCTAssertEqual(sut.signInActivityIndicator.isAnimating, false)
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.signInActivityIndicatorAnimating.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.signInActivityIndicatorAnimating.onNext(true)
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.signInActivityIndicator.isAnimating, true)
    }
    
    func testView_subscribesToSignInEnabledState() {
        givenInitializedView()
        XCTAssertEqual(sut.signInButton.isEnabled, true)
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.signInButtonEnabled.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.signInButtonEnabled.onNext(false)
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.signInButton.isEnabled, false)
    }
    
    func testView_subscribesToEmailEnabledState() {
        givenInitializedView()
        XCTAssertEqual(sut.emailField.isEnabled, true)
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.emailInputEnabled.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.emailInputEnabled.onNext(false)
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.emailField.isEnabled, false)
    }
    
    func testView_subscribesToPasswordEnabledState() {
        givenInitializedView()
        XCTAssertEqual(sut.passwordField.isEnabled, true)
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.passwordInputEnabled.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.passwordInputEnabled.onNext(false)
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.passwordField.isEnabled, false)
    }
    
    func testView_drivesPasswordToViewModel() {
        givenInitializedView()
        var returnedPassword = ""
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.passwordInput.subscribe(onNext: { pwd in
            returnedPassword = pwd
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        sut.passwordField.text = "TEST"
        sut.passwordField.sendActions(for: .editingChanged)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedPassword, "TEST")
    }
    
    func testView_drivesEmailToViewModel() {
        givenInitializedView()
        var returnedEmail = ""
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.emailInput.subscribe(onNext: { email in
            returnedEmail = email
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        sut.emailField.text = "TEST"
        sut.emailField.sendActions(for: .editingChanged)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedEmail, "TEST")
    }
}
