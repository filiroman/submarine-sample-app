//
//  LaunchRootView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import Foundation
import UIKit

class LaunchRootView: NiblessView {
    
    // MARK: - Properties
    let viewModel: LaunchViewModel
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        styleView()
        loadUserSession()
    }
    
    private func styleView() {
        backgroundColor = AppColors.background
    }
    
    private func loadUserSession() {
        viewModel.loadUserSession()
    }
}
