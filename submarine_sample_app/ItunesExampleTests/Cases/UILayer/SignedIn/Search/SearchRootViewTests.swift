//
//  SearchRootViewTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 30.01.2021.
//

import XCTest
import RxSwift
import RxCocoa

@testable import ItunesExample

class SearchRootViewTests: XCTestCase {
    // MARK: - Properties
    var sut: SearchRootView!
    var viewModel: SearchViewModelMock!
    var imageService: ImageServiceMock!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        viewModel = SearchViewModelMock()
        sut = SearchRootView()
        imageService = ImageServiceMock()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
        imageService = nil
    }
    
    // MARK: - Given
    func givenTestAlbumModels() throws -> [AlbumViewModel] {
        let data = try Data.fromJSON(fileName: "MockAlbumItemModel")
        let decoder = JSONDecoder()
        let mediaItem = try decoder.decode(AlbumMediaItemModel.self, from: data)
        let viewModel = AlbumViewModelImpl(model: mediaItem, imageService: imageService)
        return [viewModel]
    }
    
    func givenViewModelsAlbumsSubscriptionExpectation() -> XCTestExpectation {
        let exp = XCTestExpectation(description: "View Models Albums Subscription")
        
        viewModel.albums.subscribe(onNext: { albums in
            exp.fulfill()
        }).disposed(by: disposeBag)
        return exp
    }
    
    func givenInitializedView() {
        sut.didMoveToSuperview()
        sut.setupBinding(viewModel: viewModel)
    }
    
    // MARK: - Tests
    func testView_initialized_hasSearchBarWithRightPlaceholder() {
        XCTAssertEqual(sut.searchBar.placeholder, "Search Albums".localized)
    }
    
    func testView_initialized_hasBackgroundColor() {
        XCTAssertEqual(sut.backgroundColor, AppColors.background)
    }
    
    func testView_whenLoaded_collectionView_hasBackgroundViewSet() {
        givenInitializedView()
        XCTAssertNotNil(sut.collectionView.backgroundView)
    }
    
    func testView_albumsEmpty_hasBackgroundViewVisible() throws {
        givenInitializedView()
        let exp = givenViewModelsAlbumsSubscriptionExpectation()
        
        viewModel.albums.onNext([])
        wait(for: [exp], timeout: 0.2)
        let backgroundView = try XCTUnwrap(sut.collectionView.backgroundView)
        XCTAssertEqual(backgroundView.isHidden, false)
    }
    
    func testView_albumsNotEmpty_hasNoBackgroundView() throws {
        givenInitializedView()
        let items = try givenTestAlbumModels()
        let exp = givenViewModelsAlbumsSubscriptionExpectation()
        
        viewModel.albums.onNext(items)
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertNil(sut.collectionView.backgroundView)
    }
    
    func testView_albumsUpdatedFromEmptyToNotEmpty_updatesBackgroundView() throws {
        givenInitializedView()
        let items = try givenTestAlbumModels()
        var exp = givenViewModelsAlbumsSubscriptionExpectation()
        
        viewModel.albums.onNext([])
        wait(for: [exp], timeout: 0.2)
        
        let backgroundView = try XCTUnwrap(sut.collectionView.backgroundView)
        XCTAssertEqual(backgroundView.isHidden, false)
        
        exp = givenViewModelsAlbumsSubscriptionExpectation()
        
        viewModel.albums.onNext(items)
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertNil(sut.collectionView.backgroundView)
    }
    
    func testView_albumsUpdatedFromNotEmptyToEmpty_updatesBackgroundViewVisibility() throws {
        givenInitializedView()
        let items = try givenTestAlbumModels()
        var exp = givenViewModelsAlbumsSubscriptionExpectation()
        
        viewModel.albums.onNext(items)
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertNil(sut.collectionView.backgroundView)
        
        exp = givenViewModelsAlbumsSubscriptionExpectation()
        
        viewModel.albums.onNext([])
        wait(for: [exp], timeout: 0.2)
        
        let backgroundView = try XCTUnwrap(sut.collectionView.backgroundView)
        XCTAssertEqual(backgroundView.isHidden, false)
    }
    
    func testView_collectionView_refreshControlNotNil() {
        givenInitializedView()
        XCTAssertNotNil(sut.collectionView.refreshControl)
    }
    
    func testView_initialized_setsCorrectRefreshControl() {
        givenInitializedView()
        
        XCTAssertEqual(sut.refreshControl, sut.collectionView.refreshControl)
    }
    
    func testView_initialized_doesNotRefresh() {
        givenInitializedView()
        
        XCTAssertEqual(sut.refreshControl.isRefreshing, false)
    }
    
    func testView_activityIndicatorAnimatingIsTrue_refreshesRefreshControl() {
        givenInitializedView()
        
        let exp = XCTNSNotificationExpectation(name: Notification.activityIndicatorAnimatingSequenceNotification)
        
        viewModel.searchActivityIndicatorAnimating.onNext(true)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.refreshControl.isRefreshing, true)
    }
    
    func testView_activityIndicatorAnimatingIsFalse_stopsRefreshControl() {
        givenInitializedView()
        
        let exp = XCTNSNotificationExpectation(name: Notification.activityIndicatorAnimatingSequenceNotification)
        exp.expectedFulfillmentCount = 2
        
        viewModel.searchActivityIndicatorAnimating.onNext(true)
        viewModel.searchActivityIndicatorAnimating.onNext(false)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(sut.refreshControl.isRefreshing, false)
    }
    
    func testView_onRefresh_searchIsCalledWithSearchBarText() {
        givenInitializedView()
        let enteredText = "TEST"
        sut.searchBar.text = enteredText

        let exp = XCTNSNotificationExpectation(name: Notification.searchIsCalledNotification)
        sut.refreshControl.sendActions(for: .valueChanged)

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(viewModel.searchCalled, true)
        XCTAssertEqual(enteredText, viewModel.searchCalledWithString)
    }

    func testView_searchBarTextIsNil_onRefresh_searchIsCalledWithEmptyText() {
        givenInitializedView()
        sut.searchBar.text = nil

        let exp = XCTNSNotificationExpectation(name: Notification.searchIsCalledNotification)
        sut.refreshControl.sendActions(for: .valueChanged)

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(viewModel.searchCalled, true)
        XCTAssertEqual("", viewModel.searchCalledWithString)
    }
    
    func testView_enterEmptySearchText_searchIsNotCalled() {
        givenInitializedView()
        let exp = XCTNSNotificationExpectation(name: Notification.searchIsCalledNotification)
        exp.isInverted = true
        
        let enteredText = ""
        sut.searchBar.text = enteredText
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(viewModel.searchCalled, false)
    }
}

