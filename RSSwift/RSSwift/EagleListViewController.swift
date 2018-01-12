//
//  EagleListViewController.swift
//  RSSwift
//
//  Created by Daniel on 18/1/12.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit

class EagleListViewController: UITableViewController {
    var eagleList = [EagleList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"MyNotification"),
                       object:nil, queue:nil,
                       using:catchNotification)
        
        tableView.allowsMultipleSelectionDuringEditing = false;
        
        
        
        eagleList = eagle_list()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.title = "Feeds"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String,
            let date     = userInfo["date"]    as? Date else {
                print("No userInfo found in notification")
                return
        }
        

        
        eagleList = eagle_list()
        tableView.reloadData()
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eagleList.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var eagle:EagleList!
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)
        
 
        eagle=eagleList[indexPath.row]
  
        
        
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        //if indexPath.row % 2 == 0 {
            //cell.backgroundColor = UIColorFromRGB(rgbValue: 0xDCDCDC)
        //} else {
            cell.backgroundColor = UIColor.white//(white: 1, alpha: 0.3)
        //}
        
        cell.textLabel?.text = eagle.name
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        cell.detailTextLabel?.text = eagle.url
        cell.detailTextLabel?.textColor = UIColor.black
        
        return cell
    }

    

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let eagle = eagleList[indexPath.row]
            delete_eagle(name:eagle.name!)
            // Delete the row from the data source
            eagleList.remove(at: indexPath.row)
            
            print("in delete")
            print(eagle)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
             //["cats", "dogs", "moose"]
            print("delete \(indexPath.row)")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
 


}
