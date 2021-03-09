//
//  TrackViewModelMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
@testable import ItunesExample

class TrackViewModelMock: TrackViewModel {
    var trackTitle: String {
        return mockTrackTitle
    }
    
    var artistTitle: String {
        return mockArtistTitle
    }
    
    var mockArtistTitle: String = ""
    var mockTrackTitle: String = ""
}
