//
//  AlbumDetailsViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.02.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AlbumDetailsViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: AlbumDetailsViewModel
    var detailsView: AlbumDetailsRootView!
    
    let disposeBag = DisposeBag()
    
    private var firstAppearance: Bool = true
    // MARK: - Methods
    init(viewModel: AlbumDetailsViewModel) {
        self.viewModel = viewModel
        super.init()
        
        setupNavigationItem()
    }
    
    override public func loadView() {
        self.detailsView = AlbumDetailsRootView()
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        observeErrorMessages()
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstAppearance {
            detailsView.setupBinding(viewModel: viewModel)
        }
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    func setupNavigationItem() {
        edgesForExtendedLayout = []
        navigationItem.title = "Details".localized
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

extension AlbumDetailsViewController {
    
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
            (view as? AlbumDetailsRootView)?.moveContentForDismissedKeyboard()
        } else {
            (view as? AlbumDetailsRootView)?.moveContent(forKeyboardFrame: keyboardViewEndFrame)
        }
    }
}

