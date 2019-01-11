//
//  BuildSimulatorViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 27/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildSimulatorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol, localDBDelegate, getEquipmentDelegate {
    
    deinit {
        print("Deinit BuildSimulatorViewController")
    }
    
    let imgCache = Session.sharedInstance.imgSession
    let searchResult = getSearchResult()
    let searchE = getEquipment()
    let localSearch = localDB()
    let noti = UIImpactFeedbackGenerator()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    var userDefaults = UserDefaults.standard
    var counter = 0
    var selectedTDoll: TDoll = TDoll()
    var selectedE: Equipment = Equipment()
    var constructedTDolls: NSMutableArray = NSMutableArray()
    var constructTime = 0
    var resultT: TDoll = TDoll()
    var resultE: Equipment = Equipment()
    var appearType: [String] = ["SMG"]
    var downloadStrings: [String] = ["https://dollbox.scarletsc.net/search.php?build=SMG&buildable"]
    var manPower: Int = 30
    var ammo: Int = 30
    var ration: Int = 30
    var parts: Int = 30
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            let item: TDoll = resultT
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
        case 1:
            let item: Equipment = resultE
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! TDollViewController
            
            selectedTDoll = resultT
            
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
            
            selectedE = resultE
            
            detailVC.selectedEquip = self.selectedE
            if var imgPath = self.selectedE.cover{
                imgPath = imgPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://dollbox.scarletsc.net/img/\(imgPath).png") as AnyObject) as? UIImage
            }
            self.navigationController?.pushViewController(detailVC, animated: true)
        default:
            break
        }
    }
    func itemsDownloaded(items: NSArray) {
        if items.count != 0{
            let index = Int.random(in: 0..<items.count)
            switch typeSwitch.selectedSegmentIndex{
            case 0:
                resultT = items.shuffled()[index] as! TDoll
                Session.sharedInstance.constructedT.add(resultT)
                switch resultT.stars{
                case "2":
                    Session.sharedInstance.total2T += 1
                case "3":
                    Session.sharedInstance.total3T += 1
                case "4":
                    Session.sharedInstance.total4T += 1
                case "5":
                    Session.sharedInstance.total5T += 1
                default:
                    break
                }
            case 1:
                resultE = items.shuffled()[index] as! Equipment
                Session.sharedInstance.constructedE.add(resultE)
                switch resultE.star{
                case 2:
                    Session.sharedInstance.total2E += 1
                case 3:
                    Session.sharedInstance.total3E += 1
                case 4:
                    Session.sharedInstance.total4E += 1
                case 5:
                    Session.sharedInstance.total5E += 1
                default:
                    break
                }
            default:
                break
            }
            counter += 1
            constructTime += 1
            resultView.reloadData()
            loadingWheel.stopAnimating()
            noti.impactOccurred()
        }
    }
    func returndData(items: NSArray) {
        if items.count != 0{
            let index = Int.random(in: 0..<items.count)
            switch typeSwitch.selectedSegmentIndex{
            case 0:
                resultT = items.shuffled()[index] as! TDoll
                Session.sharedInstance.constructedT.add(resultT)
                switch resultT.stars{
                case "2":
                    Session.sharedInstance.total2T += 1
                case "3":
                    Session.sharedInstance.total3T += 1
                case "4":
                    Session.sharedInstance.total4T += 1
                case "5":
                    Session.sharedInstance.total5T += 1
                default:
                    break
                }
            case 1:
                resultE = items.shuffled()[index] as! Equipment
                Session.sharedInstance.constructedE.add(resultE)
                switch resultE.star{
                case 2:
                    Session.sharedInstance.total2E += 1
                case 3:
                    Session.sharedInstance.total3E += 1
                case 4:
                    Session.sharedInstance.total4E += 1
                case 5:
                    Session.sharedInstance.total5E += 1
                default:
                    break
                }
            default:
                break
            }
            counter += 1
            constructTime += 1
            resultView.reloadData()
            loadingWheel.stopAnimating()
            noti.impactOccurred()
        }
    }

    @IBOutlet weak var typeSwitch: UISegmentedControl!
    @IBOutlet weak var resultView: UICollectionView!
    @IBOutlet weak var resultBg: UIView!
    @IBOutlet weak var mpValue: UILabel!
    @IBOutlet weak var ammoValue: UILabel!
    @IBOutlet weak var rationValue: UILabel!
    @IBOutlet weak var partsValue: UILabel!
    @IBOutlet weak var mpSlide: UISlider!
    @IBOutlet weak var ammoSlide: UISlider!
    @IBOutlet weak var rationSlide: UISlider!
    @IBOutlet weak var partsSlide: UISlider!
    @IBOutlet weak var mpStep: UIStepper!
    @IBOutlet weak var ammoStep: UIStepper!
    @IBOutlet weak var rationStep: UIStepper!
    @IBOutlet weak var partsSetp: UIStepper!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    @IBAction func collapseResult(_ sender: UIButton) {
        resultBg.isHidden = true
    }
    @IBAction func slideChange(_ sender: UISlider) {
        switch sender.tag{
        case 0:
            manPower = Int(sender.value)
            mpStep.value = Double(sender.value)
            updateValue()
        case 1:
            ammo = Int(sender.value)
            ammoStep.value = Double(sender.value)
            updateValue()
        case 2:
            ration = Int(sender.value)
            rationStep.value = Double(sender.value)
            updateValue()
        case 3:
            parts = Int(sender.value)
            partsSetp.value = Double(sender.value)
            updateValue()
        default:
            break
        }
    }
    @IBAction func finishButton(_ sender: UIButton) {
        
        self.resultView.isHidden = true
        self.resultBg.isHidden = true
        appearType.removeAll()
        appearType.append("SMG")
        let total = manPower + ammo + ration + parts
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            Session.sharedInstance.totalAMT += ammo
            Session.sharedInstance.totalPTT += parts
            Session.sharedInstance.totalRTT += ration
            Session.sharedInstance.totalMPT += manPower
        case 1:
            Session.sharedInstance.totalAME += ammo
            Session.sharedInstance.totalPTE += parts
            Session.sharedInstance.totalRTE += ration
            Session.sharedInstance.totalMPE += manPower
        default:
            break
        }
        
        
        loadingWheel.startAnimating()
        
        switch typeSwitch.selectedSegmentIndex{
        case 0:
            if localDB().readSettings()[0]{
                selectLocal(types: pickType().pick(total: total, manPower: manPower, ammo: ammo, ration: ration, parts: parts))
            }else{
                buildOnline(types: pickType().pick(total: total, manPower: manPower, ammo: ammo, ration: ration, parts: parts))
                selectTDoll()
            }
        case 1:
            if localDB().readSettings()[0]{
                selectLocalE(types: pickType().pickE(total: total, manPower: manPower, ammo: ammo, ration: ration, parts: parts))
            }else{
                buildEOnline(types: pickType().pickE(total: total, manPower: manPower, ammo: ammo, ration: ration, parts: parts))
                selectEquip()
            }
        default:
            break
        }
        
        resultView.isHidden = false
        resultBg.isHidden = false
        
    }
    @IBAction func stepperChange(_ sender: UIStepper) {
        switch sender.tag{
        case 0:
            mpSlide.value = Float(sender.value)
            manPower = Int(sender.value)
            updateValue()
        case 1:
            ammoSlide.value = Float(sender.value)
            ammo = Int(sender.value)
            updateValue()
        case 2:
            rationSlide.value = Float(sender.value)
            ration = Int(sender.value)
            updateValue()
        case 3:
            partsSlide.value = Float(sender.value)
            parts = Int(sender.value)
            updateValue()
        default:
            break
        }
    }
    @IBAction func typeChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            sender.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            mpStep.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            mpSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            ammoStep.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            ammoSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            rationStep.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            rationSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            partsSetp.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            partsSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 77/255, alpha: 1.0)
            
            mpSlide.maximumValue = 999
            mpStep.maximumValue = 999
            ammoStep.maximumValue = 999
            ammoSlide.maximumValue = 999
            rationStep.maximumValue = 999
            rationSlide.maximumValue = 999
            partsSetp.maximumValue = 999
            partsSlide.maximumValue = 999
            
            mpSlide.minimumValue = 30
            mpStep.minimumValue = 30
            ammoStep.minimumValue = 30
            ammoSlide.minimumValue = 30
            rationStep.minimumValue = 30
            rationSlide.minimumValue = 30
            partsSetp.minimumValue = 30
            partsSlide.minimumValue = 30
            
        case 1:
            sender.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            mpStep.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            mpSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            ammoStep.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            ammoSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            rationStep.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            rationSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            partsSetp.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            partsSlide.tintColor = UIColor(red: 94/255, green: 155/255, blue: 255/255, alpha: 1.0)
            
            mpSlide.maximumValue = 300
            mpStep.maximumValue = 300
            ammoStep.maximumValue = 300
            ammoSlide.maximumValue = 300
            rationStep.maximumValue = 300
            rationSlide.maximumValue = 300
            partsSetp.maximumValue = 300
            partsSlide.maximumValue = 300
            
            mpSlide.minimumValue = 10
            mpStep.minimumValue = 10
            ammoStep.minimumValue = 10
            ammoSlide.minimumValue = 10
            rationStep.minimumValue = 10
            rationSlide.minimumValue = 10
            partsSetp.minimumValue = 10
            partsSlide.minimumValue = 10
            
        default:
            break
        }
        updateValue()
    }
    
    func selectLocal(types: [String]){
        var sql = "select * from info inner join buff on buff.ID = info.ID inner join consumption on consumption.ID = info.ID inner join obtain on obtain.ID = info.ID inner join skill on skill.ID = info.ID inner join stats on stats.ID = info.ID where ((info.type = 'SMG')"
        for type in types{
            switch type{
                case "HG":
                    sql += " OR (info.type = 'HG')"
                    continue
                case "5SHG":
                    sql += " OR (info.type = 'HG' AND info.Stars = 5)"
                    continue
                case "5SSMG":
                    sql += " OR (info.type = 'SMG' AND info.Stars = 5)"
                    continue
                case "AR":
                    sql += " OR (info.type = 'AR')"
                    continue
                case "5SAR":
                    sql += " OR (info.type = 'AR' AND info.Stars = 5)"
                    continue
                case "RF":
                    sql += " OR (info.type = 'RF')"
                    continue
                case "5SRF":
                    sql += " OR (info.type = 'RF' AND info.Stars = 5)"
                    continue
                case "MG":
                    sql += " OR (info.type = 'MG')"
                    continue
                case "5SMG":
                    sql += " OR (info.type = 'MG' AND info.Stars = 5)"
                    continue
                default:
                    continue
            }
        }
        sql += ") AND obtain.build_time != '00:00:00' AND obtain.obtain_method NOT LIKE '%重型人形製造限定%' "
        localSearch.search(sql: sql)
    }
    func selectLocalE(types: [String]){
        var sql = "select * from info_e where Build_Time != '00:00:00' AND "
        var cond = [String]()
        for type in types {
            switch type{
            case "瞄具":
                cond.append("Type LIKE '%瞄具%'")
            case "all":
                cond.append("1")
            case "4S消音器":
                cond.append("(Type = '消音器' AND Star = 4)")
            case "5S消音器":
                cond.append("(Type = '消音器' AND Star = 5)")
            case "4S高速彈":
                cond.append("Type = '高速彈' AND Star = 4)")
            case "5S高速彈":
                cond.append("(Type = '高速彈' AND Star = 5)")
            case "4S穿甲彈":
                cond.append("(Type = '穿甲彈' AND Star = 4)")
            case "5S穿甲彈":
                cond.append("(Type = '穿甲彈' AND Star = 4)")
            case "4S瞄具":
                cond.append("(Type LIKE '%瞄具%' AND Star = 4)")
            case "5S瞄具":
                cond.append("(Type LIKE '%瞄具%' AND Star = 5)")
            case "4S夜戰裝備":
                cond.append("(Type = '夜戰裝備' AND Star = 4)")
            case "5S夜戰裝備":
                cond.append("(Type = '夜戰裝備' AND Star = 5)")
            case "4S外骨骼":
                cond.append("(Type LIKE '%外骨骼%' AND Star = 4)")
            case "5S外骨骼":
                cond.append("(Type LIKE '%外骨骼%' AND Star = 5)")
            case "4S偽裝披風":
                cond.append("(Type = '偽裝披風' AND Star = 4)")
            case "5S偽裝披風":
                cond.append("(Type = '偽裝披風' AND Star = 5)")
            case "5S彈藥箱":
                cond.append("(Type = '彈藥箱' AND Star = 5)")
            default:
                continue
            }
        }
        sql += "("
        for stm in cond {
            sql += stm
            if stm != cond.last{
                sql += " OR "
            }
        }
        sql += ")"
        
        localSearch.search_e(sql: sql)
        
    }
    func selectTDoll(){
        let index = Int.random(in: 0..<downloadStrings.count)
        let downloadString = downloadStrings.shuffled()[index]
        searchResult.urlPath = downloadString
        searchResult.downloadItems()
    }
    func selectEquip(){
        let index = Int.random(in: 0..<downloadStrings.count)
        let downloadString = downloadStrings.shuffled()[index]
        searchE.urlPath = downloadString
        searchE.downloadItems()
    }
    func updateValue(){
        
        if mpSlide.value < mpSlide.minimumValue {
            mpSlide.value = mpSlide.minimumValue
        }else if mpSlide.value > mpSlide.maximumValue{
            mpSlide.value = mpSlide.maximumValue
        }
        
        if ammoSlide.value < ammoSlide.minimumValue {
            ammoSlide.value = ammoSlide.minimumValue
        }else if ammoSlide.value > ammoSlide.maximumValue{
            ammoSlide.value = ammoSlide.maximumValue
        }
        
        if rationSlide.value < rationSlide.minimumValue {
            rationSlide.value = rationSlide.minimumValue
        }else if rationSlide.value > rationSlide.maximumValue{
            rationSlide.value = rationSlide.maximumValue
        }
        
        if partsSlide.value < partsSlide.minimumValue {
            partsSlide.value = partsSlide.minimumValue
        }else if partsSlide.value > partsSlide.maximumValue{
            partsSlide.value = partsSlide.maximumValue
        }
        
        mpStep.value = Double(mpSlide.value)
        ammoStep.value = Double(ammoSlide.value)
        rationStep.value = Double(rationSlide.value)
        partsSetp.value = Double(partsSlide.value)
        
        manPower = Int(mpStep.value)
        ammo = Int(ammoStep.value)
        ration = Int(rationStep.value)
        parts = Int(partsSetp.value)
        
        mpValue.text = String(manPower)
        ammoValue.text = String(ammo)
        rationValue.text = String(ration)
        partsValue.text = String(parts)
    }
    func buildOnline(types: [String]){
        
        counter = 0
        downloadStrings.removeAll()
        
        for type in types{
            switch type{
            case "HG":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?build=HG&buildable")
                continue
            case "AR":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?build=AR&buildable")
                continue
            case "RF":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?build=RF&buildable")
                continue
            case "MG":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?build=MG&buildable")
                continue
            case "5SHG":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?type=HG&star=5&buildable")
                continue
            case "5SSMG":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?type=SMG&star=5&buildable")
                continue
            case "5SAR":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?type=AR&star=5&buildable")
                continue
            case "5SRF":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?type=RF&star=5&buildable")
                continue
            case "5SMG":
                downloadStrings.append("https://dollbox.scarletsc.net/search.php?type=MG&star=5&buildable")
                continue
            default:
                continue
            }
        }
    }
    func buildEOnline(types: [String]){
        
        counter = 0
        downloadStrings.removeAll()
        
        for type in types {
            switch type{
            case "瞄具":
                let t = "瞄具".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&b")
            case "all":
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?b")
            case "4S消音器":
                let t = "消音器".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=4&b")
            case "5S消音器":
                let t = "消音器".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            case "4S高速彈":
                let t = "高速彈".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=4&b")
            case "5S高速彈":
                let t = "高速彈".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            case "4S穿甲彈":
                let t = "穿甲彈".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=4&b")
            case "5S穿甲彈":
                let t = "穿甲彈".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            case "4S瞄具":
                let t = "瞄具".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=4&b")
            case "5S瞄具":
                let t = "瞄具".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            case "4S夜戰裝備":
                let t = "夜戰裝備".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=4&b")
            case "5S夜戰裝備":
                let t = "夜戰裝備".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            case "4S外骨骼":
                let t = "外骨骼".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=4&b")
            case "5S外骨骼":
                let t = "外骨骼".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            case "4S偽裝披風":
                let t = "偽裝披風".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=4&b")
            case "5S偽裝披風":
                let t = "偽裝披風".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            case "5S彈藥箱":
                let t = "彈藥箱".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                downloadStrings.append("https://dollbox.scarletsc.net/search_e?type=\(t)&star=5&b")
            default:
                continue
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.delegate = self
        resultView.dataSource = self
        localSearch.delegate = self
        searchE.delegate = self
        searchResult.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor().white(self)
        updateValue()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TdollDetailSegue" {
            
            let detailVC  = segue.destination as! TDollViewController
            
            selectedTDoll = resultT
            
            detailVC.selectedTDoll = self.selectedTDoll
            if let imgPath = self.selectedTDoll.photo_path{
                detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://dollbox.scarletsc.net/img/\(imgPath)") as AnyObject) as? UIImage
            }
            if userDefaults.bool(forKey: "offlineImg"){
                if let id = self.selectedTDoll.ID{
                    detailVC.selectedImg = imgCache.object(forKey: id as AnyObject) as? UIImage
                }
            }
        }
        
        if segue.identifier == "historySegue"{
            
            let statVC = segue.destination as! BuildStatsViewController
            
            switch typeSwitch.selectedSegmentIndex{
                case 0:
                    statVC.type = "T"
                case 1:
                    statVC.type = "E"
                default:
                    break
            }
            
        }
    }

}
