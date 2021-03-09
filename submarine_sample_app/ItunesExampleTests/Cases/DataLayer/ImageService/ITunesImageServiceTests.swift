//
//  ITunesImageServiceTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 02.02.2021.
//

import Foundation
import XCTest
@testable import ItunesExample

class ITunesImageServiceTests: XCTestCase {
    
    var mockSession: MockURLSession!
    var sut: ITunesImageService!
    var url: URL!
    var imageView: UIImageView!
    
    var receivedDataTask: MockURLSessionDataTask!
    var receivedError: Error!
    var receivedImage: UIImage!
    
    var expectedImage: UIImage!
    var expectedError: NSError!
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        mockSession = MockURLSession()
        url = URL(string: "https://example.com/image")!
        imageView = UIImageView()
        sut = ITunesImageService(responseQueue: nil, session: mockSession)
    }
        
    override func tearDownWithError() throws {
        mockSession = nil
        sut = nil
        url = nil
        imageView = nil
        receivedDataTask = nil
        receivedError = nil
        receivedImage = nil
        expectedImage = nil
        expectedError = nil
    }
    
    // MARK: - Given
    func givenExpectedImage() {
        expectedImage = UIImage.placeholder
    }
    
    func givenExpectedError() {
        expectedError = NSError.testError
    }
    
    // MARK: - When
    func whenDownloadImage(image: UIImage? = nil, error: Error? = nil) {
        receivedDataTask = sut.downloadImage(fromURL: url) { image, error in
            self.receivedImage = image
            self.receivedError = error
        } as? MockURLSessionDataTask
        if let receivedDataTask = receivedDataTask {
            if let image = image {
                receivedDataTask.completionHandler(image.pngData(), nil, nil)
                
            } else if let error = error {
                receivedDataTask.completionHandler(nil, nil, error)
            }
        }
    }
    
    func whenSetImage() {
        givenExpectedImage()
        sut.setImage(on: imageView, fromURL: url, withPlaceholder: nil)
        receivedDataTask = sut.cachedTaskForImageView[imageView] as? MockURLSessionDataTask
        receivedDataTask.completionHandler(expectedImage.pngData(), nil, nil)
    }
    
    // MARK: - Then
    func verifyDownloadImageDispatched(image: UIImage? = nil, error: Error? = nil, line: UInt = #line) {
        mockSession.givenDispatchQueue()
        sut = ITunesImageService(responseQueue: .main, session: mockSession)
        var receivedThread: Thread!
        let expectation = self.expectation(
            description: "Completion wasn't called")
        
        let dataTask = sut.downloadImage(fromURL: url) { _, _ in
            receivedThread = Thread.current
            expectation.fulfill()
        } as! MockURLSessionDataTask
        dataTask.completionHandler(image?.pngData(), nil, error)
        
        waitForExpectations(timeout: 0.2)
        XCTAssertTrue(receivedThread.isMainThread, line: line)
    }
    
    // MARK: - Tests
    func test_initialized_setsResponseQueue() {
        XCTAssertEqual(sut.responseQueue, nil)
    }
    
    func test_initialized_setsSession() {
        XCTAssertEqual(sut.session, mockSession)
    }
    
    func test_initialized_setsCachedImageForURL() {
        XCTAssertEqual(sut.cachedImageForURL, [:])
    }
    
    func test_initialized_setsCachedTaskForImageView() {
        XCTAssertEqual(sut.cachedTaskForImageView, [:])
    }

    func test_conformsTo_ImageService() {
        XCTAssertTrue((sut as AnyObject) is ImageService)
    }
    
    func test_imageService_declaresDownloadImage() {
        _ = sut.downloadImage(fromURL:url) { _, _ in }
    }
    
    func test_imageService_declaresSetImageOnImageView() {
        let imageView = UIImageView()
        let placeholder = UIImage.placeholder
        
        sut.setImage(on: imageView, fromURL: url, withPlaceholder: placeholder)
    }
    
    func test_downloadImage_createsExpectedDataTask() {
        whenDownloadImage()
        
        XCTAssertEqual(receivedDataTask.url, url)
    }
    
    func test_downloadImage_callsResumeOnDataTask() {
        whenDownloadImage()
        
        XCTAssertTrue(receivedDataTask.calledResume)
    }
    
    func test_downloadImage_givenImage_callsCompletionWithImage() {
        givenExpectedImage()
        
        whenDownloadImage(image: expectedImage)
        
        XCTAssertEqual(expectedImage.pngData(), receivedImage.pngData())
    }
    
    func test_downloadImage_givenError_callsCompletionWithError() {
        givenExpectedError()
        
        whenDownloadImage(error: expectedError)
        
        XCTAssertEqual(receivedError as NSError, expectedError)
    }
    
    func test_downloadImage_givenImage_dispatchesToResponseQueue() {
        givenExpectedImage()
        
        verifyDownloadImageDispatched(image: expectedImage)
    }
    
    func test_downloadImage_givenError_dispatchesToResponseQueue() {
        givenExpectedError()
        
        verifyDownloadImageDispatched(error: expectedError)
    }
    
    func test_downloadImage_givenImage_cachesImage() {
        givenExpectedImage()
        
        whenDownloadImage(image: expectedImage)
        
        XCTAssertEqual(sut.cachedImageForURL[url]?.pngData(), expectedImage.pngData())
    }
    
    func test_downloadImage_givenCachedImage_returnsNilDataTask() {
        givenExpectedImage()
        
        whenDownloadImage(image: expectedImage)
        whenDownloadImage(image: expectedImage)
        
        XCTAssertNil(receivedDataTask)
    }
    
    func test_downloadImage_givenCachedImage_callsCompletionWithImage() {
        givenExpectedImage()
        
        whenDownloadImage(image: expectedImage)
        receivedImage = nil
        
        whenDownloadImage(image: expectedImage)
        
        XCTAssertEqual(receivedImage.pngData(), expectedImage.pngData())
    }
    
    func test_setImageOnImageView_cancelsExistingDataTask() {
        let dataTask = MockURLSessionDataTask(completionHandler: { _, _, _ in }, url: url, queue: nil)
        sut.cachedTaskForImageView[imageView] = dataTask
        
        sut.setImage(on: imageView, fromURL: url, withPlaceholder: nil)
        
        XCTAssertTrue(dataTask.calledCancel)
    }
    
    func test_setImageOnImageView_setsPlaceholderOnImageView() {
        givenExpectedImage()
        
        sut.setImage(on: imageView, fromURL: url, withPlaceholder: expectedImage)
        
        XCTAssertEqual(imageView.image?.pngData(), expectedImage.pngData())
    }
    
    func test_setImageOnImageView_cachesDownloadTask() {
        sut.setImage(on: imageView, fromURL: url, withPlaceholder: nil)
        
        receivedDataTask = sut.cachedTaskForImageView[imageView] as? MockURLSessionDataTask
        XCTAssertEqual(receivedDataTask?.url, url)
    }
    
    func test_setImageOnImageView_onCompletionRemovesCachedTask() {
        whenSetImage()
        
        XCTAssertNil(sut.cachedTaskForImageView[imageView])
    }
    
    func test_setImageOnImageView_onCompletionSetsImage() {
        whenSetImage()
        
        XCTAssertEqual(imageView.image?.pngData(), expectedImage.pngData())
    }
    
    func test_setImageOnImageView_givenError_doesnSetImage() {
        givenExpectedImage()
        givenExpectedError()
        
        sut.setImage(on: imageView, fromURL: url, withPlaceholder: expectedImage)
        receivedDataTask = sut.cachedTaskForImageView[imageView] as? MockURLSessionDataTask
        receivedDataTask.completionHandler(nil, nil, expectedError)
        
        XCTAssertEqual(imageView.image?.pngData(), expectedImage.pngData())
    }
}
