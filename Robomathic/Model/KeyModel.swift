//
//  KeyModel.swift
//  BrainCalc
//
//  Created by Aleksey Pleshkov on 22.06.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

final class KeyModel {
  let buttonName: String
  let buttonType: KeyType
  let imageName: String?

  init(name: String, type: KeyType, imageName: String? = nil) {
    buttonName = name
    buttonType = type
    self.imageName = imageName
  }

  enum KeyType {
    case number
    case clean
    case enter
  }
}
