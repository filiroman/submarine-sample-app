//
//  ITunesNetworkServiceTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 26.01.2021.
//

import XCTest
@testable import ItunesExample

class ITunesNetworkServiceTests: XCTestCase {
    var sut: ITunesNetworkService!
    var session: MockURLSession!
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        session = MockURLSession()
        sut = ITunesNetworkService(session: session)
    }

    override func tearDownWithError() throws {
        session = nil
        sut = nil
    }

    // MARK: - Tests
    func testManager_whenInitialized_setsSession() {
        XCTAssertEqual(sut.session, session)
    }
    
    
}
