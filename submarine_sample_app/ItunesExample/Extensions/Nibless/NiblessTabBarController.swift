//
//  NiblessTabBarController.swift
//  ItunesExample
//
//  Created by Roman Filippov on 19.11.2020.
//

import UIKit

open class NiblessTabBarController: UITabBarController {

  // MARK: - Methods
  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
  }
}
