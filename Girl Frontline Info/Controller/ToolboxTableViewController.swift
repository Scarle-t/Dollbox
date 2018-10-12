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
    let detailVCs = NSMutableArray()
    
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
        
        self.splitViewController?.preferredDisplayMode = .allVisible
        
        let ts = self.storyboard?.instantiateViewController(withIdentifier: "timeSearch") as! UINavigationController
        let ss = self.storyboard?.instantiateViewController(withIdentifier: "starSearch") as! UINavigationController
        let tps = self.storyboard?.instantiateViewController(withIdentifier: "typeSearch") as! UINavigationController
        let all = self.storyboard?.instantiateViewController(withIdentifier: "allSearch") as! UINavigationController
        let bs = self.storyboard?.instantiateViewController(withIdentifier: "buildSim") as! UINavigationController
        let fs = self.storyboard?.instantiateViewController(withIdentifier: "teamSim") as! UINavigationController
        let no = self.storyboard?.instantiateViewController(withIdentifier: "notice") as! noticeDetailViewController
        
        detailVCs.add(no)
        detailVCs.add(ts)
        detailVCs.add(ss)
        detailVCs.add(tps)
        detailVCs.add(all)
        detailVCs.add(bs)
        detailVCs.add(fs)
        
        self.splitViewController?.viewControllers[1] = detailVCs[1] as! UIViewController
        
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
            self.splitViewController?.viewControllers[1] = detailVCs[0] as! UIViewController
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.splitViewController?.viewControllers[1] = detailVCs[indexPath.row + 1] as! UINavigationController
        case 1:
            self.splitViewController?.viewControllers[1] = detailVCs[indexPath.row + 2] as! UINavigationController
        case 2:
            self.splitViewController?.viewControllers[1] = detailVCs[indexPath.row + 5] as! UINavigationController
        default:
            break
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = detailVCs[0] as! noticeDetailViewController
        
        var selectedNotice = Notice()
        selectedNotice = feedItems[indexPath.row] as! Notice
        
        detailVC.selectedNotice = selectedNotice
        if let imgPath = selectedNotice.cover{
            detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://scarletsc.net/girlfrontline/img/notice/\(imgPath)") as AnyObject) as? UIImage
        }
        self.splitViewController?.viewControllers[1] = detailVC
        
    }

}
