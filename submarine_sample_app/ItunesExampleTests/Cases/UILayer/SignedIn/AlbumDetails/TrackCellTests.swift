//
//  TrackCellTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
import XCTest
import RxSwift
@testable import ItunesExample

class TrackCellTests: XCTestCase {
    var sut: TrackCell!
    
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        sut = TrackCellImpl()
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
    }
    
    // MARK: - Helpers
    func mockViewModel() -> TrackViewModelMock {
        return TrackViewModelMock()
    }
    
    
    // MARK: - Tests
    
    func testCell_configuredWithViewModel_setsTrackTitle() {
        let vm = mockViewModel()
        vm.mockTrackTitle = "Test"
        sut.configure(withViewModel: vm)
        
        XCTAssertEqual(sut.trackLabel.text, vm.trackTitle)
    }
}
