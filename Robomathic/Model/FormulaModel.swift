//
//  FormulaModel.swift
//  BrainCalc
//
//  Created by Aleksey Pleshkov on 23.06.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

final class FormulaModel {
  let number: Int
  let type: FormulaType

  init(number: Int = 0, type: FormulaType = .number) {
    self.number = number
    self.type = type
  }

  enum FormulaType: Int {
    case plus
    case minus
    case multiply
    case divide
    case number
  }
}
