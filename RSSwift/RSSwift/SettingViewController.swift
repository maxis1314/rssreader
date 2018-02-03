//
//  SettingViewController.swift
//  EasyReader
//
//  Created by Daniel on 18/1/26.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit
import Toast_Swift
class SettingViewController: UIViewController {

    @IBAction func updateSoft(_ sender: Any) {
        
        DispatchQueue.global(qos: .default).async {
            //处理耗时操作的代码块...
            let timeResult = NSDate().timeIntervalSince1970
            
            url_to_file(url: "\(baseURL)/eagle/feed_detail.html.txt.1?t=\(timeResult)", toFile: "feed_detail.html")
            
            //操作完成，调用主线程来刷新界面
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Update", message: "Updated finished!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBOutlet weak var openLinkSwitch: UISwitch!
    @IBOutlet weak var fontLbl: UILabel!
    @IBOutlet weak var fontSlider: UISlider!
    
    @IBOutlet weak var unreadSwitch: UISwitch!
    
    
    @IBAction func unreadModeChanged(_ sender: Any) {
        if unreadSwitch.isOn {
            ddStorageSet(key:"unreadFist",value:"1")
        }else{
            ddStorageSet(key:"unreadFist",value:"0")
        }

    }
    
    
    @IBAction func openModeChanged(_ sender: Any) {
        if openLinkSwitch.isOn {
            ddStorageSet(key:"openFeedLink",value:"1")
        }else{
            ddStorageSet(key:"openFeedLink",value:"0")
        }
    }
    @IBAction func sizeChanged(_ sender: UISlider) {
        fontLbl.text = String(Int(sender.value))
        ddStorageSet(key:"font", value:fontLbl.text!)
        print(ddStorageGet(key: "font", empty: "20"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let font = ddStorageGet(key: "font", empty:"20")
        print(font)        
        fontLbl.text = font
        fontSlider.value = Float(font)!
        
        let openFeedLink = ddStorageGet(key:"openFeedLink",empty:"1")
        if openFeedLink == "1" {
            openLinkSwitch.isOn = true
        }else{
            openLinkSwitch.isOn = false
        }
        
        
        let unreadFist = ddStorageGet(key:"unreadFist",empty:"0")
        if unreadFist == "1" {
            unreadSwitch.isOn = true
        }else{
            unreadSwitch.isOn = false
        }
        
    }

 

}
