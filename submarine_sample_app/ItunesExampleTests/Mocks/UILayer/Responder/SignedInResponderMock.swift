//
//  SignedInResponderMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 21.12.2020.
//

import Foundation
@testable import ItunesExample

class SignedInResponderMock: SignedInResponder {
    
    var signedInCalled = false
    
    func signedIn(to userSession: UserSession) {
        signedInCalled = true
        NotificationCenter.default.post(name: Notification.signedInNotification, object: nil)
    }
}
