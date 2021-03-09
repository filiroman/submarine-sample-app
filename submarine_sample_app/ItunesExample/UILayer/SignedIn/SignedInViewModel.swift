//
//  SignedInViewModel.swift
//  ItunesExample
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
import RxSwift

class SignedInViewModel: AlbumModelSelectedResponder {
    
    // MARK: - Properties
    public var view: Observable<SignedInView> { return viewSubject.asObservable() }
    private let viewSubject = BehaviorSubject<SignedInView>(value: .search)
    
    private let userSession: UserSession
    
    // MARK: - Methods
    public init(userSession: UserSession) {
        self.userSession = userSession
    }
    
    // MARK: - AlbumModelSelectedResponder
    func modelSelected(model: AlbumViewModel) {
        viewSubject.onNext(.albumDetails(model: model))
    }
}
