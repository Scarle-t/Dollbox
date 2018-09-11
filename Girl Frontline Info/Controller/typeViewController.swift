//
//  typeViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class typeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, getSearchProtocol {
    
    let imgCache = Session.sharedInstance.imgSession

    var feedItems: NSArray = NSArray()
    
    var selectedTDoll: TDoll = TDoll()
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        listResult.reloadData()
    }
    
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
        
        myCell.contentView.frame = myCell.bounds
        
        return myCell
        
    }
    
    @IBOutlet weak var listResult: UICollectionView!
    @IBOutlet weak var navBarStars: UISegmentedControl!
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        
        if navBarStars.selectedSegmentIndex != 0{
            navBarStars.selectedSegmentIndex = navBarStars.selectedSegmentIndex - 1
            swipeResult()
        }
        
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        
        if navBarStars.selectedSegmentIndex != 5{
            navBarStars.selectedSegmentIndex = navBarStars.selectedSegmentIndex + 1
            swipeResult()
        }
        
    }
    
    func swipeResult(){
        
        switch navBarStars.selectedSegmentIndex {
            
        case 0:
            
            let searchResult = getSearchResult()
            searchResult.delegate = self
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=HG"
            
            searchResult.downloadItems()
            
        case 1:
            
            let searchResult = getSearchResult()
            searchResult.delegate = self
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=SMG"
            
            searchResult.downloadItems()
            
        case 2:
            
            let searchResult = getSearchResult()
            searchResult.delegate = self
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=RF"
            
            searchResult.downloadItems()
            
        case 3:
            
            let searchResult = getSearchResult()
            searchResult.delegate = self
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=AR"
            
            searchResult.downloadItems()
            
        case 4:
            
            let searchResult = getSearchResult()
            searchResult.delegate = self
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=MG"
            
            searchResult.downloadItems()
            
        case 5:
            
            let searchResult = getSearchResult()
            searchResult.delegate = self
            searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=SG"
            
            searchResult.downloadItems()
            
        default:
            if let string = navBarStars.titleForSegment(
                at: navBarStars.selectedSegmentIndex){
                print(string)
            }
        }
    }
    
    
    
    @IBAction func navbBarStars(_ sender: UISegmentedControl) {
        
        swipeResult()
        
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        listResult.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imgCache.evictsObjectsWithDiscardedContent = false
        
        listResult.delegate = self
        listResult.dataSource = self
        
        navBarStars.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Mohave", size: 17)
            ], for: UIControlState.normal)
        
        navBarStars.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Mohave", size: 17)
            ], for: UIControlState.selected)
        
        let searchResult = getSearchResult()
        searchResult.delegate = self
        searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?type=HG"
        
        searchResult.downloadItems()
        
        swipeResult()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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