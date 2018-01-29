//
//  SettingViewController.swift
//  EasyReader
//
//  Created by Daniel on 18/1/26.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet weak var openLinkSwitch: UISwitch!
    @IBOutlet weak var fontLbl: UILabel!
    @IBOutlet weak var fontSlider: UISlider!
    
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
        
    }

 

}