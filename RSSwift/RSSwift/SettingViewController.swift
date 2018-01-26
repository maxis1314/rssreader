//
//  SettingViewController.swift
//  EasyReader
//
//  Created by Daniel on 18/1/26.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    
    @IBOutlet weak var fontLbl: UILabel!
    @IBOutlet weak var fontSlider: UISlider!
    
    @IBAction func sizeChanged(_ sender: UISlider) {
        fontLbl.text = String(Int(sender.value))
        ddStorageSet(key:"font", value:fontLbl.text!)
        print(ddStorageGet(key: "font", empty: "20"))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var font = ddStorageGet(key: "font", empty:"20")
        print(font)        
        fontLbl.text = font
        fontSlider.value = Float(font)!
        
    }

 

}
