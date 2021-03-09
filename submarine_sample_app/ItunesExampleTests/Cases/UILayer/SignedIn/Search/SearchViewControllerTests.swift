//
//  SearchViewControllerTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 30.01.2021.
//

import XCTest
import RxSwift
@testable import ItunesExample

class SearchViewControllerTests: XCTestCase {
    var sut: SearchViewController!
    var viewModel: SearchViewModelMock!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        viewModel = SearchViewModelMock()
        sut = SearchViewController(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
    }
    
    // MARK: - Tests
    func testViewController_initialized_setsSearchRootView() {
        sut.loadView()
        XCTAssertTrue(sut.view is SearchRootView)
    }
    
    func testViewController_initialized_setsNavigationItemTitle() {
        XCTAssertEqual(sut.navigationItem.title, "Search".localized)
    }
    
    func testViewController_whenViewModelEmitsError_presentsError() throws {
        sut.loadView()
        sut.viewDidLoad()
        
        let exp = XCTestExpectation(description: "Error observable callback")
        viewModel.errorPresentation.subscribe(onNext: { (nextError) in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        viewModel.errorMessagesSubject.onNext(ErrorMessage.testMessage)
        wait(for: [exp], timeout: 0.2)
        let err = try XCTUnwrap(viewModel.errorPresentation.value())
        
        XCTAssertEqual(err, .presenting)
    }
}
