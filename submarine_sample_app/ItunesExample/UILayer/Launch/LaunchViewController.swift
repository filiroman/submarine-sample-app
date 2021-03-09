//
//  LaunchViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//  
//

import UIKit
import Foundation
import RxCocoa
import RxSwift

class LaunchViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: LaunchViewModel
    let disposeBag = DisposeBag()
    
    // MARK: - Methods
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = LaunchRootView(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
    }
    
    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.present(errorMessage: errorMessage,
                                   withPresentationState: strongSelf.viewModel.errorPresentation)
            })
            .disposed(by: disposeBag)
    }
}
