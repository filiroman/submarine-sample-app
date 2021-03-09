//
//  TrackCell.swift
//  ItunesExample
//
//  Created by Roman Filippov on 27.02.2021.
//

import Foundation
import UIKit
import SnapKit

protocol TrackCell {
    var trackLabel: UILabel { get }
    
    func configure(withViewModel viewModel: TrackViewModel)
}

class TrackCellImpl: NiblessTableViewCell, TrackCell {
    
    // MARK: - Properties
    let trackLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .natural
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var hierarchyNotReady = true
    private var viewModel: TrackViewModel?
    
    // MARK: - Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func commonInit() {
        guard hierarchyNotReady else {
            return
        }
        consructHierarchy()
        styleView()
    }
    
    func styleView() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func consructHierarchy() {
        contentView.addSubview(trackLabel)
        activateConstraints()
        
        hierarchyNotReady = false
    }
    
    func activateConstraints() {
        trackLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(10)
        }
    }
    
    // MARK: - TrackCell
    
    func configure(withViewModel viewModel: TrackViewModel) {
        self.viewModel = viewModel
        trackLabel.text = viewModel.trackTitle
    }
}
