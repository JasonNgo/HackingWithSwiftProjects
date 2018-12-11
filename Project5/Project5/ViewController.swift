//
//  ViewController.swift
//  Project5
//
//  Created by Jason Ngo on 2018-12-10.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  var allWords: [String] = []
  var usedWords: [String] = []
  
  enum ErrorType: String {
    case notPossible
    case notOriginal
    case notReal
  }
  
  // MARK: - Override Functions

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    loadFile()
    newGame()
  }
  
  // MARK: - Set up Functions
  
  fileprivate func setupTableView() {
    let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddPressed))
    navigationItem.rightBarButtonItem = addBarButton
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
  }
  
  fileprivate func loadFile() {
    guard let path = Bundle.main.path(forResource: "start", ofType: "txt") else {
      allWords += ["silkworm"]
      return
    }
    
    guard let file = try? String(contentsOfFile: path) else { return }
    allWords = file.components(separatedBy: "\n")
  }
  
  fileprivate func newGame() {
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }

  // MARK: - Selector Functions
  
  @objc func handleAddPressed() {
    let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
    ac.addTextField()
    
    let submitAction = UIAlertAction(title: "Submit", style: .default) {
      [unowned self, ac] (action) in
      
      let answer = ac.textFields![0]
      self.submit(answer: answer.text!)
    }
    
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  // MARK: - Submission Helpers
  
  fileprivate func submit(answer: String) {
    let lowercaseAnswer = answer.lowercased()
    
    guard isPossible(word: lowercaseAnswer) else {
      presentErrorMessage(of: .notPossible)
      return
    }
    
    guard isOriginal(word: lowercaseAnswer) else {
      presentErrorMessage(of: .notOriginal)
      return
    }
    
    guard isReal(word: lowercaseAnswer) else {
      presentErrorMessage(of: .notReal)
      return
    }
    
    usedWords.insert(answer, at: 0)
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }
  
  // MARK: - Verification Helpers
  
  fileprivate func isPossible(word: String) -> Bool {
    var tempWord = title!.lowercased()
    
    for letter in word {
      guard let pos = tempWord.range(of: String(letter)) else {
        return false
      }
      
      tempWord.remove(at: pos.lowerBound)
    }
    
    return true
  }
  
  fileprivate func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word)
  }
  
  fileprivate func isReal(word: String) -> Bool {
    let wordChecker = UITextChecker()
    let range = NSMakeRange(0, word.utf16.count)
    let misspelledRange = wordChecker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    return misspelledRange.location == NSNotFound
  }
  
  // MARK: - Error Helpers
  
  fileprivate func presentErrorMessage(of type: ErrorType) {
    let errorTitle: String
    let errorMessage: String
    
    switch type {
    case .notPossible:
      errorTitle = "Word is not possible"
      errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
    case .notOriginal:
      errorTitle = "Word is not original"
      errorMessage = "Be more original!"
    case .notReal:
      errorTitle = "Word not recognized"
      errorMessage = "You can't just make them up, you know!"
    }
    
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }

}

// MARK: - UITableViewDelegate

extension ViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }
  
}

