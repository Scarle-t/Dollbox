//
//  getNotice.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

protocol noticeDelegate: class{
    func returnItems(items: NSArray)
}

class getNotice: NSObject {
    
    weak var delegate: noticeDelegate!
    var data = Data()
    var urlPath: String = "https://dollbox.scarletsc.net/getNotice.php"
    
    deinit {
        print("Deinit getNotice, getNotice.swift")
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
            self.delegate.returnItems(items: notices)
        })
    }
    func downloadItems() {
        
        if Reachability().isConnectedToNetwork(){
            
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
        }else{
            let alert = UIAlertController(title: "未能連接至互聯網。\n請檢查連線狀況。", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                (self.delegate as? UIViewController)?.present(alert, animated: true, completion: nil)
            }
        }
    }

}
