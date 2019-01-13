//
//  ToolboxTableViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 4/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class ToolboxTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, noticeDelegate {
    
    deinit {
        print("Deinit ToolboxTableViewController")
    }
    
    let notice = getNotice()
    let imgCache = Session.sharedInstance.imgSession
    let detailNCs = NSMutableArray()
    let detailVCs = NSMutableArray()
    
    var feedItems = NSArray()
    
    @IBOutlet weak var noticeList: UICollectionView!
    @IBAction func refreshBtn(_ sender: UIBarButtonItem) {
        notice.downloadItems()
    }
    
    func returnItems(items: NSArray) {
        if items.count > 0{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.noticeList.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
                self.tableView.reloadData()
            }, completion: nil)
            feedItems = items
            noticeList.reloadData()
        }else{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.noticeList.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.tableView.reloadData()
            }, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localDB().setup()
        
        localDB().writeSettings(item: "isOffline", value: "0")
        UserDefaults.standard.set(false, forKey: "offlineImg")
        
        let alert = UIAlertController(title: "警告", message: "此beta版本已停用離線功能", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        self.splitViewController?.preferredDisplayMode = .allVisible
        
        let ts = self.storyboard?.instantiateViewController(withIdentifier: "timeSearch") as! UINavigationController
        let ks = self.storyboard?.instantiateViewController(withIdentifier: "keySearch") as! UINavigationController
        let ss = self.storyboard?.instantiateViewController(withIdentifier: "starSearch") as! UINavigationController
        let all = self.storyboard?.instantiateViewController(withIdentifier: "allSearch") as! UINavigationController
        let bs = self.storyboard?.instantiateViewController(withIdentifier: "buildSim") as! UINavigationController
        let fs = self.storyboard?.instantiateViewController(withIdentifier: "teamSim") as! UINavigationController
        let no = self.storyboard?.instantiateViewController(withIdentifier: "notice") as! noticeDetailViewController
        
        let tsv = self.storyboard?.instantiateViewController(withIdentifier: "timeSearchV") as! BuildtimeSearchCollectionViewController
        let ksv = self.storyboard?.instantiateViewController(withIdentifier: "keySearchV") as! KeySearchViewController
        let sv = self.storyboard?.instantiateViewController(withIdentifier: "starSearchV") as! StarSearchViewController
        let allv = self.storyboard?.instantiateViewController(withIdentifier: "allSearchV") as! allViewController
        let bsv = self.storyboard?.instantiateViewController(withIdentifier: "buildSimV") as! BuildSimulatorViewController
        let fsv = self.storyboard?.instantiateViewController(withIdentifier: "teamSimV") as! TeamSimulatorViewController
        
        detailNCs.add(no)
        detailNCs.add(ts)
        detailNCs.add(ks)
        detailNCs.add(all)
        detailNCs.add(ss)
        detailNCs.add(bs)
        detailNCs.add(fs)
        
        detailVCs.add(no)
        detailVCs.add(tsv)
        detailVCs.add(ksv)
        detailVCs.add(allv)
        detailVCs.add(sv)
        detailVCs.add(bsv)
        detailVCs.add(fsv)
        
        if (self.splitViewController?.viewControllers.count)! > 1 {
            self.splitViewController?.viewControllers[1] = detailNCs[1] as! UIViewController
        }
        
        noticeList.delegate = self
        noticeList.dataSource = self
        notice.delegate = self
        notice.downloadItems()
        
        for item in (self.tabBarController?.tabBar.items)!{
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor().white(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notice.downloadItems()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = 0
        switch indexPath.section {
        case 0:
            item = indexPath.row + 1
        case 1:
            item = indexPath.row + 3
        case 2:
            item = indexPath.row + 5
        default:
            break
        }
        
        if (self.splitViewController?.viewControllers.count)! > 1{
            self.splitViewController?.viewControllers[1] = detailNCs[item] as! UINavigationController
        }else{
            self.navigationController?.pushViewController(detailVCs[item] as! UIViewController, animated: true)
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
            let urlString = URL(string: "https://dollbox.scarletsc.net/img/notice/\(photo_path)")
            let url = URL(string: "https://dollbox.scarletsc.net/img/notice/\(photo_path)")
            
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
        let detailVC = detailNCs[0] as! noticeDetailViewController
        
        var selectedNotice = Notice()
        selectedNotice = feedItems[indexPath.row] as! Notice
        
        Session.sharedInstance.selectedNotice = selectedNotice
        if let imgPath = selectedNotice.cover{
            Session.sharedInstance.selectedNoticeImg = imgCache.object(forKey: URL(string: "https://dollbox.scarletsc.net/img/notice/\(imgPath)") as AnyObject) as! UIImage
        }
        if (self.splitViewController?.viewControllers.count)! > 1{
            self.splitViewController?.viewControllers[1] = detailVC
            detailVC.viewDidAppear(true)
        }else{
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

}
