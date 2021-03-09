//
//  FileUserSessionDataStoreTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import XCTest
@testable import ItunesExample

class FileUserSessionDataStoreTests: XCTestCase {
    var sut: UserSessionDataStore!
    
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        sut = FileUserSessionDataStore()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    //MARK: - Tests
    func testDataStore_whenSaveSessionInvokedWithValidSession_completionIsCalledWithSession() {
        let exp = XCTestExpectation(description: "save completion block called")
        let givenSession = UserSession.makeFakeSession()
        var returnedSession: UserSession?
        sut.save(userSession: givenSession) { (session, _) in
            returnedSession = session
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(givenSession, returnedSession)
    }
    
    func testDataStore_givenUserSessionSaved_whenLoadUserSession_returnsSameSession() {
        let exp = XCTestExpectation(description: "save completion block called")
        let givenSession = UserSession.makeFakeSession()
        var returnedSession: UserSession?
        sut.save(userSession: givenSession) { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        let exp2 = XCTestExpectation(description: "read completion block called")
        sut.readUserSession() { (session, _) in
            returnedSession = session
            exp2.fulfill()
        }
        
        wait(for: [exp2], timeout: 1)
        XCTAssertEqual(givenSession, returnedSession)
    }
}
