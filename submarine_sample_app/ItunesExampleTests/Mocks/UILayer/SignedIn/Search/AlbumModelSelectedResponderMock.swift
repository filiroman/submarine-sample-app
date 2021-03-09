//
//  AlbumModelSelectedResponderMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
@testable import ItunesExample

class AlbumModelSelectedResponderMock: AlbumModelSelectedResponder {
    var modelSelectedCalled = false
    var modelSelected: AlbumViewModel?
    
    func modelSelected(model: AlbumViewModel) {
        modelSelectedCalled = true
        modelSelected = model
    }
}
