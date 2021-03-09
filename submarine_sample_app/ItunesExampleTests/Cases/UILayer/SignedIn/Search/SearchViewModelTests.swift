//
//  SearchViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 30.01.2021.
//

import XCTest
import RxSwift
@testable import ItunesExample

class SearchViewModelTests: XCTestCase {
    var sut: SearchViewModelImpl!
    var mediaAPI: MediaLibraryRemoteAPIMock!
    var imageService: ImageServiceMock!
    var responder: AlbumModelSelectedResponderMock!
    
    let disposeBag = DisposeBag()
    
    //MARK: - Test Lifecycle
    override func setUpWithError() throws {
        mediaAPI = MediaLibraryRemoteAPIMock()
        imageService = ImageServiceMock()
        responder = AlbumModelSelectedResponderMock()
        
        let albumViewModelFactory = { (model: AlbumMediaItemModel) in
            return self.makeAlbumViewModel(model: model)
        }
        
        sut = SearchViewModelImpl(mediaAPI: mediaAPI, responder: responder, makeAlbumViewModel: albumViewModelFactory)
    }
    
    override func tearDownWithError() throws {
        mediaAPI = nil
        imageService = nil
        sut = nil
    }
    
    //MARK: - Helpers
    func makeAlbumViewModel(model: AlbumMediaItemModel) -> AlbumViewModel {
        return AlbumViewModelImpl(model: model, imageService: imageService)
    }
    
    //MARK: - Given
    
    func givenSearchStringAndFetchCallback() {
        let exp = XCTNSNotificationExpectation(name: Notification.fetchAlbumsCalledNotification)
        sut.searchInput.onNext("test")
        
        wait(for: [exp], timeout: 0.2)
    }
    
    //MARK: - Tests
    func testViewModel_initialize_searchStringIsEmpty() throws {
        let val = try XCTUnwrap(sut.searchInput.value())
        XCTAssertEqual(val, "")
    }
    
    func testViewModel_enterSearchString_fetchAlbumsIsCalled() {
        givenSearchStringAndFetchCallback()
        
        XCTAssertEqual(true, mediaAPI.fetchAlbumsCalled)
    }
    
    func testViewModel_enterSearchString_activityIndicatorRefreshing() throws {
        givenSearchStringAndFetchCallback()
        
        let activityIndicatorIsAnimating = try XCTUnwrap(sut.searchActivityIndicatorAnimating.value())
        XCTAssertEqual(true, activityIndicatorIsAnimating)
    }
    
    func testViewModel_fetchAlbumsCompletionCallled_activityIndicatorNotRefreshing() throws {
        givenSearchStringAndFetchCallback()
        mediaAPI.albumsCompletionHandler?(nil, nil)
        
        let activityIndicatorIsAnimating = try XCTUnwrap(sut.searchActivityIndicatorAnimating.value())
        XCTAssertEqual(false, activityIndicatorIsAnimating)
    }
    
    func testViewModel_fetchAlbumsCompletionCallledWithError_activityIndicatorNotRefreshing() throws {
        givenSearchStringAndFetchCallback()
        let error = NSError.testError
        mediaAPI.albumsCompletionHandler?(nil, error)
        
        let activityIndicatorIsAnimating = try XCTUnwrap(sut.searchActivityIndicatorAnimating.value())
        XCTAssertEqual(false, activityIndicatorIsAnimating)
    }
    
    func testViewModel_fetchAlbumsCompletionCallledWithData_activityIndicatorNotRefreshing() throws {
        givenSearchStringAndFetchCallback()
        mediaAPI.albumsCompletionHandler?([], nil)
        
        let activityIndicatorIsAnimating = try XCTUnwrap(sut.searchActivityIndicatorAnimating.value())
        XCTAssertEqual(false, activityIndicatorIsAnimating)
    }
    
    func testViewModel_initialized_albumsIsEmpty() throws {
        let albums = try sut.albums.value() as? [AlbumViewModelImpl]
        XCTAssertEqual(albums, [])
    }
    
    func testViewModel_fetchAlbumsCompletionCallledWithData_setsAlbums() throws {
        givenSearchStringAndFetchCallback()
        mediaAPI.albumsCompletionHandler?([], nil)
        
        let albums = try XCTUnwrap(sut.albums.value()) as? [AlbumViewModelImpl]
        XCTAssertEqual([], albums)
    }
    
    func testViewModel_fetchAlbumsCompletionCallledWithError_setsError() throws {
        givenSearchStringAndFetchCallback()
        let error = NSError.testError
        var returnedError: ErrorMessage?
        let exp = XCTestExpectation(description: "Error subscription callback called")
        
        sut.errorMessages.subscribe(onNext: { (nextError) in
            returnedError = nextError
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        mediaAPI.albumsCompletionHandler?(nil, error)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertNotNil(returnedError)
    }
    
    func testViewModel_searchCalledWithEmptyString_fetchAlbumsIsNotCalled() {
        let exp = XCTNSNotificationExpectation(name: Notification.fetchAlbumsCalledNotification)
        exp.isInverted = true
        sut.search(query: "")
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(mediaAPI.fetchAlbumsCalled, false)
    }
    
    func testViewModel_searchCalledTwoTimes_firstNetworkCallIsCanceled() throws {
        sut.search(query: "test")
        let firstTask = mediaAPI.lastSessionTask
        sut.search(query: "test2")
        
        XCTAssertNotEqual(firstTask, mediaAPI.lastSessionTask)
        XCTAssertEqual(firstTask?.calledCancel, true)
    }
    
    func testViewModel_modelSelected_callsResponderModelSelected() {
        let model = AlbumViewModelImpl(model: AlbumMediaItemModel.testModel, imageService: imageService)
        sut.modelSelected(model: model)
        let selectedModel = responder.modelSelected as? AlbumViewModelImpl
        
        XCTAssertEqual(responder.modelSelectedCalled, true)
        XCTAssertEqual(model, selectedModel)
    }
    
//    func testViewModel_viewModelReturnsData_updatesDataVariable() throws {
//        let scheduler = TestScheduler(initialClock: 0)
//        let albums = scheduler.createObserver([AlbumMediaItemModel]?.self)
//
//        viewModel.albums
//            .asDriver(onErrorJustReturn: nil)
//            .drive(albums)
//            .disposed(by: disposeBag)
//
//        scheduler.createColdObservable([.next(10, [])])
//            .bind(to: viewModel.albums)
//            .disposed(by: disposeBag)
//
//        scheduler.start()
//        XCTAssertEqual(albums.events, [
//            .next(0, nil),
//            .next(10, [])
//        ])
//    }
}
