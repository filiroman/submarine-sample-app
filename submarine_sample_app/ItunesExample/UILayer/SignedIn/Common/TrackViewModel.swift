//
//  TrackViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.02.2021.
//

import Foundation
import RxSwift

protocol TrackViewModel {
    var trackTitle: String { get }
    var artistTitle: String { get }
}

class TrackViewModelImpl: TrackViewModel {
    var trackTitle: String {
        return model.trackName ?? "No title".localized
    }
    var artistTitle: String {
        return model.artistName
    }
    
    private let model: TrackMediaItemModel
    
    init (model: TrackMediaItemModel) {
        self.model = model
    }
}

extension TrackViewModelImpl: Equatable {
    static func == (lhs: TrackViewModelImpl, rhs: TrackViewModelImpl) -> Bool {
        return lhs.trackTitle == rhs.trackTitle && lhs.artistTitle == rhs.artistTitle
    }
}

