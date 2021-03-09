//
//  AppDelegate.swift
//  ItunesExample
//
//  Created by Roman Filippov on 18.01.2021.
//

import UIKit
import XCGLogger

var logger = XCGLogger.default

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Variables
    let injectionContainer = AppDependencyContainer()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainVC = injectionContainer.makeMainViewController()
        
        AppearanceManager.setupAppearance()
        LoggerManager.configureLogger()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = AppColors.background
        window?.makeKeyAndVisible()
        window?.rootViewController = mainVC
        
        return true
    }
}
