//
//  AlbumViewModelTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 05.03.2021.
//

import XCTest
@testable import ItunesExample

class AlbumViewModelTests: XCTestCase {
    // MARK: - Properties
    var sut: AlbumViewModelImpl!
    var imgService: ImageServiceMock!
    
    // MARK: - Tests Lifecycle
    override func setUpWithError() throws {
        imgService = ImageServiceMock()
        sut = AlbumViewModelImpl(model: AlbumMediaItemModel.testModel, imageService: imgService)
    }

    override func tearDownWithError() throws {
        imgService = nil
        sut = nil
    }
    
    // MARK: - Tests
    func testViewModel_initialized_activityIndicatorIsFalse() throws {
        let activityIndicator = try sut.searchActivityIndicatorAnimating.value()
        XCTAssertEqual(activityIndicator, false)
    }
    
    func testViewModel_initialized_returnsCorrectAlbumTitle() throws {
        let model = AlbumMediaItemModel.testModel
        XCTAssertEqual(sut.albumTitle, model.albumName)
    }
    
    func testViewModel_initialized_returnsCorrectArtistTitle() throws {
        let model = AlbumMediaItemModel.testModel
        XCTAssertEqual(sut.artistTitle, model.artistName)
    }
    
    func testViewModel_initialized_returnsCorrectAlbumID() throws {
        let model = AlbumMediaItemModel.testModel
        XCTAssertEqual(sut.albumId, model.itemID)
    }
    
    func testViewModel_initialized_returnsCorrectCoverImageURL() throws {
        let model = AlbumMediaItemModel.testModel
        XCTAssertEqual(sut.coverImageUrl, model.artworkUrl)
    }
    
    func testViewModel_getPreviewImage_modelArtworkURLNil_returnsPlaceholderImage() {
        let model = AlbumMediaItemModel.testModelWithEmptyArtworkURL
        sut = AlbumViewModelImpl(model: model, imageService: imgService)
        
        let exp = XCTestExpectation(description: "Get preview image callback")
        var returnedImage: UIImage?
        sut.getPreviewImage { (img) in
            returnedImage = img
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedImage, UIImage.placeholder)
    }
    
    func testViewModel_getPreviewImage_modelArtworkURLNotNil_callsImageService() {
        let model = AlbumMediaItemModel.testModelWithArtworkURL
        sut = AlbumViewModelImpl(model: model, imageService: imgService)
        let img = UIImage.testImage
        imgService.returnImage = img
        let exp = XCTestExpectation(description: "Get preview image callback")
        
        sut.getPreviewImage { (_) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(imgService.downloadImageCalled, true)
    }
    
    func testViewModel_getPreviewImage_returnsImage_returnsCorrectImage() {
        let model = AlbumMediaItemModel.testModelWithArtworkURL
        sut = AlbumViewModelImpl(model: model, imageService: imgService)
        let img = UIImage.testImage
        imgService.returnImage = img
        let exp = XCTestExpectation(description: "Get preview image callback")
        
        var returnedImage: UIImage?
        sut.getPreviewImage { (img) in
            returnedImage = img
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedImage, img)
    }
    
    func testViewModel_getPreviewImage_returnsError_returnsPlaceholderImage() {
        let model = AlbumMediaItemModel.testModelWithArtworkURL
        sut = AlbumViewModelImpl(model: model, imageService: imgService)
        let err = NSError.testError
        imgService.returnError = err
        let exp = XCTestExpectation(description: "Get preview image callback")
        
        var returnedImage: UIImage?
        sut.getPreviewImage { (img) in
            returnedImage = img
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedImage, UIImage.placeholder)
    }
}
