//
//  SearchRootView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 30.01.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchRootView: NiblessView {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    var hierarchyNotReady = true

    let emptyCollectionView: UIView = {
        let messageLabel = UILabel(frame: .zero)
        messageLabel.text = "Nothing to show...".localized
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 1
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.sizeToFit()
        return messageLabel
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = AppColors.background
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(AlbumCellImpl.self, forCellWithReuseIdentifier: AlbumCellImpl.identifier)
        return collectionView
    }()
    
    let searchBar: UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search Albums".localized
        s.barStyle = .blackTranslucent
        s.barTintColor = AppColors.background
        s.returnKeyType = .done
        s.enablesReturnKeyAutomatically = true
        s.sizeToFit()
        return s
    }()
    
    // MARK: - Methods
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        styleView()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard hierarchyNotReady else {
            return
        }
        backgroundColor = AppColors.background
        
        constructHierarchy()
        activateConstraints()
        configureCollectionView()
        
        hierarchyNotReady = false
    }
    
    func constructHierarchy() {
        addSubview(searchBar)
        addSubview(collectionView)
        
        searchBar.delegate = self
    }
    
    func configureCollectionView() {
        collectionView.refreshControl = refreshControl
    }
    
    func activateConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
    
    func setupBinding(viewModel: SearchViewModel) {
        bindLoadingIndicators(viewModel: viewModel)
        bindSearchBar(viewModel: viewModel)
        bindCollectionView(viewModel: viewModel)
    }
    
    func bindCollectionView(viewModel: SearchViewModel) {
        viewModel.albums
            .bind(to: collectionView.rx.items(cellIdentifier: AlbumCellImpl.identifier)) { [weak self] _, model, cell in
            if let cell = cell as? AlbumCell {
                cell.configure(withViewModel: model)
            }
            self?.styleCell(cell)
        }.disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(AlbumViewModel.self)
            .subscribe(onNext: { (model) in
                viewModel.modelSelected(model: model)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .didEndDisplayingCell
            .subscribe(onNext: { cell, _ in
                (cell as? AlbumCell)?.cancelCoverLoading()
            }).disposed(by: disposeBag)
        
        let isEmpty = collectionView.rx.isEmpty(view: emptyCollectionView)
        viewModel.albums
            .map({ $0.isEmpty })
            .distinctUntilChanged()
            .bind(to: isEmpty)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func bindLoadingIndicators(viewModel: SearchViewModel) {
        viewModel.searchActivityIndicatorAnimating.subscribe(onNext: { [weak self] (isAnimating) in
            if isAnimating {
                self?.refreshControl.beginRefreshingManually()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let query = self?.searchBar.text else { return }
                viewModel.search(query: query)
            })
            .disposed(by: disposeBag)
    }
    
    func bindSearchBar(viewModel: SearchViewModel) {

        let searchBarTextDriver: Driver<String> = searchBar.rx
            .text
            .orEmpty
            .asDriver()
        
        searchBarTextDriver
            .distinctUntilChanged()
            .debounce(.milliseconds(500))
            .drive(viewModel.searchInput)
            .disposed(by: disposeBag)
    }
    
    func resetScrollViewContentInset() {
        collectionView.contentInset = .zero
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    func moveContentForDismissedKeyboard() {
        resetScrollViewContentInset()
    }
    
    func moveContent(forKeyboardFrame keyboardFrame: CGRect) {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - safeAreaInsets.bottom, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    // MARK: - Private
    private func styleView() {
        backgroundColor = AppColors.background
    }
    
    private func styleCell(_ cell: UICollectionViewCell) {
        cell.makeCellShadows(radius: 10)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchRootView: UICollectionViewDelegateFlowLayout {
    var itemSize: CGFloat {
        return bounds.width/2 - 30
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = itemSize
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let numberOfItems = Int(bounds.width) / Int(itemSize)
        let freeSpace = bounds.width - itemSize * CGFloat(numberOfItems)
        let hSpace = freeSpace / 3
        return UIEdgeInsets(top: hSpace, left: hSpace, bottom: hSpace, right: hSpace)
    }
}

extension SearchRootView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
