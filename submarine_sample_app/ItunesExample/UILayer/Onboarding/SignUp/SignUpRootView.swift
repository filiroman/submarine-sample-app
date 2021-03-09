//
//  SignUpRootView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpRootView: NiblessView {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var hierarchyNotReady = true
    
    let scrollView: UIScrollView = UIScrollView()
    let contentView: UIView = UIView()
    
    lazy var inputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            fullNameInputStack,
            emailInputStack,
            passwordInputStack
        ])
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    lazy var fullNameInputStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameIcon, fullNameField])
        stack.axis = .horizontal
        return stack
    }()
    
    let fullNameIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.heightAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.widthAnchor
            .constraint(equalToConstant: 40)
            .isActive = true
        imageView.image = UIImage(named: "userIcon")
        imageView.tintColor = AppColors.grayTintColor
        imageView.contentMode = .center
        return imageView
    }()
    
    let fullNameField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "username".localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.grayTintColor])
        field.backgroundColor = AppColors.background
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textColor = .white
        field.returnKeyType = .next
        return field
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
        field.backgroundColor = AppColors.background
        field.isSecureTextEntry = true
        field.textColor = .white
        return field
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign Up".localized, for: .normal)
        button.setTitle("", for: .disabled)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = AppColors.darkButtonBackground
        return button
    }()
    
    let signUpActivityIndicator: UIActivityIndicatorView  = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    let inputViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.background
        return view
    }()
    
    // MARK: - Methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        backgroundColor = AppColors.background
    }
    
    func setupBindings(viewModel: SignUpViewModel) {
        setupViewToViewModelBindings(viewModel: viewModel)
        setupViewModelToViewBindings(viewModel: viewModel)
        bindButtons(viewModel: viewModel)
    }
    
    func setupViewToViewModelBindings(viewModel: SignUpViewModel) {
        bindFullNameField(viewModel: viewModel)
        bindEmailField(viewModel: viewModel)
        bindPasswordField(viewModel: viewModel)
    }
    
    func setupViewModelToViewBindings(viewModel: SignUpViewModel) {
        bindViewModelToNameField(viewModel: viewModel)
        bindViewModelToEmailField(viewModel: viewModel)
        bindViewModelToPasswordField(viewModel: viewModel)
        bindViewModelToSignUpButton(viewModel: viewModel)
        bindViewModelToSignUpActivityIndicator(viewModel: viewModel)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
            return
        }
        
        constructHierarchy()
        activateConstraints()
        configureInputViewContainer()
        configureSignUpButton()
        
        hierarchyNotReady = false
    }
    
    func constructHierarchy() {
        scrollView.addSubview(contentView)
        contentView.addSubview(inputViewContainer)
        inputViewContainer.addSubview(inputStack)
        inputViewContainer.addSubview(signUpButton)
        signUpButton.addSubview(signUpActivityIndicator)
        addSubview(scrollView)
    }
    
    func activateConstraints() {
        activateConstraintsScrollView()
        activateConstraintsContentView()
        activateConstraintsInputView()
        activateConstraintsInputStack()
        activateConstraintsSignUpButton()
        activateConstraintsSignInActivityIndicator()
    }
    
    func configureViewAfterLayout() {
        resetScrollViewContentInset()
    }
    
    func configureSignUpButton() {
        signUpButton.layer.cornerRadius = 10
    }
    
    func configureInputViewContainer() {
        inputViewContainer.makeShadowsAndRoundCorners(radius: 10)
    }
    
    func resetScrollViewContentInset() {
        let scrollViewBounds = scrollView.bounds
        let contentViewHeight = CGFloat(330.0)
        
        var scrollViewInsets = UIEdgeInsets.zero
        scrollViewInsets.top = scrollViewBounds.size.height / 2.0
        scrollViewInsets.top -= contentViewHeight / 2.0
        
        scrollViewInsets.bottom = scrollViewBounds.size.height / 2.0
        scrollViewInsets.bottom -= contentViewHeight / 2.0
        
        scrollView.contentInset = scrollViewInsets
    }
    
    func activateConstraintsScrollView() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func activateConstraintsContentView() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    func activateConstraintsInputView() {
        inputViewContainer.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
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
    
    func activateConstraintsSignUpButton() {
        signUpButton.snp.makeConstraints { (make) in
            make.leading.equalTo(inputViewContainer).offset(30)
            make.centerX.equalTo(inputViewContainer)
            make.top.equalTo(inputStack.snp.bottom).offset(20)
            make.bottom.equalTo(inputViewContainer.snp.bottom).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    func activateConstraintsSignInActivityIndicator() {
        signUpActivityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(signUpButton)
            make.centerY.equalTo(signUpButton)
        }
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

// MARK: - Bindings
extension SignUpRootView {
    func bindButtons(viewModel: SignUpViewModel) {
        signUpButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
                viewModel.signUp()
            }).disposed(by: disposeBag)
    }
    
    func bindFullNameField(viewModel: SignUpViewModel) {
        fullNameField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.nameInput)
            .disposed(by: disposeBag)
    }
    
    func bindEmailField(viewModel: SignUpViewModel) {
        emailField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.emailInput)
            .disposed(by: disposeBag)
    }
    
    func bindPasswordField(viewModel: SignUpViewModel) {
        passwordField.rx.text
            .asDriver()
            .map { $0 ?? "" }
            .drive(viewModel.passwordInput)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToNameField(viewModel: SignUpViewModel) {
        viewModel
            .nameInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(fullNameField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        fullNameField.rx
            .controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.emailField.becomeFirstResponder()
            }).disposed(by: disposeBag)
    }
    
    func bindViewModelToEmailField(viewModel: SignUpViewModel) {
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
    
    func bindViewModelToPasswordField(viewModel: SignUpViewModel) {
        viewModel
            .passwordInputEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(passwordField.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToSignUpButton(viewModel: SignUpViewModel) {
        viewModel
            .signUpButtonEnabled
            .asDriver(onErrorJustReturn: true)
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func bindViewModelToSignUpActivityIndicator(viewModel: SignUpViewModel) {
        viewModel
            .signUpActivityIndicatorAnimating
            .asDriver(onErrorJustReturn: false)
            .drive(signUpActivityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
