//
//  ITunesMediaLibraryRemoteAPITests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 26.01.2021.
//

import XCTest
@testable import ItunesExample

class ITunesMediaLibraryRemoteAPITests: XCTestCase {
    var sut: ITunesMediaLibraryRemoteAPI!
    var networkService: MockNetworkService!
    
    private let albumId = 1445522423
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        networkService = MockNetworkService()
        sut = ITunesMediaLibraryRemoteAPI(networkService: networkService)
    }

    override func tearDownWithError() throws {
        networkService = nil
        sut = nil
    }

    // MARK: - Tests
    // MARK: - Fetch Tracks
    func testMediaLibrary_declaresFetchTracks() {
        let service = sut as MediaLibraryRemoteAPI
        
        service.fetchTracks(withAlbumId: albumId) { _, _ in }
    }
    
    func testMediaLibrary_fetchTracks_callsCompletionHandler() {
        var calledCompletion = false
        let exp = XCTestExpectation(description: "Completion called")
        
        sut.fetchTracks(withAlbumId: albumId) { (_, _) in
            calledCompletion = true
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertEqual(true, calledCompletion)
    }
    
    func testMediaLibrary_fetchTracks_callsRightURLWithParameters() {
        let expectedURL = URL(string: ITunes.Constants.baseLookupURL)
        let expectedParams = ["media": "music", "entity": "song", "id": String(albumId)]
        let exp = XCTestExpectation(description: "Completion called")
        
        sut.fetchTracks(withAlbumId: albumId) { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertEqual(expectedURL, networkService.calledURL)
        XCTAssertEqual(expectedParams, networkService.calledParams)
    }
    
    func testMediaLibrary_fetchTracksGivenNetworkError_callsCompletionHandlerWithError() throws {
        let expectedError = NSError(domain: "Network Error", code: -1, userInfo: nil)
        networkService.networkError = expectedError
        let exp = XCTestExpectation(description: "Completion called")
        var returnedError: Error?
        
        sut.fetchTracks(withAlbumId: albumId) { (_, error) in
            returnedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        let actualError = try XCTUnwrap(returnedError as NSError?)
        XCTAssertEqual(expectedError, actualError)
    }
    
    func testMediaLibrary_fetchTracksCalled_returnsSessionDataTask() {
        let task = sut.fetchTracks(withAlbumId: albumId) { (_, _) in }
        XCTAssertNotNil(task)
    }
    
    func testMediaLibrary_fetchTracksCalled_returnsData() throws {
        let data = try Data.fromJSON(fileName: "MockTrackItemModel")
        let decoder = JSONDecoder()
        let mediaItem = try decoder.decode(TrackMediaItemModel.self, from: data)
        guard let mediaId = mediaItem.itemID else {
            XCTFail()
            return
        }
        let fetchMediaResponse = FetchTracksResponse(resultCount: 1, results: [mediaItem])
        
        networkService.returnedData = fetchMediaResponse
        
        let exp = XCTestExpectation(description: "Completion called")
        var returnedData: [TrackMediaItemModel]?
        var returnedError: Error?
        sut.fetchTracks(withAlbumId: mediaId) { (res, err) in
            returnedData = res
            returnedError = err
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertNil(returnedError)
        XCTAssertEqual(returnedData, [mediaItem])
    }
    
    // MARK: - Fetch Albums
    func testMediaLibrary_declaresFetchAlbums() {
        let service = sut as MediaLibraryRemoteAPI
        
        service.fetchAlbums(withQuery: "") { _, _ in }
    }
    
    func testMediaLibrary_fetchAlbums_callsCompletionHandler() {
        var calledCompletion = false
        let exp = XCTestExpectation(description: "Completion called")
        
        sut.fetchAlbums(withQuery: "") { (_, _) in
            calledCompletion = true
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertEqual(true, calledCompletion)
    }
    
    func testMediaLibrary_fetchAlbums_callsRightURLWithParameters() {
        let expectedURL = URL(string: ITunes.Constants.baseSearchURL)
        let expectedParams = ["media": "music", "entity": "album", "term": "test"]
        let exp = XCTestExpectation(description: "Completion called")
        
        sut.fetchAlbums(withQuery: "test") { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertEqual(expectedURL, networkService.calledURL)
        XCTAssertEqual(expectedParams, networkService.calledParams)
    }
    
    func testMediaLibrary_fetchAlbumsGivenNetworkError_callsCompletionHandlerWithError() throws {
        let expectedError = NSError(domain: "Network Error", code: -1, userInfo: nil)
        networkService.networkError = expectedError
        let exp = XCTestExpectation(description: "Completion called")
        var returnedError: Error?
        
        sut.fetchAlbums(withQuery: "test") { (_, error) in
            returnedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        let actualError = try XCTUnwrap(returnedError as NSError?)
        XCTAssertEqual(expectedError, actualError)
    }
    
    func testMediaLibrary_fetchAlbumsCalledWithEmptyString_callsCompletionHandlerWithEmptyArray() {
        let exp = XCTestExpectation(description: "Completion called")
        var returnedData: [AlbumMediaItemModel]?
        var returnedError: Error?
        sut.fetchAlbums(withQuery: "") { (res, err) in
            returnedData = res
            returnedError = err
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertNil(returnedError)
        XCTAssertEqual(returnedData, [])
    }
    
    func testMediaLibrary_fetchAlbumsCalled_returnsData() throws {
        let data = try Data.fromJSON(fileName: "MockAlbumItemModel")
        let decoder = JSONDecoder()
        let mediaItem = try decoder.decode(AlbumMediaItemModel.self, from: data)
        let fetchMediaResponse = FetchAlbumsResponse(resultCount: 1, results: [mediaItem])
        
        networkService.returnedData = fetchMediaResponse
        
        let exp = XCTestExpectation(description: "Completion called")
        var returnedData: [AlbumMediaItemModel]?
        var returnedError: Error?
        sut.fetchAlbums(withQuery: "The Beatles") { (res, err) in
            returnedData = res
            returnedError = err
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertNil(returnedError)
        XCTAssertEqual(returnedData, [mediaItem])
    }
    
    func testMediaLibrary_fetchAlbumsCalledWithEmptyString_loadRequestNotCalled() {
        let exp = XCTestExpectation(description: "Completion called")
        
        sut.fetchAlbums(withQuery: "") { (_, _) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertNil(networkService.calledURL)
        XCTAssertNil(networkService.calledParams)
    }
    
    func testMediaLibrary_fetchAlbumsCalled_returnsSessionDataTask() {
        let task = sut.fetchAlbums(withQuery: "test") { (_, _) in }
        XCTAssertNotNil(task)
    }
    
    func testMediaLibrary_fetchAlbumsCalledWithEmptyString_returnsNil() {
        let task = sut.fetchAlbums(withQuery: "") { (_, _) in }
        XCTAssertNil(task)
    }
}
