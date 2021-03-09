//
//  ITunesUserSessionRepositoryTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import XCTest
@testable import ItunesExample

class ITunesUserSessionRepositoryTests: XCTestCase {
    
    var sut: ITunesUserSessionRepository!
    var dataStore: UserSessionDataStoreMock!
    var remoteAPI: AuthRemoteAPIMock!
    
    
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        self.dataStore = UserSessionDataStoreMock()
        self.remoteAPI = AuthRemoteAPIMock()
        self.sut = ITunesUserSessionRepository(dataStore: dataStore, remoteAPI: remoteAPI)
    }
    
    override func tearDownWithError() throws {
        self.dataStore = nil
        self.remoteAPI = nil
        self.sut = nil
    }
    
    //MARK: - When
    

    //MARK: - Tests
    func testRepository_whenReadUserSession_dataStoreReadUserSessionIsCalled() {
        let exp = XCTestExpectation(description: "readUserSessionIsCalled")
        sut.readUserSession { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, dataStore.readUserSessionCalled)
    }
    
    func testRepository_whenReadUserSession_whenDataStoreReturnsSession_returnsSession() {
        dataStore.userSession = UserSession.makeFakeSession()
        let exp = XCTestExpectation(description: "readUserSessionIsCalled")
        
        var returnedSession: UserSession?
        sut.readUserSession { (session, _) in
            returnedSession = session
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(dataStore.userSession, returnedSession)
    }
    
    func testRepository_whenReadUserSession_dataStoreReturnsError_returnsError() {
        let setError: NSError? = NSError.testError
        dataStore.error = setError
        let exp = XCTestExpectation(description: "readUserSessionIsCalled")
        
        var returnedError: NSError?
        sut.readUserSession { (_, error) in
            returnedError = error as NSError?
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setError, returnedError)
    }
    
    func testRepository_whenSignUpCalled_authRemoteAPIIsCalled() {
        let exp = XCTestExpectation(description: "signUpIsCalled")
        let newAccount = NewAccount(username: "test", email: "test", password: "test")
        sut.signUp(newAccount: newAccount) { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, remoteAPI.signUpCalled)
    }
    
    func testRepository_whenSignUpCalled_remoteAPIReturnsSession_dataStoreSaveIsCalled() {
        let exp = XCTestExpectation(description: "signUpIsCalled")
        let newAccount = NewAccount(username: "test", email: "test", password: "test")
        remoteAPI.userSession = UserSession.makeFakeSession()
        sut.signUp(newAccount: newAccount) { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, dataStore.saveUserSessionCalled)
    }
    
    func testRepository_whenSignUpCalled_remoteAPIReturnsSession_returnsSession() {
        let exp = XCTestExpectation(description: "signUpIsCalled")
        let newAccount = NewAccount(username: "test", email: "test", password: "test")
        var returnedSession: UserSession?
        remoteAPI.userSession = UserSession.makeFakeSession()
        sut.signUp(newAccount: newAccount) { (userSession, _) in
            returnedSession = userSession
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(remoteAPI.userSession, returnedSession)
    }
    
    func testRepository_whenSignUpCalled_remoteAPIReturnsError_returnsError() {
        let exp = XCTestExpectation(description: "signUpIsCalled")
        let newAccount = NewAccount(username: "test", email: "test", password: "test")
        var returnedError: NSError?
        let setError = NSError.testError
        remoteAPI.error = setError
        sut.signUp(newAccount: newAccount) { (_, error) in
            returnedError = error as NSError?
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setError, returnedError)
    }
    
    func testRepository_whenSignUpCalled_remoteAPIReturnsSession_dataStoreReturnsError_returnsError() {
        let exp = XCTestExpectation(description: "signUpIsCalled")
        let newAccount = NewAccount(username: "test", email: "test", password: "test")
        var returnedError: NSError?
        let setError = NSError.testError
        remoteAPI.userSession = UserSession.makeFakeSession()
        dataStore.error = setError
        sut.signUp(newAccount: newAccount) { (_, error) in
            returnedError = error as NSError?
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setError, returnedError)
    }
    
    func testRepository_whenSignInCalled_authRemoteAPIIsCalled() {
        let exp = XCTestExpectation(description: "signInIsCalled")
        sut.signIn(email: "test", password: "test") { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, remoteAPI.signInCalled)
    }
    
    func testRepository_whenSignInCalled_remoteAPIReturnsSession_dataStoreSaveIsCalled() {
        let exp = XCTestExpectation(description: "signInIsCalled")
        
        remoteAPI.userSession = UserSession.makeFakeSession()
        sut.signIn(email: "test", password: "test") { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(true, dataStore.saveUserSessionCalled)
    }
    
    func testRepository_whenSignInCalled_remoteAPIReturnsSession_returnsSession() {
        let exp = XCTestExpectation(description: "signInIsCalled")
        var returnedSession: UserSession?
        remoteAPI.userSession = UserSession.makeFakeSession()
        sut.signIn(email: "test", password: "test") { (userSession, _) in
            returnedSession = userSession
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(remoteAPI.userSession, returnedSession)
    }
    
    func testRepository_whenSignInCalled_remoteAPIReturnsError_returnsError() {
        let exp = XCTestExpectation(description: "signInIsCalled")
        var returnedError: NSError?
        let setError = NSError.testError
        remoteAPI.error = setError
        sut.signIn(email: "test", password: "test") { (_, error) in
            returnedError = error as NSError?
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setError, returnedError)
    }
    
    func testRepository_whenSignInCalled_remoteAPIReturnsSession_dataStoreReturnsError_returnsError() {
        let exp = XCTestExpectation(description: "signInIsCalled")
        var returnedError: NSError?
        let setError = NSError.testError
        remoteAPI.userSession = UserSession.makeFakeSession()
        dataStore.error = setError
        sut.signIn(email: "test", password: "test") { (_, error) in
            returnedError = error as NSError?
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(setError, returnedError)
    }
}
