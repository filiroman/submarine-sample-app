//
//  UICollectionView+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 27.02.2021.
//

import Foundation
import UIKit

extension UICollectionView {
    func setNoDataPlaceholder(_ view: UIView) {
        self.isScrollEnabled = false
        self.backgroundView = view
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
    }
}
