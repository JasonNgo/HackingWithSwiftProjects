//
//  ViewController.swift
//  Project4
//
//  Created by Jason Ngo on 2018-12-10.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
  
  // MARK: - Views
  
  var webView: WKWebView!
  var progressView: UIProgressView!
  var websites = ["apple.com", "hackingwithswift.com"]
  
  // MARK: - Overrides
  
  override func loadView() {
    webView = WKWebView()
    webView.navigationDelegate = self
    webView.allowsBackForwardNavigationGestures = true
    view = webView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBarButtons()
    setupToolbar()
    setupObservers()
    
    let url = URL(string: "https://" + websites[0])!
    webView.load(URLRequest(url: url))
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
      progressView.progress = Float(webView.estimatedProgress)
    }
  }
  
  // MARK: - Setup Functions
  
  fileprivate func setupBarButtons() {
    let openBarButton = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(handleOpenTapped))
    navigationItem.rightBarButtonItem = openBarButton
  }
  
  fileprivate func setupToolbar() {
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.sizeToFit()
    let progressButton = UIBarButtonItem(customView: progressView)
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    
    toolbarItems = [progressButton, spacer, refresh]
    navigationController?.isToolbarHidden = false
  }
  
  fileprivate func setupObservers() {
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
  }
  
  // MARK: - Selector Functions
  
  @objc func handleOpenTapped() {
    let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
    
    for website in websites {
      let action = UIAlertAction(title: website, style: .default, handler: openPage)
      alertController.addAction(action)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(cancelAction)
    
    alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
    present(alertController, animated: true)
  }
  
  // MARK: - Helper Functions
  
  func openPage(action: UIAlertAction) {
    let url = URL(string: "https://" + action.title!)!
    webView.load(URLRequest(url: url))
  }
  
}

// MARK: - WKNavigationDelegate

extension ViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    let url = navigationAction.request.url
    guard let host = url?.host else { return }
    
    for website in websites {
      if host.contains(website) {
        decisionHandler(.allow)
        return
      }
    }
    
    decisionHandler(.cancel)
  }
  
}

