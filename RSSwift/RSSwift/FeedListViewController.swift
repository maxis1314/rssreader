//
//  FeedListViewController.swift
//  Rsswift
//
//  Created by Arled Kola on 18/11/2016.
//  Copyright © 2016 ArledKola. All rights reserved.
//

import UIKit


class FeedListViewController: UITableViewController, XMLParserDelegate,UISearchBarDelegate, UISearchDisplayDelegate  {
    
    var searchController: UISearchDisplayController!
    
    
    var myFeed = [Feed]()
    var feedImgs: [AnyObject] = []
    var url: URL!
    var refresher: UIRefreshControl!
    
    var filteredFeed = [Feed]()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.title = "Feed List"
        
        refresher = UIRefreshControl()
        
        refresher.addTarget(self, action: #selector(FeedListViewController.loadData),
                                 for: .valueChanged)
        refresher.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        tableView.addSubview(refresher)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.backgroundColor = UIColorFromRGB(rgbValue: 0xFFFFFF)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
        
        searchController = UISearchDisplayController(searchBar: searchBar, contentsController: self)
        searchController.searchResultsDataSource = self
        searchController.searchResultsDelegate = self
        searchController.searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell2")

        
        loadData()
        
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        filteredFeed=myFeed.filter({$0.title.range(of: searchText) != nil})
    }
 
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    


    @IBAction func refreshFeed2(_ sender: Any) {
        loadData()
    }
    
    func loadData() {
        print("Hello from Daniel")
        //url = URL(string: "http://feeds.skynews.com/feeds/rss/technology.xml")!
        url = URL(string: "https://www3.nhk.or.jp/rss/news/cat6.xml")!
        
        loadRss(url);
        
        
    }
    
    func loadRss(_ data: URL) {
        // XmlParserManager instance/object/variable
        let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
        // Put feed in array
        feedImgs = myParser.img as [AnyObject]
        
        //refact
        for one in myParser.feeds{
            let title = (one as AnyObject).object(forKey: "title") as! String
            let link = (one as AnyObject).object(forKey: "link") as! String
            let pubDate = (one as AnyObject).object(forKey: "pubDate") as! String
            let feed = Feed(title: title, link: link,pubDate:pubDate)
            myFeed.append(feed)
        }
        
        
        //sleep(4)
        refresher.endRefreshing()
        tableView.reloadData()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        if segue.identifier == "openPage" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            var feed:Feed
  
            if self.searchController!.isActive {
                feed=filteredFeed[indexPath.row]
            }else{
                feed=myFeed[indexPath.row]
            }
           
            
            // Instance of our feedpageviewcontrolelr
            let fivc: FeedItemViewController = segue.destination as! FeedItemViewController
            fivc.selectedFeedURL = feed.link
            fivc.topTitle = feed.title
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView != self.tableView{
            return filteredFeed.count
        }else{
            return myFeed.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColorFromRGB(rgbValue: 0xDCDCDC)
        } else {
            cell.backgroundColor = UIColor.white//(white: 1, alpha: 0.3)
        }

        // Load feed iamge.
        /*let url = NSURL(string:feedImgs[indexPath.row] as! String)
        let data = NSData(contentsOf:url! as URL)
        var image = UIImage(data:data! as Data)
        image = resizeImage(image: image!, toTheSize: CGSize(width: 70, height: 70))
        let cellImageLayer: CALayer?  = cell.imageView?.layer
        cellImageLayer!.cornerRadius = 35
        cellImageLayer!.masksToBounds = true
        cell.imageView?.image = image*/
        
        var feed:Feed!
        if tableView != self.tableView{
            feed=filteredFeed[indexPath.row]
        }else{
            feed=myFeed[indexPath.row]
        }
        
        
            cell.textLabel?.text = feed.title
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
            cell.detailTextLabel?.text = feed.pubDate
            cell.detailTextLabel?.textColor = UIColor.black
            
        
        return cell
    }
    
    
 
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    
    
    }
