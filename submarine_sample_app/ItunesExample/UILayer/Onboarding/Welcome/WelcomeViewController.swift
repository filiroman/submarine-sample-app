//
//  WelcomeViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import Foundation
import UIKit

class WelcomeViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: WelcomeViewModel
    
    // MARK: - Methods
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = WelcomeRootView(viewModel: viewModel)
    }
}

