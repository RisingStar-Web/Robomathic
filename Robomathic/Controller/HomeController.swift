//
//  ViewController.swift
//  BrainCalc
//
//  Created by Aleksey Pleshkov on 18.06.2018.
//  Copyright © 2018 Aleksey Pleshkov. All rights reserved.
//

import UIKit

final class HomeController: UIViewController {
  @IBOutlet var buttonLight: UIButton!
  @IBOutlet var buttonMiddle: UIButton!
  @IBOutlet var buttonHard: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    localizationButtons()
    animateStart()
  }

  override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
    guard let id = segue.identifier else {
      return
    }
    guard let trainingController = segue.destination as? TrainingController else {
      return
    }

    // Set level to training
    switch id {
    case "LevelMiddle":
      trainingController.trainingLevel = .middle
    case "LevelHard":
      trainingController.trainingLevel = .hard
    default:
      trainingController.trainingLevel = .light
    }
  }

  /// Localization buttons
  private func localizationButtons() {
    // Text for light button
    if let attributedTitle = self.buttonLight.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      let title = NSLocalizedString("Ease", comment: "Button level training")
      mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: title)
      buttonLight.setAttributedTitle(mutableAttributedTitle, for: .normal)
    }

    // Text for middle button
    if let attributedTitle = self.buttonMiddle.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      let title = NSLocalizedString("Medium", comment: "Button level training")
      mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: title)
      buttonMiddle.setAttributedTitle(mutableAttributedTitle, for: .normal)
    }

    // Text for hard button
    if let attributedTitle = self.buttonHard.attributedTitle(for: .normal) {
      let mutableAttributedTitle = NSMutableAttributedString(attributedString: attributedTitle)
      let title = NSLocalizedString("Hard", comment: "Button level training")
      mutableAttributedTitle.replaceCharacters(in: NSMakeRange(0, mutableAttributedTitle.length), with: title)
      buttonHard.setAttributedTitle(mutableAttributedTitle, for: .normal)
    }
  }

  /// Start animate for level buttons
  private func animateStart() {
    buttonLight.animateFadeInDown(duration: 0.5, delay: 0)
    buttonMiddle.animateFadeInDown(duration: 0.5, delay: 0.3)
    buttonHard.animateFadeInDown(duration: 0.5, delay: 0.6)
  }
}
