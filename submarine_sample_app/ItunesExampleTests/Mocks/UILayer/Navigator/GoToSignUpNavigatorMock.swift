//
//  GoToSignUpNavigatorMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

import Foundation
@testable import ItunesExample

class GoToSignUpNavigatorMock: GoToSignUpNavigator {
    var navigateToSignUpCalled = false
    
    func navigateToSignUp() {
        navigateToSignUpCalled = true
    }
}
