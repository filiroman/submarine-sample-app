//
//  SignUpViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import Foundation
import UIKit
import RxSwift

class SignUpViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: SignUpViewModel
    var signUpView: SignUpRootView!
    
    let disposeBag = DisposeBag()
    
    private var firstAppearance = true
    
    // MARK: - Methods
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
        setupNavgationItem()
    }
    
    override func loadView() {
        self.signUpView = SignUpRootView()
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstAppearance {
            signUpView.setupBindings(viewModel: viewModel)
        }
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view as? SignUpRootView)?.configureViewAfterLayout()
    }
    
    func observeErrorMessages() {
        viewModel
            .errorMessages
            .asDriver { _ in fatalError("Unexpected error from error messages observable.") }
            .drive(onNext: { [weak self] errorMessage in
                self?.present(errorMessage: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    func setupNavgationItem() {
        self.navigationItem.title = "Sign Up".localized
    }
}

extension SignUpViewController {
    
    func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard),
                                       name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleContentUnderKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func handleContentUnderKeyboard(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardEndFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame.cgRectValue, from: view.window)
            if notification.name == UIResponder.keyboardWillHideNotification {
                (view as? SignUpRootView)?.moveContentForDismissedKeyboard()
            } else {
                (view as? SignUpRootView)?.moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }
}
