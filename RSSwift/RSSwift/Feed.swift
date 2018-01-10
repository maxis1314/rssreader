//
//  Feed.swift
//  RSSwift
//
//  Created by Daniel on 18/1/9.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import Foundation


class Feed {
    
    private var _title: String!
    private var _link: String!
    private var _pubDate: String!
    
    
    var title: String{
        return _title
        
    }
    
    var link: String{
        return _link
    }
    
    var pubDate: String{
        return _pubDate
    }
    
    init(title: String, link: String, pubDate: String){
        self._title = title
        self._link = link
        self._pubDate = pubDate
    }
 
}