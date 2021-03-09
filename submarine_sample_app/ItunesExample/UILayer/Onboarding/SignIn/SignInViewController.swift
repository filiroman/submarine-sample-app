//
//  SignInViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import UIKit
import RxSwift

class SignInViewController: NiblessViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel: SignInViewModel
    var signInView: SignInRootView!
    
    private var firstAppearance = true
    
    // MARK: - Methods
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
        setupNavgationItem()
    }
    
    override func loadView() {
        self.signInView = SignInRootView()
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
        hideKeyboardWhenTappedAround()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstAppearance {
            signInView.setupBindings(viewModel: viewModel)
        }
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view as? SignInRootView)?.configureViewAfterLayout()
    }
    
    func setupNavgationItem() {
        self.navigationItem.title = "Sign In".localized
    }
}

extension SignInViewController {
    
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
                (view as? SignInRootView)?.moveContentForDismissedKeyboard()
            } else {
                (view as? SignInRootView)?.moveContent(forKeyboardFrame: convertedKeyboardEndFrame)
            }
        }
    }
}

