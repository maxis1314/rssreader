//
//  FeedItemViewController.swift
//  Rsswift
//
//  Created by Arled Kola on 18/11/2016.
//  Copyright © 2016 ArledKola. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Toast_Swift

class FeedItemViewController: UIViewController, UIWebViewDelegate,GADBannerViewDelegate {

    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    var selectedFeedURL: String?
    var topTitle: String?
    var indexNow:Int!

    func getNextUnread()->Int{
        if indexNow < gdb.myFeed.count-1 {
            for i in indexNow+1..<gdb.myFeed.count{
                let isRead = ddStorageGet(key: "isread_\(gdb.myFeed[i].link)", empty: "")
                if isRead == "" {
                    return i
                }
            }
        }
        return 0
        
    }
    
    func getBeforeUnread()->Int{
        if indexNow > 0  {
            for i in 0..<indexNow {
                let isRead = ddStorageGet(key: "isread_\(gdb.myFeed[indexNow-i-1].link)", empty: "")
                if isRead == "" {
                    return indexNow-i-1
                }
            }
        }
        return gdb.myFeed.count-1
    }
    
    @IBAction func leftBtnClicked(_ sender: UIButton) {
        let unreadFist = ddStorageGet(key:"unreadFist",empty:"0")
        
        if unreadFist == "1" {
            indexNow = getBeforeUnread()
        }else{
            if indexNow > 0{
                indexNow = indexNow - 1
            }else{
                indexNow = gdb.myFeed.count-1
            }
        }
        loadUrl(i:indexNow)
        refreshAd()
    }
    
    @IBAction func rightBtnClicked(_ sender: Any) {
        let unreadFist = ddStorageGet(key:"unreadFist",empty:"0")
        
        if unreadFist == "1" {
            indexNow = getNextUnread()
        }else{
            if indexNow < gdb.myFeed.count - 1  {
                indexNow = indexNow + 1
            }else{
                indexNow = 0
            }
        }
        loadUrl(i:indexNow)
        refreshAd()
    }
    
    @IBOutlet weak var myWebView: UIWebView!
    
    //Add this progress view via Interface Builder (IBOutlet) or programatically
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var myProgressView: UIProgressView!
    var theBool: Bool!
    var myTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        myWebView.delegate = self
        
        bannerView.delegate = self
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
        
        loadUrl(i:indexNow)
        refreshAd()
    }
    
    func refreshAd(){
        let adarray = ["ca-app-pub-7893551134039994/2697692057","ca-app-pub-7893551134039994/2839938491","ca-app-pub-7893551134039994/2474651576"]
        let randomIndex = Int(arc4random_uniform(UInt32(adarray.count)))
        bannerView.adUnitID = adarray[randomIndex]
        
        var gadRequest = GADRequest()
        gadRequest.testDevices = ["327e0884a77ba46e5c4fdfc9fb7c1a248ccb9080"]
        bannerView.load(gadRequest)
    }
    
    func loadUrl(i:Int){
        
        let feed = gdb.myFeed[i]
        
        navigationItem.title = "Feed Detail"//feed.title
        
        selectedFeedURL = feed.link
        
        print("001:isread_\(feed.link)")
        ddStorageSet(key: "isread_\(feed.link)", value: "1")
        print("001:\(feed.link)")
        
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: " ", with:"")
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: "\n", with:"")
        
        let timeInterval = Int(Date().timeIntervalSince1970)
        let md5str = MD5(string:"AcpxriavIkV6ejap2W58fLWUfUsaHXpI\(timeInterval)")
        if selectedFeedURL?.range(of: "eagle") != nil{
            if selectedFeedURL?.range(of: "?") != nil{
                selectedFeedURL = "\(selectedFeedURL!)&eagle_unixtime=\(timeInterval)&eagle_sign=\(md5str)"
            }else{
                selectedFeedURL = "\(selectedFeedURL!)?eagle_unixtime=\(timeInterval)&eagle_sign=\(md5str)"
            }
        }else{
            print("no eagle")
        }
        
        print(selectedFeedURL)
        
        let openLinkMode = ddStorageGet(key: "openFeedLink", empty: "1")
        
        if openLinkMode == "1" {
            myWebView.loadRequest(URLRequest(url: URL(string: selectedFeedURL! as String)!))
        }else{
            
            let font = ddStorageGet(key: "font", empty:"20")
            print(font)

            let context : [String:Any] = [
                "font" : font,
                "feed" : feed.getFeed(),
                "domain" : getIPAddressFromDNSQuery(url:feed.link)
            ]
            
            print("aaa \(feed.link) bb")
            
            print(NSURL(string: feed.link))
            
            let finalStr = render_template(file:"feed_detail",context:context)
            
            print(finalStr)

 
            //let finalStr = "<style>html{font-size: \(font)px;background-color:#C7EDCC;}</style><h3>\(feed.title)</h3><hr>\(feed.description)<a href='\(feed.link)'>[Source]</a>"

            
            myWebView.scrollView.scrollsToTop = true
            myWebView.loadHTMLString(finalStr, baseURL: Bundle.main.bundleURL)
            

            
            
        }
        
        
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("in webViewDidStartLoad")
        self.myProgressView.isHidden = false
        self.myProgressView.progress = 0.0
        self.theBool = false
        self.myTimer = Timer.scheduledTimer(timeInterval:0.01667, target: self, selector: #selector(FeedItemViewController.timerCallback), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("in webViewDidFinishLoad")
        self.theBool = true
    }
    
    func timerCallback() {
        //print("in timerCallback\(self.myProgressView.progress)")
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
    
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            let item: ItemViewController = segue.destination as! ItemViewController
            item.indexNow = indexNow
        }
    }

}
