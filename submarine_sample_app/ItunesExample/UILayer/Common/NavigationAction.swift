//
//  NavigationAction.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {
    
    case present(view: ViewModelType)
    case presented(view: ViewModelType)
}
