//
//  BuildStatsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 28/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class BuildStatsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let imgCache = Session.sharedInstance.loadImgSession()
    
    var selectedTDoll: TDoll = TDoll()
    var constructTDoll: NSMutableArray = NSMutableArray()
    var sortedTDoll = NSMutableArray()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return constructTDoll.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier: String = "BasicCell"
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ResultCollectionViewCell
  
        let item: TDoll = sortedTDoll[indexPath.row] as! TDoll
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
        for i in 0..<constructTDoll.count{
            sortedTDoll.add(constructTDoll[constructTDoll.index(of: constructTDoll.lastObject!) - i])
        }
        resultView.delegate = self
        resultView.dataSource = self
        
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
            selectedTDoll = sortedTDoll[(indexPath?.row)!] as! TDoll
        }
        detailVC.selectedTDoll = self.selectedTDoll
        if let imgPath = self.selectedTDoll.photo_path{
            detailVC.selectedImg = imgCache.object(forKey: URL(string: "https://scarletsc.net/girlfrontline/img/\(imgPath)") as AnyObject) as? UIImage
        }
        detailVC.from = "stats"
    }
    
}
