//
//  DBManager.swift
//  RSSwift
//
//  Created by Daniel on 18/1/11.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import UIKit

import Foundation
import CoreData

class GDB{
    var myFeed=[Feed]()
}

let gdb = GDB()

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
func MD5(string: String) -> String {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }

    return digestData.map { String(format: "%02hhx", $0) }.joined()
}


func save_eagle(title:String, url:String){
    let contactIonfo = NSEntityDescription.insertNewObject(forEntityName: "EagleList", into: managedObjectContext) as! EagleList

    //两种赋值方式 如果你创建了Preson 的NSManagedObjectModel
    //那就可以用点语法调出属性否则只能用setValue赋值
    
    //点语法赋值
    contactIonfo.url = url
    contactIonfo.name = title
    
    //setValue赋值
    //contactIonfo .setValue("1", forKey: "name")
    //contactIonfo .setValue(11, forKey: "age")
    
    ///  保存到本地
    saveContext()
}

func eagle_list()->[EagleList]{
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
    ///  生成一个要查询的表的对象
    let entity = NSEntityDescription.entity(forEntityName: "EagleList", in: managedObjectContext)
    ///  查询对象属性
    fetchRequest.entity = entity
    var eagleList = [EagleList]()
    ///  判断查询对象是否为空 防止崩溃
    if (entity != nil) {
        ///  查询结果
        do{
            /// 成功
            let qwqwrr:[AnyObject]?  = try managedObjectContext.fetch(fetchRequest)
            for info:NSManagedObject in qwqwrr as![NSManagedObject] {
                eagleList.append(info as! EagleList)
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
func change_eagle(){
    ///修改数据
    ///先查询到要修改内容然后在修改数据
    ///  返回一个查询对象
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
    ///  生成一个要查询的表的对象
    let entity = NSEntityDescription.entity(forEntityName: "EagleList", in: managedObjectContext)
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
                    info.setValue("wmm", forKey: "name")
                }
            #else
                //0有对象时
                for info:EagleList in temp as![EagleList] {
                    info.name = "wmm"
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
func delete_eagle(name:String){
    ///删除数据
    ///先查询到要修改的内容然后删除
    ///  返回一个查询对象
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init()
    ///  生成一个要查询的表的对象
    let entity = NSEntityDescription.entity(forEntityName: "EagleList", in: managedObjectContext)
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






/// A thread-safe array.
public class SafeArray<Element> {
    fileprivate let queue = DispatchQueue(label: "Com.BigNerdCoding.SafeArray", attributes: .concurrent)
    fileprivate var array = [Element]()
}

// MARK: - Properties
public extension SafeArray {
    
    var first: Element? {
        var result: Element?
        queue.sync { result = self.array.first }
        return result
    }
    
    var last: Element? {
        var result: Element?
        queue.sync { result = self.array.last }
        return result
    }
    
    var count: Int {
        var result = 0
        queue.sync { result = self.array.count }
        return result
    }
    
    var isEmpty: Bool {
        var result = false
        queue.sync { result = self.array.isEmpty }
        return result
    }
    
    var description: String {
        var result = ""
        queue.sync { result = self.array.description }
        return result
    }
}

// MARK: - 读操作
public extension SafeArray {
    func first(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync { result = self.array.first(where: predicate) }
        return result
    }
    
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync { result = self.array.filter(isIncluded) }
        return result
    }
    
    func index(where predicate: (Element) -> Bool) -> Int? {
        var result: Int?
        queue.sync { result = self.array.index(where: predicate) }
        return result
    }
    
    func elementAt(at:Int) -> Element? {
        var result: Element?
        queue.sync { result = self.array[at] }
        return result
    }
    
    func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync { result = self.array.sorted(by: areInIncreasingOrder) }
        return result
    }
    
    func flatMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync { result = self.array.flatMap(transform) }
        return result
    }
    
    func forEach(_ body: (Element) -> Void) {
        queue.sync { self.array.forEach(body) }
    }
    
    func contains(where predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(where: predicate) }
        return result
    }
}

// MARK: - 写操作
public extension SafeArray {
    
    func append( _ element: Element) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }
    
    func append( _ elements: [Element]) {
        queue.async(flags: .barrier) {
            self.array += elements
        }
    }
    
    func insert( _ element: Element, at index: Int) {
        queue.async(flags: .barrier) {
            self.array.insert(element, at: index)
        }
    }
    
    func remove(at index: Int, completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let element = self.array.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }
    
    func remove(where predicate: @escaping (Element) -> Bool, completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            guard let index = self.array.index(where: predicate) else { return }
            let element = self.array.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }
    
    func removeAll(completion: (([Element]) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()
            
            DispatchQueue.main.async {
                completion?(elements)
            }
        }
    }
}

public extension SafeArray {
    
    subscript(index: Int) -> Element? {
        get {
            var result: Element?
            
            queue.sync {
                guard self.array.startIndex..<self.array.endIndex ~= index else { return }
                result = self.array[index]
            }
            
            return result
        }
        set {
            guard let newValue = newValue else { return }
            
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
    }
}


// MARK: - Equatable
public extension SafeArray where Element: Equatable {
    
    func contains(_ element: Element) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(element) }
        return result
    }
}



//json
func read_from_file(file:String) -> String{
    // File location
    let fileURLProject = Bundle.main.path(forResource: file, ofType: "json")
    // Read from the file
    var readStringProject = ""
    do {
        readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("Failed reading from URL: \(file), Error: " + error.localizedDescription)
    }
    
    return readStringProject
}

func save_to_file(file:String, text:String){
    //let file = "file.txt" //this is the file. we will write to and read from it
    //let text = "some text" //just a text

    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(file)

        //writing
        do {
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch let error as NSError {
            print("Failed save to URL: \(file), Error: " + error.localizedDescription)
        }
        

        //reading
        do {
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch let error as NSError {
            print("Failed save to URL: \(file), Error: " + error.localizedDescription)
        }
        
    }else{
        print("no dir")
    }
}



extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}


func ddStorageGet(key:String, empty:String) -> String{
    if let a = UserDefaults.standard.string(forKey: key){
        return a
    }else{
        return empty
    }
}
func ddStorageSet(key:String, value:String){
    UserDefaults.standard.set(value, forKey: key)
}
func ddStorageClear(key:String){
    UserDefaults.standard.removeObject(forKey: key)
}



// MARK: - Used to scale UIImages
extension UIImage {
    func scaleTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
