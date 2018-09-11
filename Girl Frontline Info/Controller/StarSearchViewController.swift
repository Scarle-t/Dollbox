//
//  StarSearchViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class StarSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, getSearchProtocol {
    
    //LET
    let imgCache = Session.sharedInstance.imgSession
    let searchResult = getSearchResult()
    
    //VAR
    var feedItems: NSArray = NSArray()
    var selectedTDoll: TDoll = TDoll()
    
    //DELEGATE
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
        return myCell
    }
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        listResult.reloadData()
    }
    
    //OUTLET
    @IBOutlet weak var listResult: UICollectionView!
    @IBOutlet weak var navBarStars: UISegmentedControl!
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if navBarStars.selectedSegmentIndex != 0{
            navBarStars.selectedSegmentIndex = navBarStars.selectedSegmentIndex - 1
            swipeResult()
        }
    }
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if navBarStars.selectedSegmentIndex != 4{
            navBarStars.selectedSegmentIndex = navBarStars.selectedSegmentIndex + 1
            swipeResult()
        }
    }
    @IBAction func navbBarStars(_ sender: UISegmentedControl) {
        swipeResult()
    }
    
    //FUNC
    func swipeResult(){
        
        switch navBarStars.selectedSegmentIndex {
        case 0:
            setNavBarColor().white(self)
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?star=2"
        case 1:
            setNavBarColor().blue(self)
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?star=3"
        case 2:
            setNavBarColor().green(self)
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?star=4"
        case 3:
            setNavBarColor().gold(self)
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?star=5"
        case 4:
            setNavBarColor().purple(self)
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?star=EXTRA"
        default:
            if let string = navBarStars.titleForSegment(
                at: navBarStars.selectedSegmentIndex){
                print(string)
            }
        }
        searchResult.downloadItems()
    }

    //VIEW CONTROLLER
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        listResult.delegate = self
        listResult.dataSource = self
        searchResult.delegate = self
        
        navBarStars.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Mohave", size: 17)!
            ], for: UIControlState.normal)
        navBarStars.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Mohave", size: 17)!
            ], for: UIControlState.selected)
        
        swipeResult()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
