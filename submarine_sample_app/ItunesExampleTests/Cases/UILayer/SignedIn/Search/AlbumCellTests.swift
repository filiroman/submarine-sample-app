//
//  AlbumCellTests.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 04.03.2021.
//

import XCTest
import RxSwift
@testable import ItunesExample

class AlbumCellTests: XCTestCase {
    var sut: AlbumCell!
    
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        sut = AlbumCellImpl()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
    }

    // MARK: - Helpers
    func mockViewModel() -> AlbumViewModelMock {
        return AlbumViewModelMock()
    }
    
    func sampleImage() -> UIImage? {
        return UIImage.testImage(withName: "sample.png")
    }
    
    // MARK: - Given
    func configureWithSampleImage() -> UIImage? {
        let vm = mockViewModel()
        let img = sampleImage()
        vm.mockPreviewImage = img
        sut.configure(withViewModel: vm)
        return img
    }
    
    // MARK: - Tests
    func testCell_initialized_activityIndicatorNotAnimating() {
        let isAnimating = sut.activityIndicator.isAnimating
        XCTAssertEqual(isAnimating, false)
    }
    
    func testCell_initialized_coverHasPlaceholderImageSet() {
        let img = sut.albumCover.image
        XCTAssertEqual(UIImage.placeholder, img)
    }
    
    func testCell_prepareForReuse_callsCancelCoverLoading() {
        let vm = mockViewModel()
        sut.configure(withViewModel: vm)
        
        guard let cell = sut as? UICollectionViewCell else {
            XCTFail()
            return
        }
        
        cell.prepareForReuse()
        XCTAssertEqual(vm.cancelCoverLoadingCalled, true)
    }
    
    func testCell_prepareForReuse_resetsCoverImage() {
        let initialImg = sut.albumCover.image
        
        _ = configureWithSampleImage()
        
        guard let cell = sut as? UICollectionViewCell else {
            XCTFail()
            return
        }
        
        cell.prepareForReuse()
        
        let img = sut.albumCover.image
        XCTAssertEqual(initialImg, img)
    }
    
    func testCell_cancelCoverLoading_callsTheMethodOnViewModel() {
        let vm = mockViewModel()
        sut.configure(withViewModel: vm)
        
        sut.cancelCoverLoading()
        XCTAssertEqual(vm.cancelCoverLoadingCalled, true)
    }
    
    func testCell_configuredWithViewModel_setsArtistTitle() {
        let vm = mockViewModel()
        vm.mockArtistTitle = "Test"
        sut.configure(withViewModel: vm)
        
        XCTAssertEqual(sut.artistLabel.text, vm.artistTitle)
    }
    
    func testCell_configuredWithViewModel_setsAlbumTitle() {
        let vm = mockViewModel()
        vm.mockAlbumTitle = "Test"
        sut.configure(withViewModel: vm)
        
        XCTAssertEqual(sut.albumLabel.text, vm.albumTitle)
    }
    
    func testCell_configuredWithViewModel_subscribesToViewModelActivityIndicator() {
        let vm = mockViewModel()
        sut.configure(withViewModel: vm)
        var returnedIsAnimating: Bool = false
        
        let exp = XCTestExpectation(description: "Activity indicator subscription expectation")
        vm.searchActivityIndicatorAnimating.subscribe(onNext: { (isAnimating) in
            returnedIsAnimating = isAnimating
            exp.fulfill()
        }).disposed(by: disposeBag)
        
        vm.searchActivityIndicatorAnimating.onNext(true)
        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(returnedIsAnimating, true)
    }
    
    func testCell_configuredWithViewModel_callsGetPreviewImage() {
        let vm = mockViewModel()
        sut.configure(withViewModel: vm)
        
        XCTAssertEqual(vm.getPreviewImageCalled, true)
    }
    
    func testCell_configuredWithViewModel_setsImageCorrectly() {
        let img = configureWithSampleImage()
        XCTAssertEqual(sut.albumCover.image, img)
    }
}
