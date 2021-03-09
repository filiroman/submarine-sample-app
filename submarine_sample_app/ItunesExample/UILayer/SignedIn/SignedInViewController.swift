//
//  SignedInViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation
import UIKit
import RxSwift

class SignedInViewController: NiblessViewController {
    
    // MARK: - Properties
    let searchViewController: SearchViewController
    let viewModel: SignedInViewModel
    
    let disposeBag = DisposeBag()
    
    private var rootNavigationController: UINavigationController?
    
    // Factories
    let makeDetailsViewController: (AlbumViewModel) -> AlbumDetailsViewController
    
    // MARK: - Methods
    init(viewModel: SignedInViewModel,
         searchViewController: SearchViewController,
         albumDetailsViewControllerFactory: @escaping (AlbumViewModel) -> AlbumDetailsViewController) {
        self.viewModel = viewModel
        self.searchViewController = searchViewController
        self.makeDetailsViewController = albumDetailsViewControllerFactory
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }
    
    func subscribe(to observable: Observable<SignedInView>) {
        observable
            .subscribe(onNext: { [weak self] view in
                guard let strongSelf = self else { return }
                strongSelf.present(view)
            })
            .disposed(by: disposeBag)
    }
    
    func present(_ view: SignedInView) {
        switch view {
        case .search:
            presentSearch()
        case .albumDetails(let viewModel):
            presentAlbumDetails(viewModel: viewModel)
        }
    }
    
    func presentSearch() {
        if rootNavigationController == nil {
            rootNavigationController = NiblessNavigationController(rootViewController: searchViewController)
            guard let rootNavigationController = rootNavigationController else { return }
            addFullScreen(childViewController: rootNavigationController)
        } else {
            rootNavigationController?.popToRootViewController(animated: true)
        }
    }
    
    func presentAlbumDetails(viewModel: AlbumViewModel) {
        let vc = makeDetailsViewController(viewModel)
        rootNavigationController?.pushViewController(vc, animated: true)
    }
    
    private func observeViewModel() {
        let observable = viewModel.view.distinctUntilChanged()
        subscribe(to: observable)
    }
}
