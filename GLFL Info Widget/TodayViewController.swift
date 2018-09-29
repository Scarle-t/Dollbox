//
//  TodayViewController.swift
//  GLFL Info Widget
//
//  Created by Scarlet on 15/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource, getSearchProtocol {

    let searchResult = getSearchResult()
    var selectedBtn: UIButton?
    var feedItems = NSArray()
    var originalTint = UIColor()
    var hr = 0
    var min = 0
    var sec = 0
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        listResult.reloadData()
        btnOpenApp.isHidden = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        // Get the location to be shown
        let item: TDoll = feedItems[indexPath.row] as! TDoll
        // Get references to labels of cell
        myCell.textLabel!.text = item.Zh_Name
        myCell.textLabel!.textAlignment = .center
        return myCell
    }
    
    @IBOutlet weak var largeView: UIView!
    @IBOutlet weak var btnOpenApp: UIButton!
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet weak var minbtn: UIButton!
    @IBOutlet weak var secbtn: UIButton!
    @IBOutlet weak var listResult: UITableView!
    @IBAction func btnSearch(_ sender: UIButton) {
        searchResult.delegate = self
        searchResult.urlPath = "https://scarletsc.net/girlfrontline/search.php?hour=\(hr)&minute=\(min)&second=\(sec)"
        searchResult.downloadItems()
    }
    @IBAction func btnHr(_ sender: UIButton) {
        hrBtn.tintColor = UIColor(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0)
        minbtn.tintColor = UIColor.black
        secbtn.tintColor = UIColor.black
        selectedBtn = hrBtn
    }
    @IBAction func btnMin(_ sender: UIButton) {
        minbtn.tintColor = UIColor(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0)
        secbtn.tintColor = UIColor.black
        hrBtn.tintColor = UIColor.black
        selectedBtn = minbtn
    }
    @IBAction func btnSec(_ sender: UIButton) {
        secbtn.tintColor = UIColor(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0)
        minbtn.tintColor = UIColor.black
        hrBtn.tintColor = UIColor.black
        selectedBtn = secbtn
    }
    @IBAction func btnOpen(_ sender: UIButton) {
        self.extensionContext?.open(URL(string: "GLFLInfo://")!, completionHandler: nil)
    }
    @IBAction func changeVal(_ sender: UIButton){
        switch sender.tag {
        case 10:
            checkVal(op: "-", value: 1)
        case 11:
            checkVal(op: "+", value: 1)
        case 50:
            checkVal(op: "-", value: 5)
        case 51:
            checkVal(op: "+", value: 5)
        case 100:
            checkVal(op: "-", value: 10)
        case 101:
            checkVal(op: "+", value: 10)
        default:
            break
        }
    }
    
    func checkVal(op: String, value: Int){
        switch selectedBtn{
        case hrBtn:
            if op == "+"{
                if hr + value < 24{
                    hr += value
                }else{
                    hr = 0
                }
            }else if op == "-"{
                if hr - value > 0{
                    hr -= value
                }else{
                    hr = 0
                }
            }
            hrBtn.setTitle(String(hr), for: .normal)
        case minbtn:
            if op == "+"{
                if min + value < 60{
                    min += value
                }else{
                    min = 0
                }
            }else if op == "-"{
                if min - value > 0{
                    min -= value
                }else{
                    min = 0
                }
            }
            minbtn.setTitle(String(min), for: .normal)
        case secbtn:
            if op == "+"{
                if sec + value < 60{
                    sec += value
                }else{
                    sec = 0
                }
            }else if op == "-"{
                if sec - value > 0{
                    sec -= value
                }else{
                    sec = 0
                }
            }
            secbtn.setTitle(String(sec), for: .normal)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        listResult.delegate = self
        listResult.dataSource = self
        originalTint = btnOpenApp.tintColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
            UIView.animate(withDuration: 0.3) {
                self.largeView.alpha = 1
            }
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 305);
            UIView.animate(withDuration: 0.3) {
                self.largeView.alpha = 0
            }
        }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }

}
