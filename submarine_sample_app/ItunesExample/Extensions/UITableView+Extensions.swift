//
//  UITableView+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 27.02.2021.
//

import Foundation
import UIKit

extension UITableView {
    func setNoDataPlaceholder(_ view: UIView) {
        self.isScrollEnabled = false
        self.backgroundView = view
        self.separatorStyle = .none
    }
    
    func removeNoDataPlaceholder() {
        self.isScrollEnabled = true
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
