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

    @IBOutlet weak var contentTxt: UITextField!
    
    @IBOutlet weak var rightBtn: UIButton!
    
    var indexNow:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        //contentTxt.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);//设置页边距
        print(indexNow)
        loadUrl(i:indexNow)
    }


    func loadUrl(i:Int){
        
        let feed = gdb.myFeed[i]
        
        navigationItem.title = feed.title
        
        //contentTxt.text = feed.description ?? ""
        
        
        contentTxt.attributedText = feed.description.convertHtml()
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
