//
//  UIRefreshControl+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 04.03.2021.
//

import Foundation
import UIKit

extension UIRefreshControl {
    func beginRefreshingManually() {
        if let scrollView = self.superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height), animated: true)
        }
        self.beginRefreshing()
    }
}
