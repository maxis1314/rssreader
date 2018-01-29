//
//  FeedListViewController.swift
//  Rsswift
//
//  Created by Arled Kola on 18/11/2016.
//  Copyright © 2016 ArledKola. All rights reserved.
//

import UIKit


class FeedListViewController: UITableViewController, XMLParserDelegate ,UISearchResultsUpdating,UISearchBarDelegate {
    
    var searchController: UISearchController!    
    var myFeedSafe = SafeArray<Feed>()//[Feed]()
    //var myFeed = [Feed]()
    var feedImgs: [AnyObject] = []
    var url: URL!
    var refresher: UIRefreshControl!    
    var filteredFeed = [Feed]()
    var tableViewNow: UITableView!
    var i: Int = 0
    var eagleList = [EagleList]()
    var searchScope:Int = 0 //0 all 1 unread 2 read
    
    func copyFeed(){
        gdb.myFeed.removeAll()
        /*for object in myFeedSafe {
            let title = object.title
            let link = object.link
            let pubDate = object.pubDate
            let feed = Feed(title: title, link: link,pubDate:pubDate)
            myFeed.append(feed)
        }*/
        dbFeed.deleteAll()
        var i = 0
        myFeedSafe.forEach { object in
            let title = object.title
            let link = object.link
            let pubDate = object.pubDate
            let description = object.description
            let feed = Feed(id:i, title: title, link: link,pubDate:pubDate, description:description)
            gdb.myFeed.append(feed)
            i = i+1
            dbFeed.save(title: title, link: link, pubDate: pubDate, description: description)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gdb.myFeed.count <= 0 {
            var i = 0
            for feedEagle in dbFeed.list() {
                print(feedEagle)
                let feed = Feed(id:i,title: feedEagle.title!, link: feedEagle.link!,pubDate:feedEagle.pubDate!, description:feedEagle.desc!)
                i=i+1
                gdb.myFeed.append(feed)
            }
        }
        
        
        let defaultImage = UIImage(named: "settings")?
            .scaleTo(CGSize(width: 40, height: 40))
        
        self.navigationItem.leftBarButtonItem?.image = defaultImage
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.title = "Feed List"
        
        refresher = UIRefreshControl()        
        refresher.addTarget(self, action: #selector(FeedListViewController.loadData),
                                 for: .valueChanged)
        //refresher.attributedTitle = NSAttributedString(string: "刷新")
        //tableView.addSubview(refresher)
        tableView.refreshControl = refresher
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.backgroundColor = UIColorFromRGB(rgbValue: 0xFFFFFF)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
        self.tableView.dataSource = self
        self.tableView.delegate = self        
        
        searchController = UISearchController(searchResultsController:nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true        
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All","Unread", "Read"]
        
        /*let items = ["Purple", "Green", "Blue"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.black
        customSC.tintColor = UIColor.white
        
        // Add target action method
        customSC.addTarget(self, action: #selector(FeedListViewController.changeColor),
                           for: .valueChanged)
        
        // Add this custom Segmented Control to our view
        //tableView.tableHeaderView = customSC*/
        
        
        loadData()        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchScope = selectedScope
        
        print(searchController.searchBar.text)
        if let searchText = searchController.searchBar.text {
            filteredFeed=filterContentsforSearchText(searchText: searchText, scope: searchScope)//gdb.myFeed.filter({$0.title.range(of: searchText) != nil})
            tableView.reloadData()
        }
    }
    
    func changeColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.view.backgroundColor = UIColor.green
        case 2:
            self.view.backgroundColor = UIColor.blue
        default:
            self.view.backgroundColor = UIColor.purple
        }
    }
 
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
        if let searchText = searchController.searchBar.text {
            filteredFeed=filterContentsforSearchText(searchText: searchText, scope: searchScope)//gdb.myFeed.filter({$0.title.range(of: searchText) != nil})
            tableView.reloadData()
        }else{

        }
    }
    
    func filterContentsforSearchText(searchText: String, scope: Int = 0)->[Feed]{
        return gdb.myFeed.filter { feed in
            let isRead = ddStorageGet(key: "isread_\(feed.link)", empty: "")
            let categoryMatch = (scope == 0) || (isRead == "" && scope==1)  || (isRead == "1" && scope==2)
            return categoryMatch && feed.title.lowercased().contains(searchText.lowercased())
        }
    }

    @IBAction func refreshFeed2(_ sender: Any) {
        loadData()
    }
    
    func loadData() {
        let reachability = Reachability.reachabilityForInternetConnection()
         
        //判断连接状态
        if !reachability!.isReachable(){
            return
        }
        
        
        print("Hello from Daniel")
        //url = URL(string: "http://feeds.skynews.com/feeds/rss/technology.xml")!
        url = URL(string: "https://www3.nhk.or.jp/rss/news/cat6.xml")!
        
        
        myFeedSafe.removeAll()
        //tableView.reloadData()
        
        eagleList = eagle_list()

        i=0
        let count = eagleList.count
        if count > 0{
            self.refresher.attributedTitle = NSAttributedString(string: "\(self.i+1)/\(count) \(eagleList[0].name!)")
            for eagle in eagleList{
                print("\(i)/\(count)")
                DispatchQueue.global(qos: .default).async {
                    //处理耗时操作的代码块...
                    self.loadRss(URL(string:eagle.url!)!)
                    
                    //操作完成，调用主线程来刷新界面
                    DispatchQueue.main.async {
                        self.refresher.attributedTitle = NSAttributedString(string: "\(self.i+1)/\(count) \(eagle.name!)")
                        self.i = self.i+1
                        //self.tableView.reloadData()
                        if self.i == self.eagleList.count{
                            self.copyFeed()
                            self.tableView.reloadData()
                            self.refresher.endRefreshing()
                        }
                    }
                }
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please add some feed!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        print(eagle_list())
    }
    
    func loadRss(_ data: URL) {
        print(data)
        
        do {
            // XmlParserManager instance/object/variable
            let myParser : XmlParserManager = XmlParserManager().initWithURL(data) as! XmlParserManager
            // Put feed in array
            feedImgs = myParser.img as [AnyObject]
            //refact
            if myParser.feeds != nil && myParser.feeds.count > 0{
                print("fetch rss success")
                print(myParser.feeds)
                for one in myParser.feeds{
                    let title = (one as AnyObject).object(forKey: "title") as! String
                    let link = (one as AnyObject).object(forKey: "link") as! String
                    let pubDate = ((one as AnyObject).object(forKey: "pubDate") ?? "") as! String
                    let description = ((one as AnyObject).object(forKey: "description") ?? "") as! String
                    let feed = Feed(id:0,title: title, link: link,pubDate:pubDate,description:description)
                    self.myFeedSafe.append(feed)
                }
            }else{
                print("fetch rss failed")
            }
            
        } catch let error as NSError {
            print ("Error: \(error.domain)")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            var indexPath: IndexPath!
            indexPath = self.tableView.indexPathForSelectedRow!
            var feed:Feed
  
            if searchController.isActive {
                feed=filteredFeed[indexPath.row]
            }else{
                feed=gdb.myFeed[indexPath.row]
            }
            
            // Instance of our feedpageviewcontrolelr
            let fivc: FeedItemViewController = segue.destination as! FeedItemViewController
            fivc.selectedFeedURL = feed.link
            fivc.topTitle = feed.title
            fivc.indexNow = feed.id//indexPath.row
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredFeed.count
        }else{
            return gdb.myFeed.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var feed:Feed!
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
     
        if searchController.isActive{
            feed=filteredFeed[indexPath.row]
        }else{
            if indexPath.row < gdb.myFeed.count{
                feed=gdb.myFeed[indexPath.row]
            }else{
                feed=gdb.myFeed[0]
            }
        }
        
        
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
        
        let isRead = ddStorageGet(key: "isread_\(feed.link)", empty: "")
        if isRead == "" {
            //cell.imageView?.image = UIImage(named: "unread")?.scaleTo(CGSize(width: 10, height: 10))
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        }else{
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }

        cell.textLabel?.text = feed.title
        //cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    
        cell.detailTextLabel?.text = feed.pubDate
        //cell.detailTextLabel?.textColor = UIColor.black
            
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
