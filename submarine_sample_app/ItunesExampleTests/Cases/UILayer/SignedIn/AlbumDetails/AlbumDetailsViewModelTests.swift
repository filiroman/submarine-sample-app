//
//  AlbumDetailsViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 23.02.2021.
//

import XCTest
import RxSwift
@testable import ItunesExample

class AlbumDetailsViewModelTests: XCTestCase {
    var vm: AlbumViewModelMock!
    var sut: AlbumDetailsViewModelImpl!
    var imgService: ImageServiceMock!
    var mediaAPI: MediaLibraryRemoteAPIMock!
    
    let disposeBag = DisposeBag()
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        imgService = ImageServiceMock()
        mediaAPI = MediaLibraryRemoteAPIMock()
        vm = AlbumViewModelMock()
        sut = AlbumDetailsViewModelImpl(model: vm, mediaAPI: mediaAPI, imageService: imgService)
    }
    
    override func tearDownWithError() throws {
        imgService = nil
        mediaAPI = nil
        vm = nil
        sut = nil
    }

    // MARK: - Tests
    // MARK: - Initialize
    func testViewModel_initialized_trackViewModelsEmpty() throws {
        let tracksVM = try sut.tracks.value() as? [TrackViewModelImpl]
        
        XCTAssertEqual(tracksVM, [])
    }
    
    func testViewModel_initialized_activityIndicatorIsNotAnimating() throws {
        let isAnimating = try sut.loadingActivityIndicatorAnimating.value()
        
        XCTAssertEqual(isAnimating, false)
    }
    
    func testViewModel_initialized_hasValidAlbumTitle() throws {
        XCTAssertEqual(sut.albumTitle, vm.albumTitle)
    }
    
    func testViewModel_initialized_hasValidArtistTitle() throws {
        XCTAssertEqual(sut.artistTitle, vm.artistTitle)
    }
    
    func testViewModel_initialized_noErrorReturned() throws {
        let exp = expectation(description: "Subscribe Error OnNext Called")
        exp.isInverted = true
        
        sut.errorMessages.subscribe(onNext: { (err) in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 0.2)
    }
    // MARK: - Fetch Data
    func testViewModel_fetchDataCalled_callsFetchTracksMediaAPI() {
        sut.fetchData()
        XCTAssertEqual(mediaAPI.fetchTracksCalled, true)
    }
    
    func testViewModel_fetchDataCalled_activityIndicatorIsAnimating() throws {
        let exp = XCTNSNotificationExpectation(name: Notification.fetchTracksCalledNotification)
        sut.fetchData()
        wait(for: [exp], timeout: 0.2)
        
        let activityIndicatorIsAnimating = try XCTUnwrap(sut.loadingActivityIndicatorAnimating.value())
        XCTAssertEqual(true, activityIndicatorIsAnimating)
    }
    
    func testViewModel_fetchDataCalled_noErrorReturned() throws {
        let exp = expectation(description: "Subscribe Error OnNext Called")
        exp.isInverted = true
        
        sut.errorMessages.subscribe(onNext: { (err) in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchData()
        mediaAPI.tracksCompletionHandler?([], nil)
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testViewModel_fetchDataReturnsError_returnsError() throws {
        let exp = expectation(description: "Subscribe Error OnNext Called")
        let error = NSError.testError
        var returnedError: NSError?
        
        sut.errorMessages.subscribe(onNext: { (err) in
            returnedError = err as NSError
            exp.fulfill()
        }).disposed(by: disposeBag)

        sut.fetchData()
        mediaAPI.tracksCompletionHandler?(nil, error)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertNotNil(returnedError)
    }
    
    func testViewModel_fetchDataReturnsError_activityIndicatorIsNotAnimating() throws {
        let exp = expectation(description: "Subscribe Error OnNext Called")
        let error = NSError.testError
        
        sut.errorMessages.subscribe(onNext: { (err) in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchData()
        mediaAPI.tracksCompletionHandler?(nil, error)
        
        wait(for: [exp], timeout: 0.2)
        let activityIndicatorIsAnimating = try XCTUnwrap(sut.loadingActivityIndicatorAnimating.value())
        XCTAssertEqual(false, activityIndicatorIsAnimating)
    }
    
    func testViewModel_fetchDataReturnsError_doesNotUpdateTracks() throws {
        let exp = expectation(description: "Subscribe Tracks OnNext Called")
        
        var returnedTracks: [TrackViewModelImpl]?
        let error = NSError.testError
        
        sut.tracks.subscribe(onNext: { (tracks) in
            returnedTracks = tracks as? [TrackViewModelImpl]
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchData()
        mediaAPI.tracksCompletionHandler?(nil, error)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedTracks, [])
    }
    
    func testViewModel_fetchDataReturnsData_updatesTracks() {
        let exp = expectation(description: "Subscribe Tracks OnNext Called")
        exp.expectedFulfillmentCount = 2
        var returnedTracks: [TrackViewModelImpl]?
        let model = TrackMediaItemModel.testModel
        let tracks = [TrackViewModelImpl(model: model)]
        
        sut.tracks.subscribe(onNext: { (tracks) in
            returnedTracks = tracks as? [TrackViewModelImpl]
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchData()
        mediaAPI.tracksCompletionHandler?([model], nil)
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedTracks, tracks)
    }
    
    func testViewModel_fetchDataReturnsData_activityIndicatorIsNotAnimating() throws {
        let exp = expectation(description: "Subscribe Tracks OnNext Called")
        exp.expectedFulfillmentCount = 2
        let model = TrackMediaItemModel.testModel
        
        sut.tracks.subscribe(onNext: { (_) in
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        sut.fetchData()
        mediaAPI.tracksCompletionHandler?([model], nil)
        
        wait(for: [exp], timeout: 0.2)
        let activityIndicatorIsAnimating = try XCTUnwrap(sut.loadingActivityIndicatorAnimating.value())
        XCTAssertEqual(false, activityIndicatorIsAnimating)
    }
    
    func testViewModel_fetchDataCalledTwoTimes_firstCallIsCanceled() throws {
        sut.fetchData()
        let firstTask = mediaAPI.lastSessionTask
        sut.fetchData()
        
        XCTAssertNotEqual(firstTask, mediaAPI.lastSessionTask)
        XCTAssertEqual(firstTask?.calledCancel, true)
    }
    
    func testViewModel_getCoverImage_modelArtworkURLNil_returnsPlaceholderImage() {
        vm.mockCoverImageUrl = nil
        let exp = XCTestExpectation(description: "Get preview image callback")
        var returnedImage: UIImage?
        sut.getCoverImage { (img) in
            returnedImage = img
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedImage, UIImage.placeholder)
    }
    
    func testViewModel_getCoverImage_modelArtworkURLNotNil_callsImageService() {
        vm.mockCoverImageUrl = URL(string: "https://example.com/")
        let img = UIImage.testImage
        imgService.returnImage = img
        let exp = XCTestExpectation(description: "Get preview image callback")
        
        sut.getCoverImage { (_) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(imgService.downloadImageCalled, true)
    }
    
    func testViewModel_getCoverImage_returnsImage_returnsCorrectImage() {
        vm.mockCoverImageUrl = URL(string: "https://example.com/")
        let img = UIImage.testImage
        imgService.returnImage = img
        let exp = XCTestExpectation(description: "Get preview image callback")
        
        var returnedImage: UIImage?
        sut.getCoverImage { (img) in
            returnedImage = img
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedImage, img)
    }
    
    func testViewModel_getCoverImage_returnsError_returnsPlaceholderImage() {
        vm.mockCoverImageUrl = URL(string: "https://example.com/")
        let err = NSError.testError
        imgService.returnError = err
        let exp = XCTestExpectation(description: "Get preview image callback")
        
        var returnedImage: UIImage?
        sut.getCoverImage { (img) in
            returnedImage = img
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedImage, UIImage.placeholder)
    }

}
