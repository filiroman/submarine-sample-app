//
//  WelcomeRootView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import Foundation
import RxSwift
import UIKit

class WelcomeRootView: NiblessView {
    
    // MARK: - Properties
    var hierarchyNotReady = true
    
    let appLogoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "appLogo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 36)
        label.text = "SUBMARINE".localized
        label.textColor = AppColors.yellowThemeColor
        return label
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign In".localized, for: .normal)
        button.backgroundColor = AppColors.darkButtonBackground
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.heightAnchor
            .constraint(equalToConstant: 50)
            .isActive = true
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign Up".localized, for: .normal)
        button.backgroundColor = AppColors.background
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.heightAnchor
            .constraint(equalToConstant: 50)
            .isActive = true
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView =
            UIStackView(arrangedSubviews: [signInButton, signUpButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    init(frame: CGRect = .zero,
         viewModel: WelcomeViewModel) {
//        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = AppColors.background
        
        setupBindings(viewModel: viewModel)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
            return
        }
        constructHierarchy()
        activateConstraints()
        
        hierarchyNotReady = false
    }
    
    func setupBindings(viewModel: WelcomeViewModel) {
        signInButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
            viewModel.showSignInView()
        }).disposed(by: disposeBag)

        signUpButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
                viewModel.showSignUpView()
            }).disposed(by: disposeBag)
    }
    
    func constructHierarchy() {
        addSubview(appLogoImageView)
        addSubview(appNameLabel)
        addSubview(buttonStackView)
    }
    
    func activateConstraints() {
        activateConstraintsAppLogo()
        activateConstraintsAppNameLabel()
        activateConstraintsButtons()
    }
    
    func activateConstraintsAppLogo() {
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerY = appLogoImageView.centerYAnchor
            .constraint(equalTo: centerYAnchor, constant: -20)
        let centerX = appLogoImageView.centerXAnchor
            .constraint(equalTo: centerXAnchor)
        let leading = appLogoImageView.leadingAnchor
            .constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 50)
        NSLayoutConstraint.activate([centerY, centerX, leading])
    }
    
    func activateConstraintsAppNameLabel() {
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerX = appNameLabel.centerXAnchor
            .constraint(equalTo: appLogoImageView.centerXAnchor)
        let top = appNameLabel.topAnchor
            .constraint(equalTo: appLogoImageView.bottomAnchor, constant: 10)
        NSLayoutConstraint.activate([centerX, top])
    }
    
    func activateConstraintsButtons() {
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = buttonStackView.leadingAnchor
            .constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        let trailing = buttonStackView.trailingAnchor
            .constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        let bottom = safeAreaLayoutGuide.bottomAnchor
            .constraint(equalTo: buttonStackView.bottomAnchor, constant: 30)
        let height = buttonStackView.heightAnchor
            .constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([leading, trailing, bottom, height])
    }
}
