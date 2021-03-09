//
//  ITunesNetworkServiceTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 26.01.2021.
//

import XCTest
@testable import ItunesExample

class ITunesNetworkServiceTests: XCTestCase {
    var sut: ITunesNetworkService!
    var session: MockURLSession!
    
    var exampleURL: URL {
        return URL(string: "https://example.com/")!
    }
    
    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        session = MockURLSession()
        sut = ITunesNetworkService(session: session)
    }

    override func tearDownWithError() throws {
        session = nil
        sut = nil
    }
    
    // MARK: - When
    func whenLoadRequest(data: Data? = nil, statusCode: Int = 200, error: Error? = nil, completion: @escaping(_ calledCompletion: Bool, _ response: Decodable?, _ error: Error?) -> Void) {
        
        let httpResponse = HTTPURLResponse(url: exampleURL,
                                            statusCode: statusCode,
                                            httpVersion: nil,
                                            headerFields: nil)
        let mockTask = sut.loadRequest(url: exampleURL) { (result: NetworkResult<AlbumMediaItemModel>) in
            switch result {
            case .failure(let error):
                completion(true, nil, error)
            case .success(let data):
                completion(true, data, nil)
            }
            
        } as! MockURLSessionDataTask
        
        mockTask.completionHandler(data, httpResponse, error)
    }
    
    // MARK: - Helper Methods
    
    func verifyLoadRequestDispatchedToMain(data: Data? = nil, statusCode: Int = 200, error: Error? = nil, line: UInt = #line) {
        session.givenDispatchQueue()
        
        let expectation = self.expectation(description: "Completion wasn't called")
        var thread: Thread!
        let mockTask = sut.loadRequest(url: exampleURL, parameters: [:],
                                       responseQueue: .main) { (result: NetworkResult<AlbumMediaItemModel>) in
            thread = Thread.current
            expectation.fulfill()
        } as! MockURLSessionDataTask
        let response = HTTPURLResponse(url: exampleURL,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)
        mockTask.completionHandler(data, response, error)
        
        waitForExpectations(timeout: 0.2) { (_) in
            XCTAssertTrue(thread.isMainThread)
        }
    }

    // MARK: - Tests
    func testService_initialized_setsSession() {
        XCTAssertEqual(sut.session, session)
    }
    
    func testService_loadRequest_callsExpectedURL() {
        let mockTask = sut.loadRequest(url: exampleURL) { (result: NetworkResult<AlbumMediaItemModel>) in } as! MockURLSessionDataTask
        XCTAssertEqual(mockTask.url, exampleURL)
    }
    
    func testService_loadRequest_callsResumeOnTask() {
        let mockTask = sut.loadRequest(url: exampleURL) { (result: NetworkResult<AlbumMediaItemModel>) in } as! MockURLSessionDataTask
        XCTAssertEqual(true, mockTask.calledResume)
    }
    
    func testService_givenResponseStatusCode500_callsCompletionWithError() {
        var receivedResponse: AlbumMediaItemModel?
        var receivedError: Error?
        var calledCompletion = false
        
        let exp = self.expectation(description: "Completion handler")
        whenLoadRequest(statusCode: 500) { completion, response, error in
            calledCompletion = completion
            receivedResponse = response as? AlbumMediaItemModel
            receivedError = error
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.2) { (_) in
            XCTAssertEqual(true, calledCompletion)
            XCTAssertNil(receivedResponse)
            XCTAssertNotNil(receivedError)
        }
    }
    
    func testService_givenError_callsCompletionWithError() throws {
        let expectedError = NSError(domain: "Test error", code: -1, userInfo: nil)
        var receivedResponse: AlbumMediaItemModel?
        var receivedError: Error?
        var calledCompletion = false
        
        let exp = XCTestExpectation(description: "Completion handler")
        whenLoadRequest(error: expectedError) { completion, response, error in
            calledCompletion = completion
            receivedResponse = response as? AlbumMediaItemModel
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertEqual(true, calledCompletion)
        XCTAssertNil(receivedResponse)
        let actualError = try XCTUnwrap(receivedError as NSError?)
        XCTAssertEqual(expectedError, actualError)
        
    }
    
    func testService_givenValidJSON_callsCompletionWithData() throws {
        let data = try Data.fromJSON(fileName: "MockAlbumItemModel")
        let decoder = JSONDecoder()
        let mediaItem = try decoder.decode(AlbumMediaItemModel.self, from: data)
        
        var receivedResponse: AlbumMediaItemModel?
        var receivedError: Error?
        var calledCompletion = false
        
        let exp = XCTestExpectation(description: "Completion handler")
        whenLoadRequest(data: data) { completion, response, error in
            calledCompletion = completion
            receivedResponse = response as? AlbumMediaItemModel
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertEqual(true, calledCompletion)
        XCTAssertNil(receivedError)
        XCTAssertEqual(mediaItem, receivedResponse)
    }
    
    func testService_givenInvalidJSON_callsCompletionWithError() throws {
        let data = try Data.fromJSON(fileName: "MockInvalidJSON")
        let decoder = JSONDecoder()
        var expectedError: NSError?
        do {
            _ = try decoder.decode(AlbumMediaItemModel.self, from: data)
        } catch {
            expectedError = error as NSError
        }
        
        var receivedResponse: AlbumMediaItemModel?
        var receivedError: Error?
        var calledCompletion = false
        
        let exp = XCTestExpectation(description: "Completion handler")
        whenLoadRequest(data: data) { completion, response, error in
            calledCompletion = completion
            receivedResponse = response as? AlbumMediaItemModel
            receivedError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        
        XCTAssertEqual(true, calledCompletion)
        XCTAssertNil(receivedResponse)
        
        let actualError = try XCTUnwrap(receivedError as NSError?)
        XCTAssertEqual(expectedError, actualError)
    }
    
    func testService_givenResponseStatusCode500_dispatchesToResponseQueue() {
        verifyLoadRequestDispatchedToMain(statusCode: 500)
    }
    
    func testService_givenHTTPErrorResponse_dispatchesToResponseQueue() {
        let expectedError = NSError(domain: "Test error", code: -1, userInfo: nil)
        
        verifyLoadRequestDispatchedToMain(error: expectedError)
    }
    
    func testService_givenValidJSON_dispatchesToResponseQueue() throws {
        let data = try Data.fromJSON(fileName: "MockAlbumItemModel")
        
        verifyLoadRequestDispatchedToMain(data: data)
    }
    
    func testService_givenInvalidJSON_dispatchesToResponseQueue() throws {
        let data = try Data.fromJSON(fileName: "MockInvalidJSON")
        
        verifyLoadRequestDispatchedToMain(data: data)
    }
    
    func testService_loadRequestWithParameters_callsCorrectURL() {
        let calledURL = URL(string: "https://example.com/test")!
        let calledParameters = ["param1": "val1", "param2": "val2"]
        let expectedURLs = [URL(string: "https://example.com/test?param1=val1&param2=val2"),
                            URL(string: "https://example.com/test?param2=val2&param1=val1")]
        
        let mockTask = sut.loadRequest(url: calledURL, parameters: calledParameters) { (result: NetworkResult<AlbumMediaItemModel>) in } as! MockURLSessionDataTask
        
        XCTAssertEqual(true, expectedURLs.contains(mockTask.url))
        
    }
}
