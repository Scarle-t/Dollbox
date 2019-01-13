//
//  InterfaceController.swift
//  Dollbox Extension
//
//  Created by Scarlet on 13/1/2019.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, noticeDelegate {
    
    let notice = getNotice()
    
    func returnItems(items: NSArray) {
        if items.count > 0{
            noticeTitle.setText((items[0] as! Notice).title)
            noticeContent.setText((items[0] as! Notice).content)
        }else{
            noticeTitle.setText("暫無活動")
        }
    }
    
    
    @IBOutlet weak var noticeTitle: WKInterfaceLabel!
    @IBOutlet weak var noticeContent: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        notice.delegate = self
        notice.downloadItems()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        notice.delegate = self
        notice.downloadItems()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

class Notice: NSObject{
    var title: String?
    var content: String?
    var start_time: String?
    var end_time: String?
    var cover: String?
    var link: String?
    var NID: Int?
}

protocol noticeDelegate: class{
    func returnItems(items: NSArray)
}

class getNotice: NSObject {
    
    weak var delegate: noticeDelegate?
    var data = Data()
    var urlPath: String = "https://dollbox.scarletsc.net/getNotice.php"
    
    deinit {
        print("Deinit getNotice, Watch Kit")
    }
    
    func parseJSON(_ data:Data) {
        let notices = NSMutableArray()
        
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        for i in 0 ..< jsonResult.count
        {
            let notice = Notice()
            jsonElement = jsonResult[i] as! NSDictionary
            //the following insures none of the JsonElement values are nil through optional binding
            if let title = jsonElement["Title"] as? String{
                notice.title = title
            }
            if let content = jsonElement["Content"] as? String{
                notice.content = content
            }
            if let st = jsonElement["Start_time"] as? String{
                notice.start_time = st
            }
            if let et = jsonElement["End_time"] as? String{
                notice.end_time = et
            }
            if let cover = jsonElement["cover"] as? String{
                notice.cover = cover
            }
            if let link = jsonElement["link"] as? String{
                notice.link = link
            }
            if let nid = jsonElement["NID"] as? Int{
                notice.NID = nid
            }
            notices.add(notice)
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.returnItems(items: notices)
        })
    }
    func downloadItems() {
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        let task = defaultSession.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print("Failed to download data")
            }else {
                print("Data downloaded")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    
}

