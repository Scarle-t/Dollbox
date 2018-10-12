//
//  ToolboxTableViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 4/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class ToolboxTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, noticeDelegate {
    
    let notice = getNotice()
    let imgCache = Session.sharedInstance.imgSession
    
    var feedItems = NSArray()
    
    @IBOutlet weak var noticeList: UICollectionView!
    @IBAction func refreshBtn(_ sender: UIBarButtonItem) {
        notice.downloadItems()
    }
    
    func returnItems(items: NSArray) {
        feedItems = items
        noticeList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localDB().setup()
        
        noticeList.delegate = self
        noticeList.dataSource = self
        notice.delegate = self
        notice.downloadItems()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavBarColor().white(self)
        notice.downloadItems()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "noticeSegue"{
            var selectedNotice = Notice()
            
            let detailVC  = segue.destination as! noticeDetailViewController
            if let sender = sender as? UICollectionViewCell{
                let indexPath = self.noticeList.indexPath(for: sender)
                selectedNotice = feedItems[(indexPath?.row)!] as! Notice
            }
            
            detailVC.selectedNotice = selectedNotice
            if let imgPath = selectedNotice.cover{
                detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://scarletsc.net/girlfrontline/img/notice/\(imgPath)") as AnyObject) as? UIImage
            }
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 3
        }else{
            return 2
        }
    }
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "noticeCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! noticeCollectionViewCell
        let item = feedItems[indexPath.row] as! Notice
        
        if let photo_path = item.cover{
            let urlString = URL(string: "https://scarletsc.net/girlfrontline/img/notice/\(photo_path)")
            let url = URL(string: "https://scarletsc.net/girlfrontline/img/notice/\(photo_path)")
            
            if let imageFromCache = self.imgCache.object(forKey: url as AnyObject) as? UIImage{
                myCell.cover.image = imageFromCache
            }else{
                DownloadPhoto().get(url: url!) { data, response, error in
                    guard let imgData = data, error == nil else { return }
                    print(url!)
                    print("Download Finished")
                    DispatchQueue.main.async(execute: { () -> Void in
                        let imgToCache = UIImage(data: imgData)
                        if urlString == url{
                            myCell.cover.image = imgToCache
                        }
                        if let imginCache = imgToCache{
                            self.imgCache.setObject(imginCache, forKey: urlString as AnyObject)
                        }
                    })
                }
            }
        }
        
        myCell.cover.layer.cornerRadius = 15.0
        
        return myCell
    }

}
