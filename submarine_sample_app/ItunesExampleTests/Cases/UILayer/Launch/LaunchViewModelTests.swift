//
//  LaunchViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 21.12.2020.
//

import XCTest
@testable import ItunesExample

class LaunchViewModelTests: XCTestCase {
    
    var sut: LaunchViewModel!
    var repository: UserSessionRepositoryMock!
    var signedInMock: SignedInResponderMock!
    var notSignedInMock: NotSignedInResponderMock!
    
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        self.signedInMock = SignedInResponderMock()
        self.notSignedInMock = NotSignedInResponderMock()
        self.repository = UserSessionRepositoryMock()
        self.sut = LaunchViewModel(userSessionRepository: repository,
                                   notSignedInResponder: notSignedInMock,
                                   signedInResponder: signedInMock)
    }
    
    override func tearDownWithError() throws {
        self.notSignedInMock = nil
        self.signedInMock = nil
        self.repository = nil
        self.sut = nil
    }
    
    //MARK: - When
    
    func whenReadUserSessionNotNil() {
        repository.userSession = UserSession.makeFakeSession()
    }
    
    func whenReadUserSessionNil() {
        repository.userSession = nil
    }
    
    func whenReadUserSessionError() {
        repository.readUserSessionError = NSError(domain: "Test error!", code: -1, userInfo: nil)
    }
    
    //MARK: - Tests
    func testViewModel_whenReadUserSessionNotNil_signedInIsCalled() {
        whenReadUserSessionNotNil()
        
        let exp = expectation(forNotification: Notification.signedInNotification, object: nil)
        
        sut.loadUserSession()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, signedInMock.signedInCalled)
    }
    
    func testViewModel_whenReadUserSessionNil_notSignedInIsCalled() {
        whenReadUserSessionNil()
        
        let exp = expectation(forNotification: Notification.notSignedInNotification, object: nil)
        
        sut.loadUserSession()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, notSignedInMock.notSignedInCalled)
    }
    
    func testViewModel_whenReadUserSessionError_generatesError() {
        whenReadUserSessionError()
        
        let exp = expectation(description: "Error generated expectation")
        _ = sut.errorMessages.subscribe { (_) in
            exp.fulfill()
        }
        
        sut.loadUserSession()
        
        wait(for: [exp], timeout: 1)
    }
    
    func testViewModel_whenGeneratesError_notSignedInIsCalledAfterClose() {
        whenReadUserSessionError()
        
        _ = sut.errorMessages.subscribe { [weak self](_) in
            self?.sut.errorPresentation.onNext(.presenting)
            self?.sut.errorPresentation.onNext(.dismissed)
        }
        
        let exp = expectation(forNotification: Notification.notSignedInNotification, object: nil)
        
        sut.loadUserSession()
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, notSignedInMock.notSignedInCalled)
    }
}
