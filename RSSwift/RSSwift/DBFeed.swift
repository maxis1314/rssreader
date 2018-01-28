//
//  DBFeed.swift
//  EasyReader
//
//  Created by Daniel on 18/1/27.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit

//
//  DBEagle.swift
//  EasyReader
//
//  Created by Daniel on 18/1/27.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit
import CoreData
class DBFeed: DDStorage {
    
    init(){
        super.init(dbname:"feeddb",version:"3")
    }
    
    func save(title: String, link: String, pubDate: String, description:String){
        let contactIonfo = NSEntityDescription.insertNewObject(forEntityName: "EagleFeed", into: managedObjectContext) as! EagleFeed
        
        //两种赋值方式 如果你创建了Preson 的NSManagedObjectModel
        //那就可以用点语法调出属性否则只能用setValue赋值
        
        //点语法赋值
        contactIonfo.title = title
        contactIonfo.link = link
        contactIonfo.pubDate = pubDate
        contactIonfo.desc = description
        
        //setValue赋值
        //contactIonfo .setValue("1", forKey: "name")
        //contactIonfo .setValue(11, forKey: "age")
        
        ///  保存到本地
        saveContext()
    }
    
    func list()->[EagleFeed]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        ///  生成一个要查询的表的对象
        let entity = NSEntityDescription.entity(forEntityName: "EagleFeed", in: managedObjectContext)
        ///  查询对象属性
        fetchRequest.entity = entity
        var list = [EagleFeed]()
        ///  判断查询对象是否为空 防止崩溃
        if (entity != nil) {
            ///  查询结果
            do{
                /// 成功
                let qwqwrr:[AnyObject]?  = try managedObjectContext.fetch(fetchRequest)
                for info:NSManagedObject in qwqwrr as![NSManagedObject] {
                    list.append(info as! EagleFeed)
                }
            }catch{
                /// 失败
                fatalError("查询失败：\(error)")
            }
        }else{
            ///  查询对象不存在
            print("查询失败：查询不存在")
        }
        return list
    }
    

    func deleteAll() {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EagleFeed")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    
}
