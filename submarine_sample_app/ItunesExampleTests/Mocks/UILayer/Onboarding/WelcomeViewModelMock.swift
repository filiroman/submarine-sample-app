//
//  WelcomeViewModelMock.swift
//  ItunesExampleTests
//
//  Created by Roman Filippov on 06.03.2021.
//

import Foundation
@testable import ItunesExample

class WelcomeViewModelMock: WelcomeViewModel {
    var showSignUpCalled = false
    var showSignInCalled = false
    
    func showSignUpView() {
        showSignUpCalled = true
    }
    
    func showSignInView() {
        showSignInCalled = true
    }
    
    
}
