//
//  WelcomeViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

protocol WelcomeViewModel {
    func showSignUpView()
    func showSignInView()
}

class WelcomeViewModelImpl: WelcomeViewModel {
    
    // MARK: - Properties
    let goToSignUpNavigator: GoToSignUpNavigator
    let goToSignInNavigator: GoToSignInNavigator
    
    // MARK: - Methods
    public init(goToSignUpNavigator: GoToSignUpNavigator,
                goToSignInNavigator: GoToSignInNavigator) {
        self.goToSignUpNavigator = goToSignUpNavigator
        self.goToSignInNavigator = goToSignInNavigator
    }
    
    @objc
    func showSignUpView() {
        goToSignUpNavigator.navigateToSignUp()
    }
    
    @objc
    func showSignInView() {
        goToSignInNavigator.navigateToSignIn()
    }
}
