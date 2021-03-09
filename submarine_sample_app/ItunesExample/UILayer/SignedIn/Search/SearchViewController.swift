//
//  SearchViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: SearchViewModel
    var searchView: SearchRootView!
    
    private var firstAppearance = true
    
    let disposeBag = DisposeBag()
    // MARK: - Methods
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
        
        setupNavigationItem()
    }
    
    override public func loadView() {
        self.searchView = SearchRootView()
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        observeErrorMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstAppearance {
            searchView.setupBinding(viewModel: viewModel)
            firstAppearance = false
        }
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    func setupNavigationItem() {
        edgesForExtendedLayout = []
        navigationItem.title = "Search".localized
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

extension SearchViewController {
    
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            (view as? SearchRootView)?.moveContentForDismissedKeyboard()
        } else {
            (view as? SearchRootView)?.moveContent(forKeyboardFrame: keyboardViewEndFrame)
        }
    }
}
