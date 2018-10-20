//
//  KeySearchViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 15/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class KeySearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol, getEquipmentDelegate {
    
    let searchTDoll = getSearchResult()
    let searchEquip = getEquipment()
    let imgCache = Session.sharedInstance.imgSession
    let localSearch = localDB()
    let noti = UIImpactFeedbackGenerator()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    var userDefaults = UserDefaults.standard
    var feedItems = NSArray()
    var selectedTDoll = TDoll()
    var selectedEquip = Equipment()
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        resultList.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell", for: indexPath) as! ResultCollectionViewCell
        
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            let item = feedItems[indexPath.row] as! TDoll
            
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
                    let urlString = URL(string: "https://dollbox.scarletsc.net/img/\(photo_path)")
                    let url = URL(string: "https://dollbox.scarletsc.net/img/\(photo_path)")
                    
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
            
            myCell.imgResult.backgroundColor = UIColor.clear
            myCell.lblResult.text = item.Zh_Name
            
            return myCell
            
        case 1:
            let item: Equipment = feedItems[indexPath.row] as! Equipment
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
            switch item.star{
            case 2:
                myCell.imgResult.backgroundColor = UIColor.clear
            case 3:
                myCell.imgResult.backgroundColor = UIColor(red: 116.0/255.0, green: 220.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            case 4:
                myCell.imgResult.backgroundColor = UIColor(red: 210.0/255.0, green: 226.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            case 5:
                myCell.imgResult.backgroundColor = UIColor(red: 253.0/255.0, green: 181.0/255.0, blue: 35.0/255.0, alpha: 1.0)
            default:
                myCell.imgResult.backgroundColor = UIColor.clear
            }
            myCell.lblResult.text = item.name
            
            return myCell
            
        default:
            break
        }
        
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! TDollViewController
            
            selectedTDoll = feedItems[(indexPath.row)] as! TDoll
            
            detailVC.selectedTDoll = self.selectedTDoll
            if let imgPath = self.selectedTDoll.photo_path{
                detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://dollbox.scarletsc.net/img/\(imgPath)") as AnyObject) as? UIImage
            }
            if userDefaults.bool(forKey: "offlineImg"){
                if let id = self.selectedTDoll.ID{
                    detailVC.selectedImg = imgCache.object(forKey: id as AnyObject) as? UIImage
                }
                
            }
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        case 1:
            let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "equipDetail") as! EquipmentDetailViewController
            
            selectedEquip = feedItems[(indexPath.row)] as! Equipment
            
            detailVC.selectedEquip = self.selectedEquip
            if var imgPath = self.selectedEquip.cover{
                imgPath = imgPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://dollbox.scarletsc.net/img/\(imgPath).png") as AnyObject) as? UIImage
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        default:
            break
        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(true, animated: true)
        dimView.isHidden = false
        return true
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = false
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(false, animated: true)
        dimView.isHidden = true
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        var field = String()
        
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            switch searchBar.selectedScopeButtonIndex{
            case 0:
                field = "info.ID"
            case 1:
                field = "info.Zh_Name"
            case 2:
                field = "skill.name"
            case 3:
                field = "obtain.obtain_method"
            default:
                break
            }
            
            if localSearch.readSettings()[0]{
                let value = "'%" + searchBar.text! + "%'"
                let sql = "select * from info inner join buff on buff.ID = info.ID inner join consumption on consumption.ID = info.ID inner join obtain on obtain.ID = info.ID inner join skill on skill.ID = info.ID inner join stats on stats.ID = info.ID where \(field) LIKE \(value)"
                print(sql)
                localSearch.search(sql: sql)
            }else{
                let value = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                searchTDoll.urlPath = "https://dollbox.scarletsc.net/search?field=\(field)&value=\(value)&s"
                searchTDoll.downloadItems()
            }
            
            
        case 1:
            switch searchBar.selectedScopeButtonIndex{
            case 0:
                field = "EID"
            case 1:
                field = "Name"
            case 2:
                field = "Type"
            case 3:
                field = "Obtain_method"
            default:
                break
            }
            
            if localSearch.readSettings()[0]{
                let value = "'%" + searchBar.text! + "%'"
                let sql = "SELECT * from info_e where \(field) LIKE \(value)"
                print(sql)
                localSearch.search_e(sql: sql)
            }else{
                let value = searchBar.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                searchEquip.urlPath = "https://dollbox.scarletsc.net/search_e?field=\(field)&value=\(value)&s"
                searchEquip.downloadItems()
            }
            
            
        default:
            break
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var typeSwitch: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultList: UICollectionView!
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            sender.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            searchBar.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            searchBar.scopeButtonTitles = ["ID", "名稱", "技能", "獲得方法"]
            
        case 1:
            sender.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            searchBar.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            searchBar.scopeButtonTitles = ["ID", "名稱", "種類", "獲得方法"]
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultList.delegate = self
        resultList.dataSource = self
        searchEquip.delegate = self
        searchTDoll.delegate = self
        searchBar.delegate = self
        searchBar.showsScopeBar = false
        searchBar.scopeBarBackgroundImage = UIImage.imageWithColor(color: UIColor.white)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNavBarColor().white(self)
        
    }

}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
