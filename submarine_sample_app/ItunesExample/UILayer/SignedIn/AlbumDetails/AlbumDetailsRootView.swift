//
//  AlbumDetailsRootView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 23.02.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AlbumDetailsRootView: NiblessView {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var hierarchyNotReady = true
    var tracks: [TrackViewModel]? {
        didSet {
            updateEmptyViewVisibility()
            tableView.reloadData()
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(TrackCellImpl.self, forCellReuseIdentifier: TrackCellImpl.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    let tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.background
        return view
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let tintColor = UIColor.white
        refreshControl.tintColor = tintColor
        let titleAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: tintColor]
        let title = NSAttributedString(string: "Loading track list...".localized, attributes: titleAttributes)
        refreshControl.attributedTitle = title
        return refreshControl
    }()
    
    let emptyTableView: UIView = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.text = "No tracks to show...".localized
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        return messageLabel
    }()
    
    let headerView: AlbumDetailsHeaderView = {
        let view = AlbumDetailsHeaderView(frame: .zero)
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        styleView()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
            return
        }
        
        constructHierarchy()
        activateConstraints()
        configureTableView()
        configureHeaderView()
        
        hierarchyNotReady = false
    }
    
    func constructHierarchy() {
        addSubview(tableViewContainer)
        tableViewContainer.addSubview(tableView)
        addSubview(headerView)
    }
    
    func configureTableView() {
        tableView.refreshControl = refreshControl
        tableViewContainer.roundUpperCorners(radius: 10)
        tableViewContainer.makeShadows(radius: 10)
    }
    
    func configureHeaderView() {
        headerView.roundDownCorners(radius: 10)
        headerView.makeShadows(radius: 10)
    }
    
    func activateConstraints() {
        headerView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
            make.top.equalTo(self)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(tableViewContainer)
        }
        
        tableViewContainer.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(15)
            make.trailing.equalTo(self).offset(-15)
            make.bottom.equalTo(self)
            make.top.equalTo(headerView.snp.bottom).offset(25)
        }
    }
    
    func setupBinding(viewModel: AlbumDetailsViewModel) {
        headerView.configure(withViewModel: viewModel)
        bindLoadingIndicators(viewModel: viewModel)
        bindTableView(viewModel: viewModel)
    }
    
    func bindTableView(viewModel: AlbumDetailsViewModel) {
        viewModel.tracks
            .bind(to: tableView.rx.items(cellIdentifier: TrackCellImpl.identifier)) { _, model, cell in
                if let cell = cell as? TrackCell {
                    cell.configure(withViewModel: model)
                }
            }.disposed(by: disposeBag)
        
        let isEmpty = tableView.rx.isEmpty(view: emptyTableView)
        viewModel.tracks
            .map({ $0.isEmpty })
            .distinctUntilChanged()
            .bind(to: isEmpty)
            .disposed(by: disposeBag)
    }
    
    func bindLoadingIndicators(viewModel: AlbumDetailsViewModel) {
        viewModel.loadingActivityIndicatorAnimating
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                viewModel.fetchData()
            })
            .disposed(by: disposeBag)
    }
    
    func resetScrollViewContentInset() {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func moveContentForDismissedKeyboard() {
        resetScrollViewContentInset()
    }
    
    func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - safeAreaInsets.bottom, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    // MARK: - Private
    private func updateEmptyViewVisibility() {
        let num = tracks?.count ?? 0
        tableView.backgroundView?.isHidden = (num > 0)
    }
    
    private func styleView() {
        backgroundColor = AppColors.background
    }
}
