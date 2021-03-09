//
//  GoToSignInNavigatorMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 24.01.2021.
//

@testable import ItunesExample

class GoToSignInNavigatorMock: GoToSignInNavigator {
    var navigateToSignInCalled = false
    
    func navigateToSignIn() {
        navigateToSignInCalled = true
    }
}
