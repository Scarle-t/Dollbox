//
//  BuildSimulatorViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 27/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildSimulatorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol {
    
    let imgCache = Session.sharedInstance.imgSession
    let searchResult = getSearchResult()
    
    var counter = 0
    var selectedTDoll: TDoll = TDoll()
    var constructedTDolls: NSMutableArray = NSMutableArray()
    var constructTime = 0
    var totalUsedManPower = 0
    var totalUsedAmmo = 0
    var totalUsedRation = 0
    var totalUsedParts = 0
    var total5Star = 0
    var total4Star = 0
    var total3Star = 0
    var total2Star = 0
    var result: TDoll = TDoll()
    var appearType: [String] = ["SMG"]
    var downloadStrings: [String] = ["https://scarletsc.net/girlfrontline/search.php?build=SMG"]
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
        let item: TDoll = result
        
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
    func itemsDownloaded(items: NSArray) {
        if items.count != 0{
            let index = Int(arc4random_uniform(UInt32(items.count - 1)))
            result = items[index] as! TDoll
            constructedTDolls.add(result)
            switch result.stars{
            case "2":
                total2Star += 1
            case "3":
                total3Star += 1
            case "4":
                total4Star += 1
            case "5":
                total5Star += 1
            default:
                break
            }
            counter += 1
            constructTime += 1
            resultView.reloadData()
        }
    }

    @IBOutlet weak var resultView: UICollectionView!
    @IBOutlet weak var sepBuildType: UISegmentedControl!
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
        appearType.removeAll()
        appearType.append("SMG")
        let total = manPower + ammo + ration + parts
        totalUsedAmmo += ammo
        totalUsedParts += parts
        totalUsedRation += ration
        totalUsedManPower += manPower
        
        build(types: pickType().pick(total: total, manPower: manPower, ammo: ammo, ration: ration, parts: parts))
        selectTDoll()
        resultView.isHidden = false
        
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
    
    func selectTDoll(){
        let index = Int(arc4random_uniform(UInt32(downloadStrings.count - 1)))
        let downloadString = downloadStrings[index]
        searchResult.urlPath = downloadString
        searchResult.downloadItems()
    }
    func updateValue(){
        mpValue.text = String(manPower)
        ammoValue.text = String(ammo)
        rationValue.text = String(ration)
        partsValue.text = String(parts)
    }
    func build(types: [String]){
        searchResult.delegate = self
        counter = 0
        downloadStrings.removeAll()
        
        for type in types{
            switch type{
            case "HG":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?build=HG")
                continue
            case "AR":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?build=AR")
                continue
            case "RF":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?build=RF")
                continue
            case "MG":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?build=MG")
                continue
            case "5SHG":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?type=HG&star=5")
                continue
            case "5SSMG":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?type=SMG&star=5")
                continue
            case "5SAR":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?type=AR&star=5")
                continue
            case "5SRF":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?type=RF&star=5")
                continue
            case "5SMG":
                downloadStrings.append("https://scarletsc.net/girlfrontline/search.php?type=MG&star=5")
                continue
            default:
                continue
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resultView.delegate = self
        resultView.dataSource = self
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
            
            selectedTDoll = result
            
            detailVC.selectedTDoll = self.selectedTDoll
            if let imgPath = self.selectedTDoll.photo_path{
                detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://scarletsc.net/girlfrontline/img/\(imgPath)") as AnyObject) as? UIImage
            }
            
        }
        
        if segue.identifier == "historySegue"{
            
            let statVC = segue.destination as! BuildStatsViewController
            
            statVC.constructTDoll = self.constructedTDolls
            statVC.total5Star = self.total5Star
            statVC.total4Star = self.total4Star
            statVC.total3Star = self.total3Star
            statVC.total2Star = self.total2Star
            statVC.totalManPower = self.totalUsedManPower
            statVC.totalAmmo = self.totalUsedAmmo
            statVC.totalRation = self.totalUsedRation
            statVC.totalParts = self.totalUsedParts
            
        }
    }

}
