//
//  getVersion.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

protocol VersionProtocol: class{
    func returnVersion(version: NSMutableArray)
}

class Version: NSObject, URLSessionDataDelegate {
    
    var delegate: VersionProtocol!
    
    var data = Data()
    
    var urlPath: String = "https://scarletsc.net/girlfrontline/getVersion.php"
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
            
        }
        
        var jsonElement = NSDictionary()
        var versions = NSMutableArray()
        
        for i in 0 ..< jsonResult.count
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            //the following insures none of the JsonElement values are nil through optional binding
            
            guard let id = jsonElement["Version_ID"] else {return}
            guard let last_update = jsonElement["last_update"] else{return}
            
            versions = [id, last_update]
            
        }
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.returnVersion(version: versions)
        })
        
    }
    
    func getVersion(){
        
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
