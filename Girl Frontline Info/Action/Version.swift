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
    func returnLocal(version: [String])
}
extension VersionProtocol{
    func returnLocal(version: [String]){
    }
}
class Version: NSObject, URLSessionDataDelegate {
    
    weak var delegate: VersionProtocol!
    var data = Data()
    var urlPath: String = "https://dollbox.scarletsc.net/getVersion.php"
    var defaultSession = URLSession()
    
    deinit {
        print("Deinit Version, Version.swift")
    }
    
    func parseJSON(_ data:Data) {
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        var versions = NSMutableArray()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
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
        defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil )
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
    
    func localVersion(){
        let db = Session.sharedInstance.db
        var vers = ["N/A", "N/A"]
        if let mydb = db{
            let statement = mydb.fetch("dataversion", cond: nil, order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                let version = String(cString: sqlite3_column_text(statement, 3))
                let ts = String(cString: sqlite3_column_text(statement, 1))
                vers[0] = version
                vers[1] = ts
            }
        }
        self.delegate.returnLocal(version: vers)
    }
    
}
