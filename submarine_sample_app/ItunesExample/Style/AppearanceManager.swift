//
//  AppearanceManager.swift
//  ItunesExample
//
//  Created by Roman Filippov on 18.01.2021.
//

import Foundation
import UIKit

class AppearanceManager {
    
    // MARK: - Methods
    
    public static func setupAppearance() {
        setupNavigationBarAppearance()
        setupTabBarAppearance()
    }
    
    static func setupNavigationBarAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = AppColors.background
        UINavigationBar.appearance().tintColor = AppColors.yellowThemeColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppColors.navigationBarTitleColor]
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = AppColors.yellowThemeColor
    }
    
    static func setupTabBarAppearance() {
        UITabBar.appearance().barTintColor = AppColors.background
        UITabBar.appearance().tintColor = AppColors.yellowThemeColor
    }
}
