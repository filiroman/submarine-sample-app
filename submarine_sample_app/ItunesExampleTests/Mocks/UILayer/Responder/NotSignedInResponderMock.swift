//
//  NotSignedInResponderMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 21.12.2020.
//

import Foundation
@testable import ItunesExample

class NotSignedInResponderMock: NotSignedInResponder {
    
    var notSignedInCalled = false
    
    func notSignedIn() {
        notSignedInCalled = true
        NotificationCenter.default.post(name: Notification.notSignedInNotification, object: nil)
    }
}
