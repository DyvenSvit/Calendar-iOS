//
//  WebViewFontSizeConfig.swift
//  Calendar
//
//  Created by Maksym Gontar on 16.12.2019.
//  Copyright © 2019 DyvenSvit. All rights reserved.
//

import WebKit

class WebViewFontSizeConfig {
    
    let WEBVIEW_FONT_SIZE_DEFAULT = 10
    let WEBVIEW_FONT_SIZE_KEY = "settings.font.size"
    var fontSize = 10
    
    let webView:WKWebView?
    
    init(webView: WKWebView)
    {
        self.webView = webView
        if 0 == UserDefaults.standard.integer(forKey: WEBVIEW_FONT_SIZE_KEY)
        {
            UserDefaults.standard.set(fontSize, forKey: WEBVIEW_FONT_SIZE_KEY)
            UserDefaults.standard.synchronize()
        }
        fontSize = UserDefaults.standard.integer(forKey: WEBVIEW_FONT_SIZE_KEY)
    }
    
    public func updateWithFontSize()
    {
        let script = "var viewport = document.querySelector(\"meta[name=viewport]\");" +
        "viewport.setAttribute('content', 'initial-scale=\(getViewportInitialScale())');"
        webView?.evaluateJavaScript(script, completionHandler: nil)
    }
    
    public func updateWithSizeUpFont()
    {
        if(fontSize < 60)
        {
            fontSize += 1
            UserDefaults.standard.set(fontSize, forKey: WEBVIEW_FONT_SIZE_KEY)
            UserDefaults.standard.synchronize()
            updateWithFontSize()
        }
    }

    public func updateWithSizeDownFont()
    {
        if(fontSize > 10)
        {
            fontSize -= 1
            UserDefaults.standard.set(fontSize, forKey: WEBVIEW_FONT_SIZE_KEY)
            UserDefaults.standard.synchronize()
            updateWithFontSize()
        }
    }
    
    public func getViewportInitialScale() -> Float {
        return Float(fontSize)/Float(WEBVIEW_FONT_SIZE_DEFAULT)
    }
    
    public func getViewportMetaHTML() -> String {
        return "<meta name='viewport' content='initial-scale=\(getViewportInitialScale())'/>"
    }
}
