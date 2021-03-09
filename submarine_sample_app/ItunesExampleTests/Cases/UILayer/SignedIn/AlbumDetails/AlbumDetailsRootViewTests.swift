//
//  AlbumDetailsRootViewTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 26.02.2021.
//

import XCTest
import RxSwift
import RxCocoa

@testable import ItunesExample

class AlbumDetailsRootViewTests: XCTestCase {
    // MARK: - Properties
    var sut: AlbumDetailsRootView!
    var viewModel: AlbumDetailsViewModelMock!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        viewModel = AlbumDetailsViewModelMock()
        sut = AlbumDetailsRootView()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
    }
    
    // MARK: - Given
    func givenTestTrackModels() throws -> [TrackViewModel] {
        let data = try Data.fromJSON(fileName: "MockTrackItemModel")
        let decoder = JSONDecoder()
        let mediaItem = try decoder.decode(TrackMediaItemModel.self, from: data)
        let viewModel = TrackViewModelImpl(model: mediaItem)
        return [viewModel]
    }
    
    func givenActivityIndicatorExpectation() -> XCTestExpectation {
        let exp = XCTestExpectation(description: "Activity indicator expectation")
        
        viewModel.loadingActivityIndicatorAnimating.subscribe(onNext: { (isAnimating) in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        return exp
    }
    
    func givenViewModelsTracksSubscriptionExpectation() -> XCTestExpectation {
        let exp = XCTestExpectation(description: "View Models Tracks Subscription")
        
        viewModel.tracks.subscribe(onNext: { albums in
            exp.fulfill()
        }).disposed(by: disposeBag)
        return exp
    }
    
    func givenInitializedView() {
        sut.didMoveToSuperview()
        sut.setupBinding(viewModel: viewModel)
    }
    
    // MARK: - Tests
    func testView_initialized_hasBackgroundColor() {
        XCTAssertEqual(sut.backgroundColor, AppColors.background)
    }
    
    func testView_whenLoaded_tableView_hasBackgroundViewSet() {
        givenInitializedView()
        XCTAssertNotNil(sut.tableView.backgroundView)
    }
    
    func testView_albumsEmpty_hasBackgroundViewVisible() throws {
        givenInitializedView()
        let exp = givenViewModelsTracksSubscriptionExpectation()
        
        viewModel.tracks.onNext([])
        wait(for: [exp], timeout: 0.2)
        let backgroundView = try XCTUnwrap(sut.tableView.backgroundView)
        XCTAssertEqual(backgroundView.isHidden, false)
    }
    
    func testView_albumsNotEmpty_hasNoBackgroundView() throws {
        givenInitializedView()
        let items = try givenTestTrackModels()
        let exp = givenViewModelsTracksSubscriptionExpectation()
        
        viewModel.tracks.onNext(items)
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertNil(sut.tableView.backgroundView)
    }
    
    func testView_albumsUpdatedFromEmptyToNotEmpty_updatesBackgroundView() throws {
        givenInitializedView()
        let items = try givenTestTrackModels()
        var exp = givenViewModelsTracksSubscriptionExpectation()
        
        viewModel.tracks.onNext([])
        wait(for: [exp], timeout: 0.2)
        
        let backgroundView = try XCTUnwrap(sut.tableView.backgroundView)
        XCTAssertEqual(backgroundView.isHidden, false)
        
        exp = givenViewModelsTracksSubscriptionExpectation()
        
        viewModel.tracks.onNext(items)
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertNil(sut.tableView.backgroundView)
    }
    
    func testView_albumsUpdatedFromNotEmptyToEmpty_updatesBackgroundViewVisibility() throws {
        givenInitializedView()
        let items = try givenTestTrackModels()
        var exp = givenViewModelsTracksSubscriptionExpectation()
        
        viewModel.tracks.onNext(items)
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertNil(sut.tableView.backgroundView)
        
        exp = givenViewModelsTracksSubscriptionExpectation()
        
        viewModel.tracks.onNext([])
        wait(for: [exp], timeout: 0.2)
        
        let backgroundView = try XCTUnwrap(sut.tableView.backgroundView)
        XCTAssertEqual(backgroundView.isHidden, false)
    }
    
    func testView_tableView_refreshControlNotNil() {
        givenInitializedView()
        XCTAssertNotNil(sut.tableView.refreshControl)
    }

    func testView_initialized_setsCorrectRefreshControl() {
        givenInitializedView()

        XCTAssertEqual(sut.refreshControl, sut.tableView.refreshControl)
    }

    func testView_initialized_doesNotRefresh() {
        givenInitializedView()

        XCTAssertEqual(sut.refreshControl.isRefreshing, false)
    }

    func testView_activityIndicatorAnimatingIsTrue_refreshesRefreshControl() {
        givenInitializedView()
        let exp = givenActivityIndicatorExpectation()
        
        viewModel.loadingActivityIndicatorAnimating.onNext(true)

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.refreshControl.isRefreshing, true)
    }

    func testView_activityIndicatorAnimatingIsFalse_stopsRefreshControl() {
        givenInitializedView()
        let exp = givenActivityIndicatorExpectation()
        exp.expectedFulfillmentCount = 2

        viewModel.loadingActivityIndicatorAnimating.onNext(true)
        viewModel.loadingActivityIndicatorAnimating.onNext(false)

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.refreshControl.isRefreshing, false)
    }

    func testView_onRefresh_fetchDataIsCalled() {
        givenInitializedView()
        sut.refreshControl.sendActions(for: .valueChanged)

        XCTAssertEqual(viewModel.fetchDataIsCalled, true)
    }
}

