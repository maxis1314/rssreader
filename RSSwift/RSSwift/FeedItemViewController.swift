//
//  FeedItemViewController.swift
//  Rsswift
//
//  Created by Arled Kola on 18/11/2016.
//  Copyright © 2016 ArledKola. All rights reserved.
//

import UIKit

class FeedItemViewController: UIViewController, UIWebViewDelegate {

    var selectedFeedURL: String?
    @IBOutlet var myWebView: UIWebView!
    
    //Add this progress view via Interface Builder (IBOutlet) or programatically
    
    @IBOutlet weak var myProgressView: UIProgressView!
    var theBool: Bool!
    var myTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.delegate = self
        
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: " ", with:"")
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: "\n", with:"")
        myWebView.loadRequest(URLRequest(url: URL(string: selectedFeedURL! as String)!))
        
        print(selectedFeedURL)
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("in webViewDidStartLoad")
        self.myProgressView.progress = 0.0
        self.theBool = false
        self.myTimer = Timer.scheduledTimer(timeInterval:0.01667, target: self, selector: #selector(FeedItemViewController.timerCallback), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("in webViewDidFinishLoad")
        self.theBool = true
    }
    
    func timerCallback() {
        if self.theBool! {
            if self.myProgressView.progress >= 1 {
                self.myProgressView.isHidden = true
                self.myTimer.invalidate()
            } else {
                self.myProgressView.progress += 0.1
            }
        } else {
            self.myProgressView.progress += 0.05
            if self.myProgressView.progress >= 0.95 {
                self.myProgressView.progress = 0.95
            }
        }
    }
}
