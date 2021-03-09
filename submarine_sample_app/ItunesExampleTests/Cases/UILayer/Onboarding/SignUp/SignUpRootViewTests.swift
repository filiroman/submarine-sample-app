//
//  SignUpRootViewTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 05.03.2021.
//

import XCTest
import RxSwift
@testable import ItunesExample

class SignUpRootViewTests: XCTestCase {
    // MARK: - Properties
    var sut: SignUpRootView!
    var viewModel: SignUpViewModelMock!
    
    var disposeBag: DisposeBag!
    
    // MARK: - Test Lifecycly
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        viewModel = SignUpViewModelMock()
        sut = SignUpRootView()
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
    
    func testView_initialized_hassignUpButtonTitle() {
        XCTAssertEqual(sut.signUpButton.title(for: .normal), "Sign Up".localized)
    }
    
    func testView_initialized_hasAppBackgroundSet() {
        XCTAssertEqual(sut.backgroundColor, AppColors.background)
    }
    
    func testView_didMoveToSuperview_callsViewModelsignUpOnButtonTap() {
        givenInitializedView()

        sut.signUpButton.sendActions(for: .touchUpInside)
        
        XCTAssertEqual(viewModel.signUpCalled, true)
    }
    
    func testView_didMoveToSuperview_activityIndicatorIsNotAnimating() {
        givenInitializedView()
        
        XCTAssertEqual(sut.signUpActivityIndicator.isAnimating, false)
    }
    
    func testView_subscribesToActivityIndicatorSequence() {
        givenInitializedView()
        XCTAssertEqual(sut.signUpActivityIndicator.isAnimating, false)
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.signUpActivityIndicatorAnimating.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.signUpActivityIndicatorAnimating.onNext(true)
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.signUpActivityIndicator.isAnimating, true)
    }
    
    func testView_subscribesToSignUpEnabledState() {
        givenInitializedView()
        XCTAssertEqual(sut.signUpButton.isEnabled, true)
        
        let exp = XCTestExpectation(description: "Subscription expectation")
        viewModel.signUpButtonEnabled.subscribe(onNext: { _ in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.signUpButtonEnabled.onNext(false)
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.signUpButton.isEnabled, false)
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

