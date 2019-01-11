//
//  BuildStatsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 28/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildStatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    deinit {
        print("Deinit BuildStatsViewController")
    }
    
    let imgCache = Session.sharedInstance.loadImgSession()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    var userDefaults = UserDefaults.standard
    var selectedTDoll: TDoll = TDoll()
    var constructTDoll = NSArray()
    var totalBuildTime = 0
    var total5Star = 0
    var total4Star = 0
    var total3Star = 0
    var total2Star = 0
    var totalManPower = 0
    var totalAmmo = 0
    var totalRation = 0
    var totalParts = 0
    var initialTouchPoint = CGPoint.zero
    var type: String?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return constructTDoll.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        
        switch type {
        case "T":
            let item: TDoll = constructTDoll[indexPath.row] as! TDoll
            
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
            
            myCell.lblResult.text = item.Zh_Name
            
        case "E":
            let item: Equipment = constructTDoll[indexPath.row] as! Equipment
            if userDefaults.bool(forKey: "offlineImg"){
                if let id = item.cover{
                    let cover = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + ".png"
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
        
        myCell.contentView.frame = myCell.bounds
        return myCell
    }

    @IBOutlet weak var buildTime: UILabel!
    @IBOutlet weak var total5: UILabel!
    @IBOutlet weak var total4: UILabel!
    @IBOutlet weak var total3: UILabel!
    @IBOutlet weak var total2: UILabel!
    @IBOutlet weak var totalMan: UILabel!
    @IBOutlet weak var totalAm: UILabel!
    @IBOutlet weak var totalRa: UILabel!
    @IBOutlet weak var totalPa: UILabel!
    @IBOutlet weak var resultView: UICollectionView!
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view?.window)
        
        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y > initialTouchPoint.y {
                view.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        case .failed, .possible:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultView.delegate = self
        resultView.dataSource = self
        if type! == "T"{
            constructTDoll = Session.sharedInstance.constructedT.reversed() as NSArray
            total5Star = Session.sharedInstance.total5T
            total4Star = Session.sharedInstance.total4T
            total3Star = Session.sharedInstance.total3T
            total2Star = Session.sharedInstance.total2T
            totalManPower = Session.sharedInstance.totalMPT
            totalAmmo = Session.sharedInstance.totalAMT
            totalRation = Session.sharedInstance.totalRTT
            totalParts = Session.sharedInstance.totalPTT
        }else{
            constructTDoll = Session.sharedInstance.constructedE.reversed() as NSArray
            total5Star = Session.sharedInstance.total5E
            total4Star = Session.sharedInstance.total4E
            total3Star = Session.sharedInstance.total3E
            total2Star = Session.sharedInstance.total2E
            totalManPower = Session.sharedInstance.totalMPE
            totalAmmo = Session.sharedInstance.totalAME
            totalRation = Session.sharedInstance.totalRTE
            totalParts = Session.sharedInstance.totalPTE
        }
        
        
        totalBuildTime = total5Star + total4Star + total3Star + total2Star
        buildTime.text = "\(totalBuildTime)"
        total5.text = "\(total5Star)"
        total4.text = "\(total4Star)"
        total3.text = "\(total3Star)"
        total2.text = "\(total2Star)"
        totalMan.text = "\(totalManPower)"
        totalPa.text = "\(totalParts)"
        totalAm.text = "\(totalAmmo)"
        totalRa.text = "\(totalRation)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC  = segue.destination as! TDollViewController
        if let sender = sender as? UICollectionViewCell{
            let indexPath = self.resultView.indexPath(for: sender)
            selectedTDoll = constructTDoll[(indexPath?.row)!] as! TDoll
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
        detailVC.from = "stats"
    }
    
}
