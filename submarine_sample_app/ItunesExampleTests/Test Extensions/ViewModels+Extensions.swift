//
//  ViewModels+Extensions.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 05.03.2021.
//

import Foundation
@testable import ItunesExample

extension AlbumViewModelImpl {
    static var testModel: AlbumViewModel {
        return AlbumViewModelMock()
    }
}
