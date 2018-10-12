//
//  DisclaimerViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 11/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit
import WebKit

class DisclaimerViewController: UIViewController, WKNavigationDelegate {
    
    var urlString: String?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bkwdBtn: UIBarButtonItem!
    @IBOutlet weak var fwdBtn: UIBarButtonItem!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    @IBAction func goBackward(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    @IBAction func openInSafari(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(webView.url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: urlString!)!))
        webView.allowsBackForwardNavigationGestures = true
        bkwdBtn.isEnabled = false
        fwdBtn.isEnabled = false
        refreshBtn.isEnabled = false
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        refreshBtn.isEnabled = false
        if webView.canGoBack{
            bkwdBtn.isEnabled = true
        }else{
            bkwdBtn.isEnabled = false
        }
        if webView.canGoForward{
            fwdBtn.isEnabled = true
        }else{
            fwdBtn.isEnabled = false
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshBtn.isEnabled = true
        if webView.canGoBack{
            bkwdBtn.isEnabled = true
        }else{
            bkwdBtn.isEnabled = false
        }
        if webView.canGoForward{
            fwdBtn.isEnabled = true
        }else{
            fwdBtn.isEnabled = false
        }
    }

}

fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
