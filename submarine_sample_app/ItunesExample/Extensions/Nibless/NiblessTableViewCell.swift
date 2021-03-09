//
//  NiblessTableViewCell.swift
//  ItunesExample
//
//  Created by Roman Filippov on 11.12.2020.
//

import UIKit

class NiblessTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable, message: "Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable, message: "Loading this view from a nib is unsupported in favor of initializer dependency injection.")
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
