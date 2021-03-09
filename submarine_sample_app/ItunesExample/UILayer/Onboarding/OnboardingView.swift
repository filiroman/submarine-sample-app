//
//  OnboardingView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation

public enum OnboardingView {
    
    case welcome
    case signin
    case signup
    
    public func hidesNavigationBar() -> Bool {
        switch self {
        case .welcome:
            return true
        default:
            return false
        }
    }
}
