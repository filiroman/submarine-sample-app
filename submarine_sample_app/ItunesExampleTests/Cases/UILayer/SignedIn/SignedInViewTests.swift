//
//  SignedInViewTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 05.03.2021.
//

import XCTest
@testable import ItunesExample

class SignedInViewTests: XCTestCase {
    var sut: SignedInView!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testView_searchStatesAreEqual() {
        let v1 = SignedInView.search
        let v2 = SignedInView.search
        
        XCTAssertEqual(v1, v2)
    }
    
    func testView_albumDetailsStatesAreNotEqual() {
        let v2 = SignedInView.albumDetails(model: AlbumViewModelImpl.testModel)
        let v3 = SignedInView.albumDetails(model: AlbumViewModelImpl.testModel)
        
        XCTAssertNotEqual(v2, v3)
    }
    
    func testView_differentStatesAreNotEqual() {
        let v1 = SignedInView.search
        let v2 = SignedInView.albumDetails(model: AlbumViewModelImpl.testModel)
        
        XCTAssertNotEqual(v1, v2)
    }

}
