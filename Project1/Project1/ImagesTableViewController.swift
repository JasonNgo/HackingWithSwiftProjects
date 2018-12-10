//
//  ImagesTableViewController.swift
//  Project1
//
//  Created by Jason Ngo on 2018-12-09.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class ImagesTableViewController: UITableViewController {
  
  let cellID = "cellID"
  var pictures: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Storm Viewer"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    
    for item in items where item.prefix(4) == "nssl" {
      pictures.append(item)
    }
    
    print(pictures)
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pictures.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    cell.textLabel?.text = pictures[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailViewController = DetailViewController()
    let fileName = pictures[indexPath.row]
    detailViewController.selectedImage = fileName
    navigationController?.pushViewController(detailViewController, animated: true)
  }

}



