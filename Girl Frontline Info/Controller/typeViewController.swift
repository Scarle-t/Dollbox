//
//  typeViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class typeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol, localDBDelegate {
    
    let imgCache = Session.sharedInstance.imgSession
    let searchResult = getSearchResult()
    let localSearch = localDB()
    
    var feedItems: NSArray = NSArray()
    var selectedTDoll: TDoll = TDoll()
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        listResult.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        let item: TDoll = feedItems[indexPath.row] as! TDoll

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
        
        myCell.lblResult.text = item.Zh_Name
        myCell.contentView.frame = myCell.bounds
        return myCell
    }
    func returndData(items: NSArray) {
        feedItems = items
        listResult.reloadData()
    }
    
    @IBOutlet weak var listResult: UICollectionView!
    @IBOutlet weak var navBarStars: UISegmentedControl!
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if navBarStars.selectedSegmentIndex != 0{
            navBarStars.selectedSegmentIndex = navBarStars.selectedSegmentIndex - 1
            swipeResult()
        }
    }
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if navBarStars.selectedSegmentIndex != 5{
            navBarStars.selectedSegmentIndex = navBarStars.selectedSegmentIndex + 1
            swipeResult()
        }
    }
    @IBAction func navbBarStars(_ sender: UISegmentedControl) {
        swipeResult()
    }
    
    func swipeResult(){
        var type = String()
        switch navBarStars.selectedSegmentIndex {
        case 0:
            type = "HG"
        case 1:
            type = "SMG"
        case 2:
            type = "RF"
        case 3:
            type = "AR"
        case 4:
            type = "MG"
        case 5:
            type = "SG"
        default:
            if let string = navBarStars.titleForSegment(
                at: navBarStars.selectedSegmentIndex){
                print(string)
            }
        }
        if localDB().readSettings()[0] {
            type = "'" + type + "'"
            localSearch.search(col: ["type"], value: [type], both: false)
        }else{
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=\(type)"
            searchResult.downloadItems()
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
            detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://scarletsc.net/girlfrontline/img/\(imgPath)") as AnyObject) as? UIImage
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
