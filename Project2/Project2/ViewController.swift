//
//  ViewController.swift
//  Project2
//
//  Created by Jason Ngo on 2018-12-10.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: - Views
  
  @IBOutlet weak var topCountryButton: UIButton!
  @IBOutlet weak var middleCountryButton: UIButton!
  @IBOutlet weak var bottomCountryButton: UIButton!
  
  var countries: [String] = []
  var score = 0
  var correctAnswer = 0
  
  // MARK: - Override Functions
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    countries += [
      "estonia", "france", "germany", "ireland",
      "italy", "monaco", "nigeria", "poland",
      "russia", "spain", "uk", "us"
    ]
    
    topCountryButton.layer.borderWidth = 1
    topCountryButton.layer.borderColor = UIColor.lightGray.cgColor
    
    middleCountryButton.layer.borderWidth = 1
    middleCountryButton.layer.borderColor = UIColor.lightGray.cgColor
    
    bottomCountryButton.layer.borderWidth = 1
    bottomCountryButton.layer.borderColor = UIColor.lightGray.cgColor
    
    askQuestion()
  }
  
  // MARK: - IBActions
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    if sender.tag == correctAnswer {
      title = "Correct".uppercased()
      score += 1
    } else {
      title = "Incorrect".uppercased()
      score -= 1
    }
    
    displayAlertMessage()
  }
  
  // MARK: - Helper Functions
  
  fileprivate func askQuestion(action: UIAlertAction! = nil) {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    title = countries[correctAnswer].uppercased()
    
    topCountryButton.setImage(UIImage(named: countries[0]), for: .normal)
    middleCountryButton.setImage(UIImage(named: countries[1]), for: .normal)
    bottomCountryButton.setImage(UIImage(named: countries[2]), for: .normal)
  }
  
  fileprivate func displayAlertMessage() {
    let alertController = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Continue", style: .default, handler: askQuestion)
    alertController.addAction(alertAction)
    present(alertController, animated: true)
  }
  
}

