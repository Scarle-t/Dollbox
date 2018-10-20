//
//  StarSearchViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class StarSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, getEquipmentDelegate, localDBDelegate {
    
    //LET
    let imgCache = Session.sharedInstance.imgSession
    let searchResult = getEquipment()
    let localSearch = localDB()
    let noti = UIImpactFeedbackGenerator()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    //VAR
    var userDefaults = UserDefaults.standard
    var feedItems: NSArray = NSArray()
    var selectedEquip: Equipment = Equipment()
    
    //DELEGATE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        let item: Equipment = feedItems[indexPath.row] as! Equipment
        if userDefaults.bool(forKey: "offlineImg"){
            if let id = item.cover{
                let cover = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                let filePath = self.localPath[self.localPath.count-1].absoluteString + cover + ".png"
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
            if var photo_path = item.cover{
                photo_path = photo_path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                let urlString = URL(string: "https://dollbox.scarletsc.net/img/\(photo_path).png")
                let url = URL(string: "https://dollbox.scarletsc.net/img/\(photo_path).png")
                
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
        myCell.lblResult.text = item.name
        return myCell
    }
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        listResult.reloadData()
        noti.impactOccurred()
    }
    func returndData(items: NSArray) {
        feedItems = items
        listResult.reloadData()
        noti.impactOccurred()
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
        var star = String()
        switch navBarStars.selectedSegmentIndex {
        case 0:
            setNavBarColor().white(self)
            star = "2"
        case 1:
            setNavBarColor().blue(self)
            star = "3"
        case 2:
            setNavBarColor().green(self)
            star = "4"
        case 3:
            setNavBarColor().gold(self)
            star = "5"
        default:
            if let string = navBarStars.titleForSegment(
                at: navBarStars.selectedSegmentIndex){
                print(string)
            }
        }
        if localDB().readSettings()[0] {
            localSearch.search_e(star: star)
        }else{
            searchResult.urlPath = "https://dollbox.scarletsc.net/search_e.php?star=\(star)"
            searchResult.downloadItems()
        }
        
    }

    //VIEW CONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC  = segue.destination as! EquipmentDetailViewController
        if let sender = sender as? UICollectionViewCell{
            let indexPath = self.listResult.indexPath(for: sender)
            selectedEquip = feedItems[(indexPath?.row)!] as! Equipment
        }
        
        detailVC.selectedEquip = self.selectedEquip
        if var imgPath = self.selectedEquip.cover{
            if userDefaults.bool(forKey: "offlineImg"){
                detailVC.selectedImg = imgCache.object(forKey: imgPath as AnyObject) as? UIImage
            }else{
                imgPath = imgPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://dollbox.scarletsc.net/img/\(imgPath).png") as AnyObject) as? UIImage
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        swipeResult()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
