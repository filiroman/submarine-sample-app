//
//  Notification+Extensions.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 21.12.2020.
//

import Foundation

extension Notification {
    // Signing module
    static let signedInNotification = Notification.Name("signedInNotification")
    static let notSignedInNotification = Notification.Name("notSignedInNotification")
    
    // SearchViewModel
    static let fetchAlbumsCalledNotification = Notification.Name("fetchAlbumsCalledNotification")
    static let fetchTracksCalledNotification = Notification.Name("fetchTracksCalledNotification")
    static let activityIndicatorAnimatingSequenceNotification = Notification.Name("activityIndicatorAnimatingSequenceNotification")
    static let albumsSequenceNotification = Notification.Name("albumsSequenceNotification")
    static let searchIsCalledNotification = Notification.Name("searchIsCalledNotification")
}
