//
//  BuildtimeSearchCollectionViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildtimeSearchCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate ,getSearchProtocol {
    
    let hr = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21" ,"22", "23"]
    let minAndSec = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21" ,"22", "23", "24", "25", "26", "27", "28", "29", "30", "31" ,"32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0{
            return hr.count
        }
        
        return minAndSec.count


    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return hr[row]
        }
        
        return minAndSec[row]

    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Mohave", size: 35)
            pickerLabel?.textAlignment = .center
        }
        if component == 0{
            pickerLabel?.text = hr[row]
        }else{
            pickerLabel?.text = minAndSec[row]
        }
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            txtHour.text = hr[row]
        case 1:
            txtMinute.text = minAndSec[row]
        case 2:
            txtSecond.text = minAndSec[row]
        default:
            break
        }
        
    }
    
    let imgCache = Session.sharedInstance.imgSession
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        // Get the location to be shown
        let item: TDoll = feedItems[indexPath.row] as! TDoll
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
        
        
        
        return myCell
    }
    

    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.collectionResult.reloadData()
    }

    @IBAction func btnTimeSearch(_ sender: UIButton) {
        
        view.endEditing(true)
        
        let searchResult = getSearchResult()
        searchResult.delegate = self
        
        if let hour = txtHour.text,
            let minute = txtMinute.text,
            let second = txtSecond.text{
            
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?hour=\(hour)&minute=\(minute)&second=\(second)"
            
        }
        
        searchResult.downloadItems()
        
    }
    
    @IBOutlet weak var txtHour: UITextField!
    @IBOutlet weak var txtMinute: UITextField!
    @IBOutlet weak var txtSecond: UITextField!
    
    @IBOutlet weak var collectionResult: UICollectionView!
    
    var feedItems : NSArray = NSArray()
    
    var selectedTDoll: TDoll = TDoll()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtSecond.inputView = pickerView
        txtMinute.inputView = pickerView
        txtHour.inputView = pickerView
        
        collectionResult.delegate = self
        collectionResult.dataSource = self
        
        self.title = "製造時間搜尋"
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        tabBarController?.tabBar.barTintColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
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

    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
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
