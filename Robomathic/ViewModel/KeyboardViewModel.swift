//
//  KeyboardViewModel.swift
//  BrainCalc
//
//  Created by Aleksey Pleshkov on 22.06.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

import UIKit

final class KeyboardViewModel {
  /// Keys for keyboard list
  public let keys: [KeyModel]

  /// Actual user number
  private var userNumber: String {
    didSet {
      guard let numberBind = self.bindTrainingNumber else {
        return
      }
      numberBind(userNumber)
    }
  }

  /// Result user number
  private var userResult: Double {
    didSet {
      guard let enterBind = self.bindTrainingResult else {
        return
      }
      enterBind(userResult)
    }
  }

  /// Bind label user number
  var bindTrainingNumber: ((_ userNumber: String) -> Void)?

  /// Scoped for enter
  var bindTrainingResult: ((_ userResult: Double) -> Void)?

  init() {
    var createKeys: [KeyModel] = []
    for number in 1 ... 9 {
      createKeys.append(KeyModel(name: "\(number)", type: .number))
    }
    createKeys.append(KeyModel(name: "0", type: .number))
    createKeys.append(KeyModel(name: "-", type: .number))

    // Button cancel
    let keyCancelText = NSLocalizedString("Clean", comment: "Keyboard clean button")
    let keyCancel = KeyModel(name: keyCancelText, type: .clean, imageName: "clean")
    createKeys.append(keyCancel)

    // Button enter
    let keyEnterText = NSLocalizedString("Send", comment: "Keyboard enter button")
    let keyEnter = KeyModel(name: keyEnterText, type: .enter, imageName: "enter")
    createKeys.append(keyEnter)

    // Init variables
    keys = createKeys
    userNumber = ""
    userResult = 0
  }

  /// Touch to button
  func touchButton(_ keyModel: KeyModel) {
    switch keyModel.buttonType {
    // Clean last character in user numbers
    case .clean:
      if userNumber.count > 1 {
        userNumber.removeLast()
      } else {
        userNumber = ""
      }
    // Enter user numbers
    case .enter:
      guard let result = Double(self.userNumber) else {
        break
      }
      userNumber = ""
      userResult = result
    // Write number in user numbers
    default:
      userNumber += "\(keyModel.buttonName)"
    }
  }
}
