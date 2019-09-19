//
//  TrainingController.swift
//  BrainCalc
//
//  Created by Aleksey Pleshkov on 22.06.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

import CoreData
import UIKit

final class TrainingController: UIViewController {
  /// Training level for formula
  public var trainingLevel: ScoreViewModel.Level?

  /// Delay for cell's animation
  private var delayLastAnimationCell: Double = 0

  /// View model for keyboard
  private let keyboardViewModel = KeyboardViewModel()

  /// View model for score training
  private let scoreViewModel = ScoreViewModel()

  /// UI's
  @IBOutlet var labelFormula: UILabel!
  @IBOutlet var labelUserNumber: UILabel!
  @IBOutlet var labelUserScore: UILabel!
  @IBOutlet var viewAnswerBackground: UIView!

  /// Stop game and back to root controller
  @IBAction func buttonEndGame(_: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }

  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    guard let id = segue.identifier else {
      return
    }

    // Send best score to end controller
    if id == "EndTraining", let endController = segue.destination as? EndController {
      endController.bestScore = scoreViewModel.userBestScore
    }
  }

  /// Configure controller
  private func configure() {
    // Bind number label with keyboard
    keyboardViewModel.bindTrainingNumber = { number in
      self.labelUserNumber.text = number
    }

    // Bind enter in keyboard
    keyboardViewModel.bindTrainingResult = { result in
      self.scoreViewModel.checkAnswer(result)
      self.scoreViewModel.nextFormula()
    }

    // Bind formula
    scoreViewModel.bindTrainingFormula = { formula in
      // Animate label and set result
      self.labelFormula.animateFadeOut(duration: 0.3, completion: {
        self.labelFormula.text = formula
        self.labelFormula.animateFadeIn(duration: 0.3)
      })
    }

    // Bind score
    scoreViewModel.bindTrainingScore = { score, success in
      // Animate label and set result
      self.labelUserScore.animateFadeOut(duration: 0.5, completion: {
        self.labelUserScore.text = "\(score)"
        self.labelUserScore.animateFadeIn(duration: 0.5)
      })

      // Indicate success answer or not
      let colorStart = self.viewAnswerBackground.backgroundColor ?? UIColor.white
      let colorSuccess = UIColor.green
      let colorError = UIColor.red
      if success {
        self.viewAnswerBackground.animateBackgroundColor(colorStart: colorStart, colorEnd: colorSuccess, duration: 0.5)
      } else {
        self.viewAnswerBackground.animateBackgroundColor(colorStart: colorStart, colorEnd: colorError, duration: 0.5)
      }

      if score < 0 {
        self.performSegue(withIdentifier: "EndTraining", sender: self)
      }
    }

    // Set level and create new formula
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      let context = appDelegate.persistentContainer.viewContext

      scoreViewModel.trainingLevel = trainingLevel ?? .light
      scoreViewModel.initCoreDataManager(context: context)
      scoreViewModel.nextFormula()
    }
  }
}

extension TrainingController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  /// Count of collection view
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return keyboardViewModel.keys.count
  }

  /// Creating cells collection view
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let keyModel = keyboardViewModel.keys[indexPath.row]

    if keyModel.buttonType == .number {
      // If button is number
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardNumberCell", for: indexPath)

      if let keyboardCell = cell as? KeyboardNumberCell {
        keyboardCell.labelNumber.text = keyModel.buttonName
      }

      // Animate cell
      cell.animateFadeInDown(duration: 0.2, delay: delayLastAnimationCell)
      delayLastAnimationCell += 0.1

      return cell
    } else {
      // If button is function
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyboardFuncCell", for: indexPath)

      if let keyboardCell = cell as? KeyboardFuncCell {
        keyboardCell.labelName.text = keyModel.buttonName
        if let imageName: String = keyModel.imageName {
          keyboardCell.imageIcon.image = UIImage(named: imageName)
        }

        // Animate cell
        keyboardCell.animateFadeInDown(duration: 0.2, delay: delayLastAnimationCell)
        delayLastAnimationCell += 0.1
      }

      return cell
    }
  }

  /// Touch to collection cell
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let keyModel = keyboardViewModel.keys[indexPath.row]

    // Animate cell
    if let cell = collectionView.cellForItem(at: indexPath) {
      cell.animateScaleOut(duration: 0.2, completion: {
        cell.animateScaleIn(duration: 0.2)
      })
    }

    keyboardViewModel.touchButton(keyModel)
  }

  /// Size collection view
  func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
    let bounds = collectionView.bounds
    let width = bounds.width / CGFloat(5) - CGFloat(5)
    return CGSize(width: width, height: width)
  }
}
