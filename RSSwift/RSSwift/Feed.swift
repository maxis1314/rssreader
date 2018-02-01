//
//  Feed.swift
//  RSSwift
//
//  Created by Daniel on 18/1/9.
//  Copyright © 2018年 ArledKola. All rights reserved.
//

import Foundation


class Feed {
    
    private var _id:Int!
    private var _title: String!
    private var _link: String!
    private var _pubDate: String!
    private var _description: String!
    
    
    var id:Int{
        return _id
    }
    
    var title: String{
        return _title
    }
    
    var description: String{
        return _description
    }
    
    var link: String{
        return _link
    }
    
    var pubDate: String{
        return _pubDate
    }
    
    init(id:Int, title: String, link: String, pubDate: String, description:String){
        self._id = id
        self._title = title
        self._link = link
        self._pubDate = pubDate
        self._description = description
    }
    
    func getFeed()->Feed2{
        return Feed2(id:_id,title: _title, link: _link, pubDate:_pubDate,description:_description)
    }
 
}
