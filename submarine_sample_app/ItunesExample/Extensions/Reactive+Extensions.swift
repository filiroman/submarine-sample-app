//
//  Reactive+Extensions.swift
//  ItunesExample
//
//  Created by Roman Filippov on 27.02.2021.
//

import Foundation
import RxSwift

extension Reactive where Base: UITableView {
    func isEmpty(view: UIView) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setNoDataPlaceholder(view)
            } else {
                tableView.removeNoDataPlaceholder()
            }
        }
    }
}

extension Reactive where Base: UICollectionView {
    func isEmpty(view: UIView) -> Binder<Bool> {
        return Binder(base) { collectionView, isEmpty in
            if isEmpty {
                collectionView.setNoDataPlaceholder(view)
            } else {
                collectionView.removeNoDataPlaceholder()
            }
        }
    }
}
