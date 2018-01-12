//
//  AddEagleViewController.swift
//  RSSwift
//
//  Created by Daniel on 18/1/12.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit

class AddEagleViewController: UIViewController {

    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var urlTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.title = "ADD"

        // Do any additional setup after loading the view.
    }

    @IBAction func saveEagle(_ sender: Any) {
        print(1)
        if nameTxt.text != "" && urlTxt.text != "" {
            save_eagle(title:nameTxt.text!,url:urlTxt.text!)
            
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
            
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"MyNotification"),
                    object: nil,
                    userInfo: ["message":"Hello there!", "date":Date()])
            
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please input the right value!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    

}
