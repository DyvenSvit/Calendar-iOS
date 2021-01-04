//
//  DayViewController.swift
//  Calendar
//
//  Created by Maksym Gontar on 02.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class DayViewController: UIViewController, Storyboarded {
    
    private var webView:WKWebView!
    
    private var webViewFontSizeConfig:WebViewFontSizeConfig!
    
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var webViewContainer: UIView!
    
    
    var day:Day!
    var contentModes:[Text] = [.rule, .morning, .evening, .afterevening, .hours, .liturgy, .holiday, .quotes]
    var contentModeButtons:[UIButton] = []
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        webViewFontSizeConfig = WebViewFontSizeConfig(webView: webView)
        
        webView.scrollView.bounces = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webViewContainer.addSubview(webView)

        // You can set constant space for Left, Right, Top and Bottom Anchors
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.webViewContainer.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.webViewContainer.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.webViewContainer.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: self.webViewContainer.topAnchor),
            ])

        self.webViewContainer.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let biFontSizeUp = UIUtils.getBarItemWithImageNamed("appbar_text_size_up", action:#selector(sizeUpFontClick), target:self)!
        let biFontSizeDown = UIUtils.getBarItemWithImageNamed("appbar_text_size_down", action:#selector(sizeDownFontClick), target:self)!
        self.navigationItem.rightBarButtonItems = [biFontSizeDown, biFontSizeUp]
        self.navigationItem.leftItemsSupplementBackButton = true
                
        
        stackView.backgroundColor = UIColor("#003000")
        for contentMode in contentModes {
            let (text, image) = day.getContentButtonImage(contentMode)
            
            if let textNotNil = text, textNotNil.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 {
                let button = UIButton.init(type: .custom)
                button.tag = contentMode.rawValue
                button.setImage(image, for: .normal)
                contentModeButtons.append(button)
            }
        }
        if contentModeButtons.count > 0 {
            let btnWidth = Int(stackView.frame.size.width)/contentModeButtons.count
            for i in 0..<contentModeButtons.count {
            
                let button = contentModeButtons[i]
                button.frame = CGRect.init(x: i*btnWidth, y: 0, width: btnWidth, height: Int(stackView.frame.size.height))
                button.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin]
                button.addTarget(self, action: #selector(contentModeButtonClick(_:)), for: .touchUpInside)
                stackView.addSubview(button)
            }
            showContentMode(Text.init(rawValue: 0)!)
        }
        else {
            self.navigationItem.title = "ТЕКСТИ ВІДСУТНІ"
        }
        
        
    }
        
    @objc func sizeUpFontClick() {
        webViewFontSizeConfig.updateWithSizeUpFont()
    }
    
    @objc func sizeDownFontClick() {
        webViewFontSizeConfig.updateWithSizeDownFont()
    }
    
    @objc func contentModeButtonClick(_ sender: UIButton){
        guard let contentMode = Text.init(rawValue: sender.tag) else {
            return
        }
        showContentMode(contentMode)
    }
    
    func showContentMode(_ contentMode:Text) {

        let (text, title) = day.getContentTitleText(contentMode)
        self.navigationItem.title = title
        let textHTML = "<html><body><link href='txt.css' rel='stylesheet' type='text/css' />" +
        webViewFontSizeConfig.getViewportMetaHTML() +
        "</body>\(text!)</html>"
        let assetsPath = Bundle.main.bundleURL.appendingPathComponent("css")
        webView.loadHTMLString(textHTML, baseURL: assetsPath)
    }
}
