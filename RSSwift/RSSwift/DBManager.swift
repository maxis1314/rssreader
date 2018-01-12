//
//  DBManager.swift
//  RSSwift
//
//  Created by Daniel on 18/1/11.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import Foundation

import Foundation
import CoreData

/// 被管理的数据上下文   初始化的后，必须设置持久化存储助理
var managedObjectContext: NSManagedObjectContext = {
    
    let coordinator = persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
}()

/// 持久化存储助理 初始化必须依赖NSManagedObjectModel，之后要指定持久化存储的数据类型，默认的是NSSQLiteStoreType，即SQLite数据库；并指定存储路径为Documents目录下，以及数据库名称
var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
    let url = applicationDocumentsDirectory.appendingPathComponent("CoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch {
        var dict = [String: AnyObject]()
        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
        dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
        
        dict[NSUnderlyingErrorKey] = error as NSError
        let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
        
        NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        abort()
    }
    
    return coordinator
}()


/// Documents目录路径
var applicationDocumentsDirectory: NSURL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1] as NSURL
}()


/// 被管理的数据模型  初始化必须依赖.momd文件路径，而.momd文件由.xcdatamodeld文件编译而来
var managedObjectModel: NSManagedObjectModel = {
    print(Bundle.main)//CoreData
    let modelURL = Bundle.main.url(forResource: "mydb", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
}()

///  保存数据到持久层
func saveContext () {
    if managedObjectContext.hasChanges {
        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}

/*let md5Data = MD5(string:"Hello")
let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
print("md5Hex: \(md5Hex)")
let md5Base64 = md5Data.base64EncodedString()
print("md5Base64: \(md5Base64)")*/
func MD5(string: String) -> Data {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }

    return digestData
}


