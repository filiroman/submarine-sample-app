//
//  MainViewController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.01.2021.
//

import UIKit
import RxSwift

class MainViewController: NiblessViewController {
    
    // MARK: - Properties
    let viewModel: MainViewModel
    
    // Child View Controllers
    let launchViewController: LaunchViewController
    var signedInViewController: SignedInViewController?
    var onboardingViewController: OnboardingViewController?
    
    let disposeBag = DisposeBag()
    
    // Factories
    let makeOnboardingViewController: () -> OnboardingViewController
    let makeSignedInViewController: (UserSession) -> SignedInViewController
    
    // MARK: - Methods
    public init(viewModel: MainViewModel,
                launchViewController: LaunchViewController,
                onboardingViewControllerFactory: @escaping () -> OnboardingViewController,
                signedInViewControllerFactory: @escaping (UserSession) -> SignedInViewController) {
        self.viewModel = viewModel
        self.launchViewController = launchViewController
        self.makeOnboardingViewController = onboardingViewControllerFactory
        self.makeSignedInViewController = signedInViewControllerFactory
        super.init()
    }
    
    func subscribe(to observable: Observable<MainView>) {
        observable
            .subscribe(onNext: { [weak self] view in
                guard let strongSelf = self else { return }
                strongSelf.present(view)
            })
            .disposed(by: disposeBag)
    }
    
    public func present(_ view: MainView) {
        switch view {
        case .launching:
            presentLaunching()
        case .onboarding:
            if onboardingViewController?.presentingViewController == nil {
                if presentedViewController != nil {
                    // Dismiss profile modal when signing out.
                    dismiss(animated: true) { [weak self] in
                        self?.presentOnboarding()
                    }
                } else {
                    presentOnboarding()
                }
            }
        case .signedIn(let userSession):
            presentSignedIn(userSession: userSession)
        }
    }
    
    public func presentLaunching() {
        addFullScreen(childViewController: launchViewController)
    }
    
    public func presentOnboarding() {
        let onboardingViewController = makeOnboardingViewController()
        
        if #available(iOS 13, *) {
            onboardingViewController.modalPresentationStyle = .fullScreen
        }
        
        present(onboardingViewController, animated: true) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.remove(childViewController: strongSelf.launchViewController)
            if let signedInViewController = strongSelf.signedInViewController {
                strongSelf.remove(childViewController: signedInViewController)
                strongSelf.signedInViewController = nil
            }
        }
        self.onboardingViewController = onboardingViewController
    }
    
    public func presentSignedIn(userSession: UserSession) {
        remove(childViewController: launchViewController)
        
        let signedInViewControllerToPresent: SignedInViewController
        if let vc = self.signedInViewController {
            signedInViewControllerToPresent = vc
        } else {
            signedInViewControllerToPresent = makeSignedInViewController(userSession)
            self.signedInViewController = signedInViewControllerToPresent
        }
        
        addFullScreen(childViewController: signedInViewControllerToPresent)
        
        if onboardingViewController?.presentingViewController != nil {
            onboardingViewController = nil
            dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModel()
    }
    
    private func observeViewModel() {
        let observable = viewModel.view.distinctUntilChanged()
        subscribe(to: observable)
    }
}

