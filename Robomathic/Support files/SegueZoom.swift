//
//  SegueZoom.swift
//  BrainCalc
//
//  Created by Aleksey Pleshkov on 27.06.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

import UIKit

class SegueZoom: UIStoryboardSegue {
  override func perform() {
    let first = source
    let second = destination

    guard let navigationController = first.navigationController else {
      return
    }

    first.view.insertSubview(second.view, aboveSubview: first.view)

    second.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    second.view.layer.opacity = 0.5

    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
      second.view.transform = CGAffineTransform.identity
      second.view.layer.opacity = 1
    }, completion: { _ in
      navigationController.pushViewController(second, animated: false)
    })
  }
}
