//
//  GradientView.swift
//  insta-helper
//
//  Created by Aleksey Pleshkov on 03.05.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
  @IBInspectable var firstColor: UIColor = UIColor.clear {
    didSet {
      updateView()
    }
  }

  @IBInspectable var secondColor: UIColor = UIColor.clear {
    didSet {
      updateView()
    }
  }

  @IBInspectable var isHorizontal: Bool = true {
    didSet {
      updateView()
    }
  }

  @IBInspectable var borderRadius: CGFloat = 0 {
    didSet {
      updateView()
    }
  }

  override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }

  func updateView() {
    guard let layer = self.layer as? CAGradientLayer else { return }

    layer.colors = [firstColor, secondColor].map { $0.cgColor }

    // Border radius
    if borderRadius > 0 {
      layer.masksToBounds = true
      layer.cornerRadius = borderRadius
    }

    // Gardient
    if isHorizontal {
      layer.startPoint = CGPoint(x: 0, y: 0.5)
      layer.endPoint = CGPoint(x: 1, y: 0.5)
    } else {
      layer.startPoint = CGPoint(x: 0.5, y: 0)
      layer.endPoint = CGPoint(x: 0.5, y: 1)
    }
  }
}
