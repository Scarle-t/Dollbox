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
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        listResult.reloadData()
    }
    
    var selectedBtn: UIButton?
    
    var tempNum: String = ""
    
    var feedItems = NSArray()
    
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
        
        return myCell
        
    }
    
    @IBOutlet weak var listResult: UITableView!
    
    @IBAction func btnSearch(_ sender: UIButton) {
        
        let searchResult = getSearchResult()
        searchResult.delegate = self
        
        if let hour = hrBtn.titleLabel?.text,
            let minute = minbtn.titleLabel?.text,
            let second = secbtn.titleLabel?.text{

                searchResult.urlPath = "https://scarletsc.net/girlfrontline/buildtime_search.php?hour=\(hour)&minute=\(minute)&second=\(second)"

        }
        
        searchResult.downloadItems()
        
         btnOpenApp.isHidden = false

    }
    
    @IBOutlet weak var btnOpenApp: UIButton!
    @IBOutlet weak var hrBtn: UIButton!
    @IBOutlet weak var minbtn: UIButton!
    @IBOutlet weak var secbtn: UIButton!
    
    
    @IBAction func btnHr(_ sender: UIButton) {
        
        hrBtn.setTitle("|", for: UIControl.State.normal)
        selectedBtn = hrBtn
        tempNum = ""
    }
    
    
    @IBAction func btnMin(_ sender: UIButton) {
        
        minbtn.setTitle("|", for: UIControl.State.normal)
        selectedBtn = minbtn
        tempNum = ""
    }
    

    @IBAction func btnSec(_ sender: UIButton) {
        
        secbtn.setTitle("|", for: UIControl.State.normal)
        selectedBtn = secbtn
        tempNum = ""
    }
    
    @IBAction func btnOne(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            
            tempNum += "1"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
            
        case minbtn:
            tempNum += "1"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "1"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnTwo(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "2"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "2"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "2"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnThree(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "3"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "3"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "3"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnFour(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "4"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "4"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "4"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnFive(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "5"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "5"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "5"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnSix(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "6"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "6"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "6"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnSeven(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "7"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "7"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "7"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnEight(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "8"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "8"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "8"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnNine(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "9"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "9"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "9"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnZero(_ sender: UIButton) {
        
        switch selectedBtn{
        case hrBtn:
            tempNum += "0"
            hrBtn.setTitle(tempNum, for: UIControl.State.normal)
        case minbtn:
            tempNum += "0"
            minbtn.setTitle(tempNum, for: UIControl.State.normal)
        case secbtn:
            tempNum += "0"
            secbtn.setTitle(tempNum, for: UIControl.State.normal)
        default:
            break
        }
        
    }
    
    @IBAction func btnOpen(_ sender: UIButton) {
        
        
        self.extensionContext?.open(URL(string: "GLFLInfo://")!, completionHandler: nil)
        
    }
    
    @IBAction func btnDel(_ sender: UIButton) {
        
        selectedBtn?.setTitle("|", for: UIControl.State.normal)
        tempNum = ""
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        // Do any additional setup after loading the view from its nib.
        
        listResult.delegate = self
        listResult.dataSource = self
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize){
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize;
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 500);
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
