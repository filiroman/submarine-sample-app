//
//  AlbumDetailsViewControllerTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 23.02.2021.
//

import XCTest
import RxSwift
@testable import ItunesExample

class AlbumDetailsViewControllerTests: XCTestCase {
    var sut: AlbumDetailsViewController!
    var viewModel: AlbumDetailsViewModelMock!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        viewModel = AlbumDetailsViewModelMock()
        sut = AlbumDetailsViewController(viewModel: viewModel)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
    }
    
    // MARK: - Helpers
    func onViewLoaded() {
        sut.loadView()
        sut.viewDidLoad()
    }
    
    // MARK: - Tests
    func testViewController_initialized_setsAlbumDetailsRootView() {
        sut.loadView()
        XCTAssertTrue(sut.view is AlbumDetailsRootView)
    }
    
    func testViewController_initialized_setsNavigationItemTitle() {
        XCTAssertEqual(sut.navigationItem.title, "Details".localized)
    }
    
    func testViewController_whenViewModelEmitsError_presentsError() throws {
        onViewLoaded()
        
        let exp = XCTestExpectation(description: "Error observable callback")
        viewModel.errorPresentation.subscribe(onNext: { (nextError) in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.errorMessagesSubject.onNext(ErrorMessage.testMessage)
        wait(for: [exp], timeout: 0.2)
        let err = try XCTUnwrap(viewModel.errorPresentation.value())
        
        XCTAssertEqual(err, .presenting)
    }
    
    func testViewController_viewDidLoad_callsFetchDataOnViewModel() {
        onViewLoaded()
        
        XCTAssertEqual(viewModel.fetchDataIsCalled, true)
    }
    
}

