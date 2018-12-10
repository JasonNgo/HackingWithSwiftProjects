//
//  DetailViewController.swift
//  Project1
//
//  Created by Jason Ngo on 2018-12-10.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  // MARK: - Views
  
  let photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  /// Name of file to display
  var selectedImage: String?
  
  // MARK: - Overrides
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.hidesBarsOnTap = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.hidesBarsOnTap = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = selectedImage
    navigationItem.largeTitleDisplayMode = .never
    
    view.addSubview(photoImageView)
    NSLayoutConstraint.activate([
      photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
      photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
      photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
      photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    
    if let imageToDisplay = selectedImage {
      let image = UIImage(named: imageToDisplay)
      photoImageView.image = image
    }
  }
  
  override var prefersHomeIndicatorAutoHidden: Bool {
    return navigationController?.hidesBarsOnTap ?? false
  }
  
}
