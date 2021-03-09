//
//  NiblessCollectionViewCell.swift
//  ItunesExample
//
//  Created by Roman Filippov on 06.02.2021.
//

import Foundation
import UIKit

class NiblessCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
