//
//  getCV.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 7/1/2019.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

protocol cvDelegate: class{
    func returnItems(items: [String])
}

class getCV: NSObject {
    
    weak var delegate: cvDelegate!
    var data = Data()
    var urlPath: String = "https://dollbox.scarletsc.net/getCV.php"
    
    deinit {
        print("Deinit getCV, getCV.swift")
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        var cvs = [String]()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            //the following insures none of the JsonElement values are nil through optional binding
            if let cv = jsonElement["cv"] as? String{
                if cv != "無"{
                    cvs.append(cv)
                }
            }
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.returnItems(items: cvs)
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
