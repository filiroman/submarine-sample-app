//
//  AlbumDetailsHeaderView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class AlbumDetailsHeaderView: NiblessView {
    
    // MARK: - Properties
    let coverImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage.placeholder
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let coverImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.background
        return view
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let albumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var hierarchyNotReady = true
    private let disposeBag = DisposeBag()
    private weak var viewModel: AlbumDetailsViewModel?
    
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
        
        constructHierarchy()
        activateConstraints()
        configureCoverImage()
        
        hierarchyNotReady = false
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            viewModel?.cancelCoverLoading()
        }
    }
    
    func configureCoverImage() {
        coverImageContainer.makeShadowsAndRoundCorners(radius: 10)
    }
    
    func constructHierarchy() {
        addSubview(coverImageContainer)
        coverImageContainer.addSubview(coverImage)
        coverImageContainer.addSubview(activityIndicator)
        
        addSubview(artistLabel)
        addSubview(albumLabel)
        
    }
    
    func activateConstraints() {
        coverImage.snp.makeConstraints { (make) in
            make.edges.equalTo(coverImageContainer)
        }
        
        coverImageContainer.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.3)
            make.top.equalTo(self).offset(10)
            make.width.equalTo(coverImageContainer.snp.height)
        }
        
        artistLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.leading.greaterThanOrEqualTo(self).offset(20)
            make.top.equalTo(coverImageContainer.snp.bottom).offset(5)
        }
        
        albumLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.leading.greaterThanOrEqualTo(self).offset(20)
            make.top.equalTo(artistLabel.snp.bottom).offset(5)
            make.bottom.equalTo(self).offset(-10)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(coverImageContainer)
            make.centerY.equalTo(coverImageContainer)
        }
    }
    
    func configure(withViewModel viewModel: AlbumDetailsViewModel) {
        albumLabel.text = viewModel.albumTitle
        artistLabel.text = viewModel.artistTitle
        
        viewModel.imageLoadingActivityIndicatorAnimating.subscribe(onNext: { [weak self](isAnimating) in
            if isAnimating {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        viewModel.getCoverImage { [weak self](img) in
            self?.coverImage.image = img
        }
        
        self.viewModel = viewModel
    }
    
    private func styleView() {
        backgroundColor = AppColors.background
    }
}
