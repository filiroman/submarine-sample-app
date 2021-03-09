//
//  MainViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation
import RxSwift

class MainViewModel: SignedInResponder, NotSignedInResponder {
    
    // MARK: - Properties
    public var view: Observable<MainView> { return viewSubject.asObservable() }
    private let viewSubject = BehaviorSubject<MainView>(value: .launching)
    
    // MARK: - Methods
    public init() {}
    
    // MARK: - NotSignedInResponder
    public func notSignedIn() {
        viewSubject.onNext(.onboarding)
    }
    
    // MARK: - SignedInResponder
    public func signedIn(to userSession: UserSession) {
        viewSubject.onNext(.signedIn(userSession: userSession))
    }
}
