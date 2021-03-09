//
//  AlbumCell.swift
//  ItunesExample
//
//  Created by Roman Filippov on 02.02.2021.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

protocol AlbumCell {
    var albumCover: UIImageView { get }
    var artistLabel: UILabel { get }
    var albumLabel: UILabel { get }
    var activityIndicator: UIActivityIndicatorView { get }
    
    func configure(withViewModel viewModel: AlbumViewModel)
    func cancelCoverLoading()
}

class AlbumCellImpl: NiblessCollectionViewCell, AlbumCell {
    
    // MARK: - Properties
    let albumCover: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = UIImage.placeholder
        return v
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
       return label
    }()
    
    let albumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var hierarchyNotReady = true
    private var viewModel: AlbumViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForReuse() {
        viewModel?.cancelCoverLoading()
        albumCover.image = UIImage.placeholder
    }
    
    func commonInit() {
        guard hierarchyNotReady else {
            return
        }
        
        backgroundColor = AppColors.background
        consructHierarchy()
    }
    
    func consructHierarchy() {
        contentView.addSubview(albumCover)
        contentView.addSubview(artistLabel)
        contentView.addSubview(albumLabel)
        contentView.addSubview(activityIndicator)
        
        activateConstraints()
        
        hierarchyNotReady = false
    }
    
    func activateConstraints() {
        activateConstraintsAlbumCover()
        activateConstraintsArtistLabel()
        activateConstraintsAlbumLabel()
        activateConstraintsActivityIndicator()
    }
    
    func activateConstraintsAlbumCover() {
        albumCover.setContentHuggingPriority(.defaultLow, for: .vertical)
        albumCover.snp.makeConstraints { (make) in
            make.leading.greaterThanOrEqualTo(contentView).offset(5)
            make.top.equalTo(contentView).offset(5)
            make.centerX.equalTo(contentView)
            make.width.equalTo(albumCover.snp.height)
            make.height.equalTo(contentView).multipliedBy(0.65)
        }
    }
    
    func activateConstraintsArtistLabel() {
        artistLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        artistLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        artistLabel.snp.makeConstraints { (make) in
            make.top.equalTo(albumCover.snp.bottom).offset(5)
            make.leading.greaterThanOrEqualTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
        }
    }
    
    func activateConstraintsAlbumLabel() {
        albumLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        albumLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        albumLabel.snp.makeConstraints { (make) in
            make.leading.greaterThanOrEqualTo(contentView).offset(10)
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-5)
            make.top.equalTo(artistLabel.snp.bottom)
        }
    }
    
    func activateConstraintsActivityIndicator() {
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.equalTo(albumCover)
            make.centerY.equalTo(albumCover)
        }
    }
    
    // MARK: - AlbumCell
    func cancelCoverLoading() {
        viewModel?.cancelCoverLoading()
    }
    
    func configure(withViewModel viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        albumLabel.text = viewModel.albumTitle
        artistLabel.text = viewModel.artistTitle
        
        viewModel.searchActivityIndicatorAnimating.subscribe(onNext: { [weak self](isAnimating) in
            if isAnimating {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        viewModel.getPreviewImage { [weak self](img) in
            self?.albumCover.image = img
        }
    }
}
