//
//  CVDollViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/1/2019.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class CVDollViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol, localDBDelegate {
    
    deinit {
        print("Deinit CVDollViewController")
    }
    
    let searchCV = getSearchResult()
    let imgCache = Session.sharedInstance.imgSession
    let localSearch = localDB()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let noti = UIImpactFeedbackGenerator()
    
    var userDefaults = UserDefaults.standard
    var cvName: String?
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
        
        if feedItems.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell", for: indexPath) as! ResultCollectionViewCell
            let tdoll = feedItems[indexPath.row] as! TDoll
            
            if userDefaults.bool(forKey: "offlineImg"){
                if let id = tdoll.ID{
                    let cover = id + ".jpg"
                    let filePath = self.localPath[self.localPath.count-1].absoluteString + cover
                    let imgData = NSData(contentsOf: URL(string: filePath)!)
                    if let data = imgData{
                        let img = UIImage(data: data as Data)
                        cell.imgResult.image = img
                    }else{
                        cell.imgResult.image = UIImage(imageLiteralResourceName: "ImgNotReady")
                    }
                    self.imgCache.setObject(cell.imgResult.image ?? UIImage(), forKey: id as AnyObject)
                }
            }else{
                if let photo_path = tdoll.photo_path{
                    let urlString = URL(string: "https://dollbox.scarletsc.net/img/\(photo_path)")
                    let url = URL(string: "https://dollbox.scarletsc.net/img/\(photo_path)")
                    
                    if let imageFromCache = self.imgCache.object(forKey: url as AnyObject) as? UIImage{
                        cell.imgResult.image = imageFromCache
                    }else{
                        DownloadPhoto().get(url: url!) { data, response, error in
                            guard let imgData = data, error == nil else { return }
                            print(url!)
                            print("Download Finished")
                            DispatchQueue.main.async(execute: { () -> Void in
                                let imgToCache = UIImage(data: imgData)
                                if urlString == url{
                                    cell.imgResult.image = imgToCache
                                }
                                if let imginCache = imgToCache{
                                    self.imgCache.setObject(imginCache, forKey: urlString as AnyObject)
                                }
                            })
                        }
                    }
                }
            }
            
            cell.lblResult.text = tdoll.Zh_Name
            cell.contentView.frame = cell.bounds
            return cell
        }else{
            return UICollectionViewCell()
        }
        
    }
    
    @IBOutlet weak var listResult: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        listResult.delegate = self
        listResult.dataSource = self
        searchCV.delegate = self
        localSearch.delegate = self
        self.title = cvName
        if var cv = cvName {
            cv = (cvName?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
            searchCV.urlPath = "https://dollbox.scarletsc.net/search?s&field=cv.cv&value=\(cv)&precise"
            searchCV.downloadItems()
            listResult.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listResult.delegate = self
        listResult.dataSource = self
        localSearch.delegate = self
        searchCV.delegate = self
        self.title = cvName
        if var cv = cvName {
            cv = (cvName?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
            searchCV.urlPath = "https://dollbox.scarletsc.net/search?s&field=cv.cv&value=\(cv)&precise"
            searchCV.downloadItems()
            listResult.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listResult.delegate = self
        listResult.dataSource = self
        localSearch.delegate = self
        searchCV.delegate = self
        setNavBarColor().white(self)
        self.title = cvName
        if cvName == "上坂堇"{
            setNavBarColor().set(self, r: 205, g: 54, b: 42, a: 1.0)
        }else if cvName == "雨宮天"{
            setNavBarColor().set(self, r: 9, g: 43, b: 116, a: 1.0)
        }
        if var cv = cvName {
            cv = (cvName?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
            searchCV.urlPath = "https://dollbox.scarletsc.net/search?s&field=cv.cv&value=\(cv)&precise"
            searchCV.downloadItems()
            listResult.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC  = segue.destination as! TDollViewController
        if let sender = sender as? UICollectionViewCell{
            let indexPath = self.listResult.indexPath(for: sender)
            selectedTDoll = feedItems[(indexPath?.row)!] as! TDoll
        }
        detailVC.selectedTDoll = self.selectedTDoll
        if let imgPath = self.selectedTDoll.photo_path{
            detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://dollbox.scarletsc.net/img/\(imgPath)") as AnyObject) as? UIImage
        }
        if userDefaults.bool(forKey: "offlineImg"){
            if let id = self.selectedTDoll.ID{
                detailVC.selectedImg = imgCache.object(forKey: id as AnyObject) as? UIImage
            }
        }
    }

}
