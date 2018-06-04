//
//  BuildSimulatorViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 27/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildSimulatorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    let imgCache = Session.sharedInstance.imgSession
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        // Get the location to be shown
        
        let item: TDoll = result
        // Get references to labels of cell
        
        if let photo_path = item.photo_path{
            
            let urlString = URL(string: "https://scarletsc.net/girlfrontline/img/\(photo_path)")
            
            let url = URL(string: "https://scarletsc.net/girlfrontline/img/\(photo_path)")
            
            if let imageFromCache = self.imgCache.object(forKey: url as AnyObject) as? UIImage{
                
                myCell.imgResult.image = imageFromCache
                
            }else{
                
                getDataFromUrl(url: url!) { data, response, error in
                    guard let imgData = data, error == nil else { return }
                    print(url!)
                    print("Download Finished")
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        //tdoll.photo = UIImage(data: imgData)
                        
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
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    //var feedItems = NSMutableArray()
    
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
    
    var result: TDoll = TDoll()
    
    func selectTDoll(){
        
        let index = Int(arc4random_uniform(UInt32(downloadStrings.count - 1)))
        
        let downloadString = downloadStrings[index]
        
        searchResult.urlPath = downloadString
        
        searchResult.downloadItems()
        
    }
    
    @IBOutlet weak var resultView: UICollectionView!
    
    @IBOutlet weak var sepBuildType: UISegmentedControl!
    
    @IBOutlet var upDownArrow: [UIButton]!
    
    @IBOutlet var upButtons: [UIButton]!
    @IBOutlet var downButtons: [UIButton]!
    
    @IBOutlet var values: [UITextField]!
    
    @IBOutlet var manPowerValues: [UITextField]!
    @IBOutlet var ammoValues: [UITextField]!
    @IBOutlet var rationValues: [UITextField]!
    @IBOutlet var partsValues: [UITextField]!
    
    @IBOutlet var frames: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        resultView.delegate = self
        resultView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func valueUp(_ sender: UIButton){
        
        if let index = upButtons.index(of: sender){
            
            
            switch sepBuildType.selectedSegmentIndex{
                
            case 1:
                if values[2].text == "3" && (index == 0 || index == 1 || index == 2){
                    
                    switch index {
                        
                    case 0, 1, 2:
                        
                        values[0].text = "0"
                        values[1].text = "0"
                        values[2].text = "3"
                        
                    default:
                        break
                    }
                    
                    
                }else if values[5].text == "3" && (index == 3 || index == 4 || index == 5){
                    
                    switch index {
                        
                    case 3, 4, 5:
                        
                        values[3].text = "0"
                        values[4].text = "0"
                        values[5].text = "3"
                        
                    default:
                        break
                    }
                    
                }else if values[8].text == "3" && (index == 6 || index == 7 || index == 8){
                    
                    switch index {
                        
                    case 6, 7, 8:
                        
                        values[6].text = "0"
                        values[7].text = "0"
                        values[8].text = "3"
                        
                    default:
                        break
                    }
                    
                }else if values[11].text == "3" && (index == 9 || index == 10 || index == 11){
                    
                    switch index {
                        
                    case 9, 10, 11:
                        
                        values[9].text = "0"
                        values[10].text = "0"
                        values[11].text = "3"
                        
                    default:
                        break
                    }
                    
                }else{

                    if values[index].text != "9"{
                        values[index].text = "\(Int(values[index].text!)! + 1)"
                    }else if values[index].text == "9"{
                        if index == 0 || index == 1 || index == 3 || index == 4 || index == 6 || index == 7 || index == 9 || index == 10{
                            if values[index + 1].text != "9"{
                                values[index].text = "0"
                                values[index+1].text = "\(Int(values[index+1].text!)! + 1)"
                            }else{
                                if index == 0 || index == 3 || index == 6 || index == 9{
                                    if values[index + 2].text != "9"{
                                        values[index].text = "0"
                                        values[index + 1].text = "0"
                                        values[index+2].text = "\(Int(values[index+2].text!)! + 1)"
                                    }
                                }
                            }
                        }
                    }
                }
            default:
                if values[index].text != "9"{
                    values[index].text = "\(Int(values[index].text!)! + 1)"
                }else if values[index].text == "9"{
                    if index == 0 || index == 1 || index == 3 || index == 4 || index == 6 || index == 7 || index == 9 || index == 10{
                        if values[index + 1].text != "9"{
                            values[index].text = "0"
                            values[index+1].text = "\(Int(values[index+1].text!)! + 1)"
                        }else{
                            if index == 0 || index == 3 || index == 6 || index == 9{
                                if values[index + 2].text != "9"{
                                    values[index].text = "0"
                                    values[index + 1].text = "0"
                                    values[index+2].text = "\(Int(values[index+2].text!)! + 1)"
                                }
                                
                            }
                        }
                    }
                }
            }
            
            
            
        }
    }
    
    @IBAction func valueDown(_ sender: UIButton){
        
        switch sepBuildType.selectedSegmentIndex{
        case 0:
            
            if let index = downButtons.index(of: sender){
                if let value = values[index].text{
                    
                    if index == 1 || index == 4 || index == 7 || index == 10{
                        
                        if values[index + 1].text == "0"{
                            if value != "3"{
                                values[index].text = "\(Int(value)! - 1)"
                            }
                        }else{
                            if value == "0"{
                                values[index].text = "9"
                                values[index + 1].text = "\(Int(values[index + 1].text!)! - 1)"
                            }else{
                                values[index].text = "\(Int(value)! - 1)"
                            }
                            
                        }
   
                    }else{
                        if value != "0"{
                            values[index].text = "\(Int(value)! - 1)"
                        }
                    }
                }
            }
            
        case 1:
            
            if let index = downButtons.index(of: sender){
                if let value = values[index].text{
                    
                    if index == 1 || index == 4 || index == 7 || index == 10{
                        
                        if values[index + 1].text == "0"{
                            if value != "1"{
                                values[index].text = "\(Int(value)! - 1)"
                            }
                        }else{
                            if value == "0"{
                                values[index].text = "9"
                                values[index + 1].text = "\(Int(values[index + 1].text!)! - 1)"
                            }else{
                                values[index].text = "\(Int(value)! - 1)"
                            }
                            
                        }
                        
                    }else{
                        if value != "0"{
                            values[index].text = "\(Int(value)! - 1)"
                        }
                    }
                }
            }
            
            
        default:
            break
        }
        
    }
    
    @IBAction func typeChange(_ sender: UISegmentedControl) {
       
        switch sender.selectedSegmentIndex{
            
        case 0:
            for index in upDownArrow{
                
                index.backgroundColor = UIColor(red: 144/255, green: 198/255, blue: 53/255, alpha: 1.0)
                
            }
            
            for index in frames{
                index.image = #imageLiteral(resourceName: "green_box")
            }
            
            for index in values{
                if values.index(of: index) == 1 || values.index(of: index) == 4 || values.index(of: index) == 7 || values.index(of: index) == 10{
                    
                    index.text = "3"
                    
                }
                else{
                    index.text = "0"
                }
            }
            
        case 1:
            for index in upDownArrow{
                
                index.backgroundColor = UIColor(red: 50/255, green: 195/255, blue: 191/255, alpha: 1.0)
                
            }
            
            for index in frames{
                index.image = #imageLiteral(resourceName: "box_blue")
            }
            
            for index in values{
                if values.index(of: index) == 1 || values.index(of: index) == 4 || values.index(of: index) == 7 || values.index(of: index) == 10{
                    
                    index.text = "1"
                    
                }
                else{
                    index.text = "0"
                }
            }
            
        default:
            break
            
        }
    }
    
    var appearType: [String] = ["SMG"]
    
    var downloadStrings: [String] = ["https://scarletsc.net/girlfrontline/BuildType_search.php?type=SMG"]

    @IBAction func finishButton(_ sender: UIButton) {
        
        self.resultView.isHidden = true
        
        let manPower = Int(manPowerValues[0].text! + manPowerValues[1].text! + manPowerValues[2].text!)
        let ammo = Int(ammoValues[0].text! + ammoValues[1].text! + ammoValues[2].text!)
        let ration = Int(rationValues[0].text! + rationValues[1].text! + rationValues[2].text!)
        let parts = Int(partsValues[0].text! + partsValues[1].text! + partsValues[2].text!)
        
        let total = manPower! + ammo! + ration! + parts!
        
        totalUsedAmmo += ammo!
        totalUsedParts += parts!
        totalUsedRation += ration!
        totalUsedManPower += manPower!

        if total < 920 {
            if manPower! >= 130 && ammo! >= 130 && ration! >= 130 && parts! >= 130{
                appearType.append("5SHG")
            }
            
            appearType.append("HG")
            
        }
        
        if total > 800 {
            if manPower! >= 30 && ammo! >= 400 && ration! >= 400 && parts! >= 30{
                appearType.append("5SAR")
            }else{
                appearType.append("AR")
            }
            
        }
        
        if manPower! >= 400 && ammo! >= 400 && ration! >= 30 && parts! >= 30{
            appearType.append("5SSMG")
        }
        
        if manPower! >= 300 && ration! >= 300{
            if manPower! >= 400 && ammo! >= 30 && ration! >= 400 && parts! >= 30{
                appearType.append("5SRF")
            }
            appearType.append("RF")
        }
        
        if manPower! >= 400 && ammo! >= 600 && parts! >= 300{
            if manPower! >= 600 && ammo! >= 600 && ration! >= 100 && parts! >= 400{
                appearType.append("5SMG")
            }
            appearType.append("MG")
        }
        
        build(types: appearType)
        
        selectTDoll()
    
        resultView.isHidden = false
    
    }
    
    var counter = 0
    
    let searchResult = getSearchResult()
    
    func build(types: [String]){
        
        searchResult.delegate = self
        
        counter = 0
        
        downloadStrings.removeAll()
        
        for type in types{
            
            switch type{
                
            case "HG":
                
                downloadStrings.append("https://scarletsc.net/girlfrontline/BuildType_search.php?type=HG")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/BuildType_search.php?type=HG"
                
                
                
                continue
            case "AR":
                
                downloadStrings.append("https://scarletsc.net/girlfrontline/BuildType_search.php?type=AR")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/BuildType_search.php?type=AR"
                
                
                
                continue
            case "RF":
                
                downloadStrings.append("https://scarletsc.net/girlfrontline/BuildType_search.php?type=RF")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/BuildType_search.php?type=RF"
                
                
                
                continue
            case "MG":
                
                downloadStrings.append("https://scarletsc.net/girlfrontline/BuildType_search.php?type=MG")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/BuildType_search.php?type=MG"
                
                
                continue
            case "5SHG":

                downloadStrings.append("https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=HG&star=5")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=HG&star=5"

                
                continue
            case "5SSMG":

                downloadStrings.append("https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=SMG&star=5")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=SMG&star=5"
                
                
                continue
            case "5SAR":

                downloadStrings.append("https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=AR&star=5")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=AR&star=5"
                

                
                continue
            case "5SRF":

                downloadStrings.append("https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=RF&star=5")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=RF&star=5"
                

                
                continue
            case "5SMG":

                downloadStrings.append("https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=MG&star=5")
//                searchResult.urlPath = "https://scarletsc.net/girlfrontline/typeANDstar_search.php?type=MG&star=5"
                

                
                continue
            default:
                continue
            }
            
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
