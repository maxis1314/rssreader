//
//  XmlParserManager.swift
//  Rsswift
//
//  Created by Arled Kola on 18/11/2016.
//  Copyright © 2016 ArledKola. All rights reserved.
//

import Foundation

class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img:  [AnyObject] = []
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        feeds = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (element as NSString).isEqual(to: "item") {
            elements =  NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
            fdate = NSMutableString()
            fdate = ""
        } else if (element as NSString).isEqual(to: "enclosure") {
            if let urlString = attributeDict["url"] {
                img.append(urlString as AnyObject)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if (elementName as NSString).isEqual(to: "item") {
            if ftitle != nil {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }else{
                elements.setObject("", forKey: "title" as NSCopying)
            }
            if link != nil{
                elements.setObject(link, forKey: "link" as NSCopying)
            }else{
                elements.setObject("", forKey: "link" as NSCopying)
            }
            if fdescription != nil {
                elements.setObject(fdescription, forKey: "description" as NSCopying)
            }else{
                elements.setObject("", forKey: "description" as NSCopying)
            }
            if fdate != nil {
                elements.setObject(fdate, forKey: "pubDate" as NSCopying)
            }else{
                elements.setObject("", forKey: "pubDate" as NSCopying)
            }
            feeds.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //var string2 =  string.replacingOccurrences(of: " ", with:"")
        var string2 =  string.replacingOccurrences(of: "\n", with:"")

        
        if element.isEqual(to: "title") {
            ftitle.append(string2)
        } else if element.isEqual(to: "link") {
            link.append(string2)
        } else if element.isEqual(to: "description") {
            fdescription.append(string2)
        } else if element.isEqual(to: "pubDate") {
            fdate.append(string2)
        } else if element.isEqual(to: "pubdate") {
            fdate.append(string2)
        }
    }
}
