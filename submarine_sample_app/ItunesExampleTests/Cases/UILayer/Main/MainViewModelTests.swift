//
//  MainViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import XCTest
@testable import ItunesExample

class MainViewModelTests: XCTestCase {
    var sut: MainViewModel!
    
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        sut = MainViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    //MARK: - Tests
    func testViewModel_whenInitialized_viewInLaunchingState() {
        let exp = XCTestExpectation(description: "observable element returned")
        
        var mainViewState: MainView?
        let s = sut.view.subscribe(onNext: { (mainView) in
            mainViewState = mainView
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 1)
        s.dispose()
        
        XCTAssertEqual(mainViewState, .launching)
    }
    
    func testViewModel_whenSignedInCalled_viewInSignInState() {
        let exp = XCTestExpectation(description: "observable element returned")
        exp.expectedFulfillmentCount = 2
        
        var mainViewState: MainView?
        let s = sut.view.subscribe(onNext: { (mainView) in
            mainViewState = mainView
            exp.fulfill()
        })
        let givenSession = UserSession.makeFakeSession()
        sut.signedIn(to: givenSession)
        
        wait(for: [exp], timeout: 1)
        s.dispose()
        
        XCTAssertEqual(mainViewState, .signedIn(userSession: givenSession))
    }
    
    func testViewModel_whenNotSignedInCalled_viewInOnboardingState() {
        let exp = XCTestExpectation(description: "observable element returned")
        exp.expectedFulfillmentCount = 2
        
        var mainViewState: MainView?
        let s = sut.view.subscribe(onNext: { (mainView) in
            mainViewState = mainView
            exp.fulfill()
        })
        sut.notSignedIn()
        
        wait(for: [exp], timeout: 1)
        s.dispose()
        
        XCTAssertEqual(mainViewState, .onboarding)
    }
}
