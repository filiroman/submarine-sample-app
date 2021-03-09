//
//  NiblessView.swift
//  ItunesExample
//
//  Created by Roman Filippov on 10.11.2020.
//

import UIKit

open class NiblessView: UIView {

  // MARK: - Methods
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable, message: "Loading this view from a nib is unsupported in favor of initializer dependency injection.")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
  }
}
