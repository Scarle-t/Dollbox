//
//  SelectTDollViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 31/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class SelectTDollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, getSearchProtocol {
    
    var from: String = ""
    
    var feedItems: NSArray = [TDoll()]
    
    var displayItems: NSMutableArray = [TDoll()]
    
    var selectedTDoll: TDoll = TDoll()
    
    let imgCache = Session.sharedInstance.loadImgSession()
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        displayItems.removeAllObjects()
        for item in feedItems{
            displayItems.add(item)
        }
        
        resultView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
        // Get the location to be shown
        
        let item: TDoll = displayItems[indexPath.row] as! TDoll
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        Session.sharedInstance.selected = true
        
        Session.sharedInstance.selectedTDoll = displayItems[indexPath.row] as! TDoll
        
        let myCell = resultView.cellForItem(at: indexPath) as! ResultCollectionViewCell
        
        Session.sharedInstance.selectedTDImage = myCell.imgResult.image!
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var resultView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(from)
        
        resultView.delegate = self
        resultView.dataSource = self
        
        let searchResult = getSearchResult()
        searchResult.delegate = self
        searchResult.urlPath = "https://scarletsc.net/girlfrontline/allTDoll.php"
        searchResult.downloadItems()
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.3
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        resultView.addGestureRecognizer(lpgr)
        
        typeIndicator.text = typeControl.titleForSegment(at: typeControl.selectedSegmentIndex)
        
        rareIndicator.text = rareControl.titleForSegment(at: rareControl.selectedSegmentIndex)
        
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
//        if gestureReconizer.state != UIGestureRecognizerState.ended {
//            return
//        }
        
        let p = gestureReconizer.location(in: self.resultView)
        let indexPath = self.resultView.indexPathForItem(at: p)
        
        if let index = indexPath {
            
            // do stuff with your cell, for example print the indexPath
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "detailVC") as! TDollViewController
            controller.selectedTDoll = displayItems[index.row] as? TDoll
            controller.from = "stats"
            
            let myCell = resultView.cellForItem(at: index) as! ResultCollectionViewCell
            
            controller.selectedImg = myCell.imgResult.image
            
            print(index.row)
            self.present(controller, animated: true, completion: nil)
        } else {
            print("Could not find index path")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var rareControl: UISegmentedControl!
    
    @IBOutlet weak var typeControl: UISegmentedControl!
    
    @IBOutlet weak var typeIndicator: UILabel!
    
    @IBOutlet weak var rareIndicator: UILabel!
    
    var selectedType: String = ""
    var selectedRare: String = ""
    
    @IBAction func rareChange(_ sender: UISegmentedControl) {
        
        rareIndicator.text = sender.titleForSegment(at: sender.selectedSegmentIndex)
        selectedRare = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    @IBAction func typeChange(_ sender: UISegmentedControl) {

        typeIndicator.text = sender.titleForSegment(at: sender.selectedSegmentIndex)
        selectedType = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    @IBAction func btnDismiss(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var dimView: UIView!
    
    @IBAction func dimTap(_ sender: UITapGestureRecognizer) {
        
        filterView.isHidden = true
        dimView.isHidden = true
        displayItem()
        resultView.reloadData()
    }
    
    func displayItem(){
        
        displayItems.removeAllObjects()
        
        if selectedType == "HG"{
            if selectedRare == "2☆"{
                for item in feedItems{
                    
                    if (item as! TDoll).type == "HG" && (item as! TDoll).stars == "2"{
                        displayItems.add(item)
                    }
                    
                }
            }else if selectedRare == "3☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "HG" && (item as! TDoll).stars == "3"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "4☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "HG" && (item as! TDoll).stars == "4"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "5☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "HG" && (item as! TDoll).stars == "5"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "EXTRA"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "HG" && (item as! TDoll).stars == "EXTRA"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "ALL"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "HG"{
                        displayItems.add(item)
                    }
                    
                }
                
            }
        }
        
        if selectedType == "SMG"{
            if selectedRare == "2☆"{
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SMG" && (item as! TDoll).stars == "2"{
                        displayItems.add(item)
                    }
                    
                }
            }else if selectedRare == "3☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SMG" && (item as! TDoll).stars == "3"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "4☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SMG" && (item as! TDoll).stars == "4"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "5☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SMG" && (item as! TDoll).stars == "5"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "EXTRA"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SMG" && (item as! TDoll).stars == "EXTRA"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "ALL"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SMG"{
                        displayItems.add(item)
                    }
                    
                }
                
            }
        }
        
        if selectedType == "AR"{
            if selectedRare == "2☆"{
                for item in feedItems{
                    
                    if (item as! TDoll).type == "AR" && (item as! TDoll).stars == "2"{
                        displayItems.add(item)
                    }
                    
                }
            }else if selectedRare == "3☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "AR" && (item as! TDoll).stars == "3"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "4☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "AR" && (item as! TDoll).stars == "4"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "5☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "AR" && (item as! TDoll).stars == "5"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "EXTRA"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "AR" && (item as! TDoll).stars == "EXTRA"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "ALL"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "AR"{
                        displayItems.add(item)
                    }
                    
                }
                
            }
        }
        
        if selectedType == "RF"{
            if selectedRare == "2☆"{
                for item in feedItems{
                    
                    if (item as! TDoll).type == "RF" && (item as! TDoll).stars == "2"{
                        displayItems.add(item)
                    }
                    
                }
            }else if selectedRare == "3☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "RF" && (item as! TDoll).stars == "3"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "4☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "RF" && (item as! TDoll).stars == "4"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "5☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "RF" && (item as! TDoll).stars == "5"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "EXTRA"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "RF" && (item as! TDoll).stars == "EXTRA"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "ALL"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "RF"{
                        displayItems.add(item)
                    }
                    
                }
                
            }
        }
        
        if selectedType == "MG"{
            if selectedRare == "2☆"{
                for item in feedItems{
                    
                    if (item as! TDoll).type == "MG" && (item as! TDoll).stars == "2"{
                        displayItems.add(item)
                    }
                    
                }
            }else if selectedRare == "3☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "MG" && (item as! TDoll).stars == "3"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "4☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "MG" && (item as! TDoll).stars == "4"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "5☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "MG" && (item as! TDoll).stars == "5"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "EXTRA"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "MG" && (item as! TDoll).stars == "EXTRA"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "ALL"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "MG"{
                        displayItems.add(item)
                    }
                    
                }
                
            }
        }
        
        if selectedType == "SG"{
            if selectedRare == "2☆"{
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SG" && (item as! TDoll).stars == "2"{
                        displayItems.add(item)
                    }
                    
                }
            }else if selectedRare == "3☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SG" && (item as! TDoll).stars == "3"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "4☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SG" && (item as! TDoll).stars == "4"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "5☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SG" && (item as! TDoll).stars == "5"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "EXTRA"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SG" && (item as! TDoll).stars == "EXTRA"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "ALL"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).type == "SG"{
                        displayItems.add(item)
                    }
                    
                }
                
            }
        }
        
        if selectedType == "ALL"{
            if selectedRare == "2☆"{
                for item in feedItems{
                    
                    if (item as! TDoll).stars == "2"{
                        displayItems.add(item)
                    }
                    
                }
            }else if selectedRare == "3☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).stars == "3"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "4☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).stars == "4"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "5☆"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).stars == "5"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "EXTRA"{
                
                for item in feedItems{
                    
                    if (item as! TDoll).stars == "EXTRA"{
                        displayItems.add(item)
                    }
                    
                }
                
            }else if selectedRare == "ALL"{
                
                for item in feedItems{
                    
                    displayItems.add(item)
                    
                }
                
            }
        }
        
    }
    
    @IBAction func openFilter(_ sender: UIButton) {
        
        switch filterView.isHidden {
        case true:
            filterView.isHidden = false
            dimView.isHidden = false
        case false:
            filterView.isHidden = true
            dimView.isHidden = true
            
            displayItem()
            
        default:
            break
        }
        
        resultView.reloadData()
        
    }
    
    
    var initialTouchPoint = CGPoint.zero
    
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
