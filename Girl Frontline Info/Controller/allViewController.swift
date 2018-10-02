//
//  allViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 12/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class allViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol, localDBDelegate {

    let imgCache = Session.sharedInstance.imgSession
    let searchResult = getSearchResult()
    let localSearch = localDB()
    let noti = UIImpactFeedbackGenerator()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    var userDefaults = UserDefaults.standard
    var feedItems: NSArray = NSArray()
    var selectedTDoll: TDoll = TDoll()
    
    func returndData(items: NSArray) {
        feedItems = items
        listResult.reloadData()
        noti.impactOccurred()
    }
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        listResult.reloadData()
        noti.impactOccurred()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        let item: TDoll = feedItems[indexPath.row] as! TDoll
        
        if userDefaults.bool(forKey: "offlineImg"){
            if let id = item.ID{
                let cover = id + ".jpg"
                let filePath = self.localPath[self.localPath.count-1].absoluteString + cover
                let imgData = NSData(contentsOf: URL(string: filePath)!)
                if let data = imgData{
                    let img = UIImage(data: data as Data)
                    myCell.imgResult.image = img
                }else{
                    myCell.imgResult.image = UIImage(imageLiteralResourceName: "ImgNotReady")
                }
                self.imgCache.setObject(myCell.imgResult.image ?? UIImage(), forKey: id as AnyObject)
            }
        }else{
            if let photo_path = item.photo_path{
                let urlString = URL(string: "https://scarletsc.net/girlfrontline/img/\(photo_path)")
                let url = URL(string: "https://scarletsc.net/girlfrontline/img/\(photo_path)")
                
                if let imageFromCache = self.imgCache.object(forKey: url as AnyObject) as? UIImage{
                    myCell.imgResult.image = imageFromCache
                }else{
                    DownloadPhoto().get(url: url!) { data, response, error in
                        guard let imgData = data, error == nil else { return }
                        print(url!)
                        print("Download Finished")
                        DispatchQueue.main.async(execute: { () -> Void in
                            let imgToCache = UIImage(data: imgData)
                            if urlString == url{
                                myCell.imgResult.image = imgToCache
                            }
                            if let imginCache = imgToCache{
                                self.imgCache.setObject(imginCache, forKey: urlString as AnyObject)
                            }
                        })
                    }
                }
            }
        }
        
        myCell.lblResult.text = item.Zh_Name
        myCell.contentView.frame = myCell.bounds
        return myCell
    }
    
    @IBOutlet weak var listResult: UICollectionView!
    @IBOutlet weak var navBarStars: UISegmentedControl!
    @IBOutlet weak var navBarTypes: UISegmentedControl!
    @IBAction func navbBarStars(_ sender: UISegmentedControl) {
        swipeResult()
    }
    
    func swipeResult(){
        var type = ""
        var star = ""
        switch navBarStars.selectedSegmentIndex {
        case 0:
            star = "2"
            setNavBarColor().white(self)
        case 1:
            star = "3"
            setNavBarColor().blue(self)
        case 2:
            star = "4"
            setNavBarColor().green(self)
        case 3:
            star = "5"
            setNavBarColor().gold(self)
        case 4:
            star = "EXTRA"
            setNavBarColor().purple(self)
        case 5:
            star = ""
            setNavBarColor().white(self)
        default:
            if let string = navBarStars.titleForSegment(
                at: navBarStars.selectedSegmentIndex){
                print(string)
            }
        }
        if navBarTypes.titleForSegment(at: navBarTypes.selectedSegmentIndex) == "ALL"{
            type = ""
        }else{
            type = navBarTypes.titleForSegment(at: navBarTypes.selectedSegmentIndex) ?? ""
        }
        var all = "?"
        if star != "" {
            all += "star=\(star)&"
        }
        if type != "" {
            all += "type=\(type)"
        }
        
        if localDB().readSettings()[0] {
            if type == ""{
                if star == ""{
                    localSearch.search()
                }else{
                    if star == "EXTRA"{
                        star = "'EXTRA'"
                    }
                    localSearch.search(col: ["Stars"], value: [star], both: false)
                }
            }else if star == ""{
                if type == ""{
                    localSearch.search()
                }else{
                    type = "'" + type + "'"
                    localSearch.search(col: ["type"], value: [type], both: false)
                }
            }else{
                if star == "EXTRA"{
                    star = "'EXTRA'"
                }
                type = "'" + type + "'"
                localSearch.search(col: ["Stars", "type"], value: [star, type], both: true)
            }
        }else{
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php\(all)"
            searchResult.downloadItems()
        }
        listResult.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC  = segue.destination as! TDollViewController
        if let sender = sender as? UICollectionViewCell{
            let indexPath = self.listResult.indexPath(for: sender)
            selectedTDoll = feedItems[(indexPath?.row)!] as! TDoll
        }
        detailVC.selectedTDoll = self.selectedTDoll
        if let imgPath = self.selectedTDoll.photo_path{
            detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://scarletsc.net/girlfrontline/img/\(imgPath)") as AnyObject) as? UIImage
        }
        if userDefaults.bool(forKey: "offlineImg"){
            if let id = self.selectedTDoll.ID{
                detailVC.selectedImg = imgCache.object(forKey: id as AnyObject) as? UIImage
            }
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor().white(self)
        listResult.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgCache.evictsObjectsWithDiscardedContent = false
        
        listResult.delegate = self
        listResult.dataSource = self
        searchResult.delegate = self
        localSearch.delegate = self
        
        navBarStars.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 17)!
            ], for: UIControl.State.normal)
        
        navBarStars.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 17)!
            ], for: UIControl.State.selected)
        
        swipeResult()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
