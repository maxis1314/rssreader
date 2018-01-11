//
//  EagleList+CoreDataProperties.swift
//  RSSwift
//
//  Created by Daniel on 18/1/11.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import Foundation
import CoreData


extension EagleList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EagleList> {
        return NSFetchRequest<EagleList>(entityName: "EagleList");
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?

}
