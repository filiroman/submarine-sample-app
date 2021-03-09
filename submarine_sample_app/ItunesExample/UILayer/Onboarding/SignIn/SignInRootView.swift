//
//  SignInRootView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SignInRootView: NiblessView {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var hierarchyNotReady = true
    var bottomLayoutConstraint: NSLayoutConstraint?
    
    let scrollView: UIScrollView = UIScrollView()
    let contentView: UIView = UIView()
    
    lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            emailInputStack,
            passwordInputStack
        ])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    lazy var emailInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailIcon, emailField])
        stack.axis = .horizontal
        return stack
    }()
    
    let emailIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.widthAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.image = UIImage(named: "emailIcon")
        imageView.tintColor = AppColors.grayTintColor
        imageView.contentMode = .center
        return imageView
    }()
    
    let emailField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "email".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.grayTintColor])
        field.backgroundColor = AppColors.background
        field.textColor = .white
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .next
        return field
    }()
    
    lazy var passwordInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [passwordIcon, passwordField])
        stack.axis = .horizontal
        return stack
    }()
    
    let passwordIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.widthAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.image = UIImage(named: "passwordIcon")
        imageView.tintColor = AppColors.grayTintColor
        imageView.contentMode = .center
        return imageView
    }()
    
    let passwordField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "password".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.grayTintColor])
        field.isSecureTextEntry = true
        field.textColor = .white
        field.backgroundColor = AppColors.background
        return field
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign In".localized, for: .normal)
        button.setTitle("", for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = AppColors.darkButtonBackground
        return button
    }()
    
    let signInActivityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let inputViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.background
        return view
    }()
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Use test/test for demo access"
        return label
    }()
    
    // MARK: - Methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = AppColors.background
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
            return
        }
        constructHierarchy()
        activateConstraints()
        configureInputViewContainer()
        configureSignInButton()
        
        hierarchyNotReady = false
    }
    
    func setupBindings(viewModel: SignInViewModel) {
        bindTextFieldsToViewModel(viewModel: viewModel)
        bindViewModelToViews(viewModel: viewModel)
        bindButtons(viewModel: viewModel)
    }
    
    func configureSignInButton() {
        signInButton.layer.cornerRadius = 10
    }
    
    func configureInputViewContainer() {
        inputViewContainer.makeShadowsAndRoundCorners(radius: 10)
    }
    
    func bindTextFieldsToViewModel(viewModel: SignInViewModel) {
        bindEmailField(viewModel: viewModel)
        bindPasswordField(viewModel: viewModel)
    }
    
    func bindViewModelToViews(viewModel: SignInViewModel) {
        bindViewModelToEmailField(viewModel: viewModel)
        bindViewModelToPasswordField(viewModel: viewModel)
        bindViewModelToSignInButton(viewModel: viewModel)
        bindViewModelToSignInActivityIndicator(viewModel: viewModel)
    }
    
    func constructHierarchy() {
        scrollView.addSubview(contentView)
        contentView.addSubview(inputViewContainer)
        contentView.addSubview(testLabel)
        inputViewContainer.addSubview(inputStack)
        inputViewContainer.addSubview(signInButton)
        signInButton.addSubview(signInActivityIndicator)
        addSubview(scrollView)
    }
    
    func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsInputView()
        activateConstraintsInputStack()
        activateConstraintsSignInButton()
        activateConstraintsSignInActivityIndicator()
        activateConstraintsTestLabel()
    }
    
    func bindButtons(viewModel: SignInViewModel) {
        signInButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
            viewModel.signIn()
        }).disposed(by: disposeBag)
    }
    
    func configureViewAfterLayout() {
        resetScrollViewContentInset()
    }
    
    func resetScrollViewContentInset() {
        let scrollViewBounds = scrollView.bounds
        let contentViewHeight = contentView.bounds.height
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height / 2.0
        scrollViewInsets.top -= contentViewHeight / 2.0
        
        scrollViewInsets.bottom = scrollViewBounds.size.height / 2.0
        scrollViewInsets.bottom -= contentViewHeight / 2.0
        
        scrollView.contentInset = scrollViewInsets
    }
    
    func moveContentForDismissedKeyboard() {
        resetScrollViewContentInset()
    }
    
    func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        var insets = scrollView.contentInset
        insets.bottom = keyboardFrame.height
        scrollView.contentInset = insets
    }
}

// MARK: - Layout
extension SignInRootView {
    
    func activateConstraintsScrollView() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func activateConstraintsContentView() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    func activateConstraintsInputView() {
        inputViewContainer.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }
    
    func activateConstraintsInputStack() {
        inputStack.snp.makeConstraints { (make) in
            make.leading.equalTo(inputViewContainer).offset(10)
            make.centerX.equalTo(inputViewContainer)
            make.top.equalTo(inputViewContainer).offset(20)
        }
    }
    
    func activateConstraintsSignInButton() {
        signInButton.snp.makeConstraints { (make) in
            make.leading.equalTo(inputViewContainer).offset(30)
            make.centerX.equalTo(inputViewContainer)
            make.top.equalTo(inputStack.snp.bottom).offset(20)
            make.bottom.equalTo(inputViewContainer.snp.bottom).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func activateConstraintsSignInActivityIndicator() {
        signInActivityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(signInButton)
            make.centerY.equalTo(signInButton)
        }
    }
    
    func activateConstraintsTestLabel() {
        testLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.leading.greaterThanOrEqualTo(contentView).offset(30)
            make.bottom.equalTo(inputViewContainer.snp.top).offset(-20)
            make.top.equalTo(contentView)
        }
    }
}

// MARK: - Bindings
extension SignInRootView {
    
    func bindViewModelToEmailField(viewModel: SignInViewModel) {
        viewModel
            .emailInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(emailField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        emailField.rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.passwordField.becomeFirstResponder()
        }).disposed(by: disposeBag)
    }
    
    func bindViewModelToPasswordField(viewModel: SignInViewModel) {
        viewModel
            .passwordInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(passwordField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToSignInButton(viewModel: SignInViewModel) {
        viewModel
            .signInButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToSignInActivityIndicator(viewModel: SignInViewModel) {
        viewModel
            .signInActivityIndicatorAnimating
            .asDriver(onErrorJustReturn: false)
            .drive(signInActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func bindEmailField(viewModel: SignInViewModel) {
        emailField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.emailInput)
            .disposed(by: disposeBag)
    }
    
    func bindPasswordField(viewModel: SignInViewModel) {
        passwordField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.passwordInput)
            .disposed(by: disposeBag)
    }
}
