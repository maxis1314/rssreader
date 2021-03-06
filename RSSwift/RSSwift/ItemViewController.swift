//
//  ItemViewController.swift
//  RSSwift
//
//  Created by Daniel on 18/1/20.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    @IBAction func shareTextButton(_ sender: Any) {
        
        let feed = gdb.myFeed[indexNow]
        
        // text to share
        let text = "\(feed.title) \(feed.description)  \(feed.link)"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var leftBtn: UIButton!

    @IBOutlet weak var contentTxt: UITextView!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    var indexNow:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        
        /*contentTxt.backgroundColor = UIColor(
            red: CGFloat(199) / 255.0,
            green: CGFloat(237) / 255.0,
            blue: CGFloat(204) / 255.0,
            alpha: CGFloat(1.0)
        )*/
        // 字体大小
        //textView.font = UIFont.systemFont(ofSize: 13)
        // 设置字体
        //contentTxt.font = UIFont.init(name: "Georgia-Bold", size: 60)
        
        //contentTxt.textColor = UIColor.
 
        
        //contentTxt.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置页边距
        print(indexNow)
        loadUrl(i:indexNow)
    }


    func loadUrl(i:Int){
        
        let feed = gdb.myFeed[i]
        
        navigationItem.title = feed.title
        
        //contentTxt.text = feed.description ?? ""
        var font = ddStorageGet(key: "font", empty:"20")
        print(font)
        
        contentTxt.contentOffset = CGPoint.zero
        
        
        let finalStr = "<style>html{font-size: \(font)px;}</style>\(feed.description)"
        contentTxt.attributedText = finalStr.convertHtml()
  
    }

    @IBAction func leftBtnClicked(_ sender: Any) {
        if indexNow > 0{
            indexNow = indexNow - 1
        }else{
            indexNow = gdb.myFeed.count-1
        }
        loadUrl(i:indexNow)
    }

    @IBAction func rightBtnClicked(_ sender: Any) {
        if indexNow < gdb.myFeed.count - 1  {
            indexNow = indexNow + 1
        }else{
            indexNow = 0
        }
        loadUrl(i:indexNow)
    }


}
