//
//  DetailViewController.swift
//  Project16
//
//  Created by 曲奕帆 on 2022/10/19.
//

import UIKit
import WebKit

class DetailViewController: UIViewController,
                            WKNavigationDelegate{

    var placeName: String?
    var url: URL?
    
    var webView: WKWebView!
    
    override func loadView(){
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 載入wiki網頁頁面
        loadSite()
    
    }
    
    func loadSite(){
        guard let siteUrl = url else { return }
        
        webView.load(URLRequest(url: siteUrl))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    

}
