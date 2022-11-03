//
//  ViewController.swift
//  Project4
//
//  Created by 曲奕帆 on 2022/6/15.
//

import UIKit
import WebKit

class ViewController: UIViewController,
    WKNavigationDelegate{
    // 網頁視窗
    var webView: WKWebView!
    // 下載進度
    var progressView: UIProgressView!
    // 網頁URL
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView(){
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 右側設計open按鈕，觸發ActionSheet
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // bar裡的空白位置
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // 重新整理按鈕
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // 設計進度條view
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        /** 增加對webView的監聽，請它回傳載入網頁的進度給self，
         * 本Class也要follow WKNavigationDelegate，
         * 並且要將self assign 給 webView.navigationDelegate(寫在loadView中)，
         * 才可以收到通知。
         */
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // 載入網頁
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        
        // 左滑可回到上一頁
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc
    func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        // 利用迴圈增加Action按鈕
        for website in websites{
            // 增加一個動作(Action)
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
                
        // 增加一個動作
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // 此處是設計給iPad使用，將有類似彈出泡泡來顯示ActionSheet
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
        
    }
    
    /** 此function設計給AlertController的Action點選時呼叫，
     * 因此設計參數action: UIAlertAction，
     * 讓我們取得該Action所帶URL為何，
     * 供我們載入該網頁。
     */
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    /** 由於設定本Class為WKNavigationDelegate，
     * 並且也將webView.navigationDelegate = self，
     * 我們此處可以收到下載進度的事件通知。
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    /** decidePolicyFor會在webView要進行瀏覽前，被通知事件。
     * 此處我們可以透過提出request的URL，
     * 對即將前往的頁面進行控制。
     * 若該URL不在我們的websites中，則不允許前往瀏覽(decisionHandler(.cancel))。
     *
     * 教材原文：
     * https://www.hackingwithswift.com/read/4/5/refactoring-for-the-win
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites{
                if host.contains(website){
                    decisionHandler(.allow) // allow the navigation to continue
                    return
                }
            }
        }
        
        decisionHandler(.cancel) // cancel the navigation
    
    }
}

