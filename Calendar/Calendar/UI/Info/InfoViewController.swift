//
//  InfoViewController.swift
//  Calendar
//
//  Created by Maksym Gontar on 05.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController, Storyboarded {

    private var webView:WKWebView!
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        webView.scrollView.bounces = true
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        // You can set constant space for Left, Right, Top and Bottom Anchors
                            NSLayoutConstraint.activate([
                                self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                self.webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                ])
        
        self.view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Інфо"
        
        let url = Bundle.main.bundleURL.appendingPathComponent("about.html")
        var text = try? String.init(contentsOf: url)
        if let majorVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let minorVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            text = text?.replacingOccurrences(of: "{version}", with: "\(majorVersion).\(minorVersion)")
        }
        let textHTML = "<html><body><link href='ds.css' rel='stylesheet' type='text/css' /><meta name='viewport' content='initial-scale=1'/></body>\(text!)</html>"
        let assetsPath = Bundle.main.bundleURL.appendingPathComponent("css")
        webView.loadHTMLString(textHTML, baseURL: assetsPath)
    }
}

extension InfoViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               UIApplication.shared.canOpenURL(url) {
                Router.openURL(url)
                decisionHandler(.cancel)
            } else {
                // Open it locally
                decisionHandler(.allow)
            }
        } else {
            // Not a user click
            decisionHandler(.allow)
        }
    }
}
