//
//  BuildtimeSearchCollectionViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildtimeSearchCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate ,getSearchProtocol, getEquipmentDelegate, localDBDelegate {
    
    deinit {
        print("Deinit BuildtimeSearchCollectionViewController")
    }
    
    let imgCache = Session.sharedInstance.imgSession
    var pickerView = UIPickerView()
    let searchResult = getSearchResult()
    let searchE = getEquipment()
    let localSearch = localDB()
    let noti = UIImpactFeedbackGenerator()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    var userDefaults = UserDefaults.standard
    var feedItems : NSArray = NSArray()
    var selectedTDoll: TDoll = TDoll()
    var selectedEquip: Equipment = Equipment()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
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
        if row < 10 {
            pickerLabel?.text = "0" + String(row)
        }else{
            pickerLabel?.text = String(row)
        }
        
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            txtHour.text = String(row)
        case 1:
            txtMinute.text = String(row)
        default:
            break
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50.0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        
        switch typeSwitch.selectedSegmentIndex{
        case 0:
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
        default:
            break
        }
        
        return myCell
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
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.collectionResult.reloadData()
        loadingWheel.stopAnimating()
        noti.impactOccurred()
    }
    func returndData(items: NSArray) {
        feedItems = items
        self.collectionResult.reloadData()
        loadingWheel.stopAnimating()
        noti.impactOccurred()
    }

    @IBAction func btnTimeSearch(_ sender: Any) {
        view.endEditing(true)
        guard var hour = txtHour.text else {return}
        guard var minute = txtMinute.text else {return}
        if hour.count < 2{
            hour = "0" + hour
        }
        if minute.count < 2{
            minute = "0" + minute
        }
        loadingWheel.startAnimating()
        if localDB().readSettings()[0] {
            switch typeSwitch.selectedSegmentIndex{
            case 0:
                localSearch.search(cond: "build_time = '" + hour + ":" + minute + ":00'")
            case 1:
                localSearch.search_e(time: "'" + hour + ":" + minute + ":00'")
            default:
                break
            }
        }else{
            switch typeSwitch.selectedSegmentIndex{
            case 0:
                searchResult.urlPath = "https://dollbox.scarletsc.net/search.php?hour=\(hour)&minute=\(minute)&second=00"
                searchResult.downloadItems()
            case 1:
                searchE.urlPath = "https://dollbox.scarletsc.net/search_e.php?hour=\(hour)&minute=\(minute)&second=00"
                searchE.downloadItems()
            default:
                break
            }
        }
    }
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            sender.tintColor = UIColor.init(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            btnTimeSearch(sender)
        case 1:
            sender.tintColor = UIColor.init(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            btnTimeSearch(sender)
        default:
            break
        }
    }
    @IBOutlet weak var txtHour: UITextField!
    @IBOutlet weak var txtMinute: UITextField!
    @IBOutlet weak var collectionResult: UICollectionView!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    @IBOutlet weak var typeSwitch: UISegmentedControl!
    
    @objc func dismissPicker(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let toolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(btnTimeSearch(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(dismissPicker))
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtHour.inputAccessoryView = toolBar
        txtMinute.inputAccessoryView = toolBar
        
        pickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/1.8)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        collectionResult.delegate = self
        collectionResult.dataSource = self
        searchResult.delegate = self
        searchE.delegate = self
        localSearch.delegate = self
        
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
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            return true
        case 1:
            return false
        default:
            return false
        }
    }

}
