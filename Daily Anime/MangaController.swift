//
//  MangaController.swift
//  AlderNews
//
//  Created by Siddhesvar Kannan on 8/23/20.
//  Copyright © 2020 Siddhesvar Kannan. All rights reserved.
//

import UIKit
import WebKit

class MangaController: UIViewController {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "MAL"
        //let url = URL(string: "https://mangadex.org/")!
        let url = URL(string: "https://myanimelist.net/")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

}
