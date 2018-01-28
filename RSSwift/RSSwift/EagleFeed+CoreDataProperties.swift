//
//  EagleFeed+CoreDataProperties.swift
//  EasyReader
//
//  Created by Daniel on 18/1/28.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import Foundation
import CoreData


extension EagleFeed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EagleFeed> {
        return NSFetchRequest<EagleFeed>(entityName: "EagleFeed");
    }

    @NSManaged public var desc: String?
    @NSManaged public var link: String?
    @NSManaged public var pubDate: String?
    @NSManaged public var title: String?
    @NSManaged public var isRead: Bool

}
