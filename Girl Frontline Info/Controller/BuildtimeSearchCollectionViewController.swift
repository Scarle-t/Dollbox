//
//  BuildtimeSearchCollectionViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildtimeSearchCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate ,getSearchProtocol, localDBDelegate {

    let imgCache = Session.sharedInstance.imgSession
    let pickerView = UIPickerView()
    let searchResult = getSearchResult()
    let localSearch = localDB()
    
    var feedItems : NSArray = NSArray()
    var selectedTDoll: TDoll = TDoll()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0{
            return 24
        }
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Mohave", size: 35)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = String(row)
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            txtHour.text = String(row)
        case 1:
            txtMinute.text = String(row)
        case 2:
            txtSecond.text = String(row)
        default:
            break
        }
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
        return myCell
    }
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.collectionResult.reloadData()
    }
    func returndData(items: NSArray) {
        feedItems = items
        self.collectionResult.reloadData()
    }

    @IBAction func btnTimeSearch(_ sender: UIButton) {
        
        view.endEditing(true)
        guard var hour = txtHour.text else {return}
        guard var minute = txtMinute.text else {return}
        guard var second = txtSecond.text else {return}
        if hour.count < 2{
            hour = "0" + hour
        }
        if minute.count < 2{
            minute = "0" + minute
        }
        if second.count < 2{
            second = "0" + second
        }
        if localDB().readSettings()[0] {
            localSearch.search(cond: "build_time = '" + hour + ":" + minute + ":" + second + "'")
        }else{
                searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?hour=\(hour)&minute=\(minute)&second=\(second)"
            searchResult.downloadItems()
        }
        
    }
    @IBOutlet weak var txtHour: UITextField!
    @IBOutlet weak var txtMinute: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    @IBOutlet weak var collectionResult: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        collectionResult.delegate = self
        collectionResult.dataSource = self
        searchResult.delegate = self
        localSearch.delegate = self
        
        txtSecond.inputView = pickerView
        txtMinute.inputView = pickerView
        txtHour.inputView = pickerView
        
        self.title = "製造時間搜尋"
        
        setNavBarColor().white(self)
        tabBarController?.tabBar.barTintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor().white(self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC  = segue.destination as! TDollViewController
        
        if let sender = sender as? UICollectionViewCell{
            let indexPath = self.collectionResult.indexPath(for: sender)
            
            selectedTDoll = feedItems[(indexPath?.row)!] as! TDoll
            
        }
        
        detailVC.selectedTDoll = self.selectedTDoll
        if let imgPath = self.selectedTDoll.photo_path{
            detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://scarletsc.net/girlfrontline/img/\(imgPath)") as AnyObject) as? UIImage
        }
        
    }

}
