//
//  ScoreViewModel.swift
//  BrainCalc
//
//  Created by Aleksey Pleshkov on 23.06.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

import CoreData
import Foundation

final class ScoreViewModel {
  /// Level of formula
  enum Level {
    case light
    case middle
    case hard
  }

  /// Manager for core data
  private var coreDataManager: CoreDataManager?

  /// Context for CoreData
  public var context: NSManagedObjectContext?

  // Best score user for all trainings
  public var userBestScore: Int = 0

  /// Settings for level
  private var maxNumbersInFormula: Int = 3
  private var maxCountInNumber: Int = 100
  private var maxFormulaType: Int = 2
  private var maxMultiplyNumber: Int = 10

  /// Strong level for training
  public var trainingLevel: Level = .light {
    didSet {
      switch trainingLevel {
      case .middle:
        maxNumbersInFormula = 5
        maxCountInNumber = 100
        maxFormulaType = 3
        maxMultiplyNumber = 30
      case .hard:
        maxNumbersInFormula = 7
        maxCountInNumber = 100
        maxFormulaType = 4
        maxMultiplyNumber = 30
      default:
        maxNumbersInFormula = 3
        maxCountInNumber = 100
        maxFormulaType = 2
        maxMultiplyNumber = 10
      }
    }
  }

  /// Full training score
  private var fullScore: Int = 0 {
    didSet {
      guard let trainingScore = self.bindTrainingScore else {
        return
      }
      trainingScore(fullScore, oldValue < fullScore)
    }
  }

  /// Active formula for training
  private var formulaModels: [FormulaModel] = [] {
    didSet {
      guard let trainingFormula = self.bindTrainingFormula else {
        return
      }
      var resultFormula = ""
      for item in formulaModels {
        switch item.type {
        case .plus:
          resultFormula.append(" + ")
        case .minus:
          resultFormula.append(" - ")
        case .multiply:
          resultFormula.append(" * ")
        case .divide:
          resultFormula.append(" / ")
        default:
          resultFormula.append("\(item.number)")
        }
      }
      formulaFormat = resultFormula
      trainingFormula(resultFormula)
    }
  }

  /// Format string formula
  private var formulaFormat: String = ""

  /// Bind formula with training controller
  var bindTrainingFormula: ((_ formula: String) -> Void)?

  /// Bind all score with training controller
  var bindTrainingScore: ((_ score: Int, _ success: Bool) -> Void)?

  /// Init core data
  func initCoreDataManager(context: NSManagedObjectContext) {
    coreDataManager = CoreDataManager(context: context)
    userBestScore = coreDataManager!.selectScore()
  }

  /// Generate next formula
  func nextFormula() {
    var result: [FormulaModel] = []
    var lastFormulaType: FormulaModel.FormulaType = .number
    var isNumber = true
    for _ in 1 ... maxNumbersInFormula {
      if isNumber {
        // Generate number for formula
        var number = arc4random_uniform(UInt32(maxCountInNumber))
        // Minify number if last formula type is multiply or divide
        if lastFormulaType == .multiply || lastFormulaType == .divide {
          number = arc4random_uniform(UInt32(maxMultiplyNumber))
        }
        result.append(FormulaModel(number: Int(number)))
      } else {
        // Generate arithmetic sings for formula
        let random = Int(arc4random_uniform(UInt32(maxFormulaType)))
        if let type = FormulaModel.FormulaType(rawValue: random) {
          result.append(FormulaModel(type: type))
          lastFormulaType = type
        }
      }
      isNumber = !isNumber
    }
    formulaModels = result
  }

  /// Check equals result and answer
  func checkAnswer(_ number: Double) {
    let mathExpression = NSExpression(format: formulaFormat)
    if let mathValue = mathExpression.expressionValue(with: nil, context: nil) as? Double {
      var result = Int(mathValue)
      // Revent negative sign
      if result < 0 {
        result = result * -1
      }
      if mathValue == number {
        fullScore += Int(result)

        // Update best user score
        if fullScore > userBestScore {
          if let dataManager = self.coreDataManager {
            dataManager.updateScore(score: fullScore)

            // Set result to user best score
            userBestScore = fullScore
          }
        }
      } else {
        fullScore -= Int(result)
      }
    }
  }
}
