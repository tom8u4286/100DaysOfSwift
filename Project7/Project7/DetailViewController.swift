//
//  DetailViewController.swift
//  Project7
//
//  Created by 曲奕帆 on 2022/6/22.
//

import UIKit
import WebKit


class DetailViewController: UIViewController {
    var webView: WKWebView!
    // 在母頁面產生DetailView時，
    var detailItem: Petition?

    override func loadView(){
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad(){
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width", initial-scale=1>
                <style>body {font-size: 150%;} </style>
            </head>
            <body>
                \(detailItem.body)
            </body>
        </html>
        """

        webView.loadHTMLString(html,baseURL: nil)
    }
}
