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
        super.init(dbname:"mydb")
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
        var eagleList = [EagleFeed]()
        ///  判断查询对象是否为空 防止崩溃
        if (entity != nil) {
            ///  查询结果
            do{
                /// 成功
                let qwqwrr:[AnyObject]?  = try managedObjectContext.fetch(fetchRequest)
                for info:NSManagedObject in qwqwrr as![NSManagedObject] {
                    eagleList.append(info as! EagleFeed)
                }
            }catch{
                /// 失败
                fatalError("查询失败：\(error)")
            }
        }else{
            ///  查询对象不存在
            print("查询失败：查询不存在")
        }
        return eagleList
    }
    
    ///  修改数据
    func edit(title:String, url:String){
        ///修改数据
        ///先查询到要修改内容然后在修改数据
        ///  返回一个查询对象
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        ///  生成一个要查询的表的对象
        let entity = NSEntityDescription.entity(forEntityName: "EagleFeed", in: managedObjectContext)
        ///  查询对象属性
        fetchRequest.entity = entity
        ///  判断查询对象是否为空 防止崩溃
        if (entity != nil) {
            ///  查询结果
            do{
                /// 成功
                ///两种方法  0有Preson对象时和1没有的时候
                let temp:[AnyObject]  = try managedObjectContext.fetch(fetchRequest)
                //1没有对象时
                #if false
                    for info:NSManagedObject in temp as![NSManagedObject] {
                        info.setValue(title, forKey: "name")
                    }
                #else
                    //0有对象时
                    for info:EagleList in temp as![EagleList] {
                        info.name = title
                        info.url = url
                        //managedObjectContext.save(info)
                    }
                #endif
            }catch{
                /// 失败
                fatalError("修改失败：\(error)")
            }
        }else{
            ///  查询对象不存在
            print("查询失败：查询不存在")
        }
    }
    
    ///  删除数据
    func delete(name:String){
        ///删除数据
        ///先查询到要修改的内容然后删除
        ///  返回一个查询对象
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
        ///  生成一个要查询的表的对象
        let entity = NSEntityDescription.entity(forEntityName: "EagleFeed", in: managedObjectContext)
        ///  查询对象属性
        fetchRequest.entity = entity
        ///  判断查询对象是否为空 防止崩溃
        if (entity != nil) {
            ///  查询结果
            do{
                /// 成功
                ///两种方法  0有Preson对象时和1没有的时候
                let temp:[AnyObject]  = try managedObjectContext.fetch(fetchRequest)
                for info:EagleList in temp as![EagleList] {
                    if info.name == name {
                        //删除对象
                        managedObjectContext.delete(info)
                    }
                }
            }catch{
                /// 失败
                fatalError("删除失败：\(error)")
            }
        }else{
            ///  查询对象不存在
            print("查询失败：查询不存在")
        }
        ///删除成功后再次保存到本地
        saveContext()
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
