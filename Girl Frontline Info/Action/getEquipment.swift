//
//  getEquipment.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 15/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

protocol getEquipmentDelegate: class{
    func itemsDownloaded(items: NSArray)
}

class getEquipment: NSObject {
    
    weak var delegate: getEquipmentDelegate!
    var data = Data()
    var urlPath: String = ""
    
    deinit {
        print("Deinit getEquipment, getEquipment.swift")
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        let Equipments = NSMutableArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            let equipment = Equipment()
            if let name = jsonElement["Name"] as? String{
                equipment.name = name
            }
            if let type = jsonElement["Type"] as? String{
                equipment.type = type
            }
            if let star = jsonElement["Star"] as? Int{
                equipment.star = star
            }
            if let build_time = jsonElement["Build_Time"] as? String{
                equipment.build_time = build_time
            }
            if let obtain_method = jsonElement["Obtain_Method"] as? String{
                equipment.obtain_method = obtain_method
            }
            if let stat = jsonElement["Stat"] as? String{
                equipment.stat = stat
            }
            if let cover = jsonElement["cover"] as? String{
                equipment.cover = cover
            }
            if let eid = jsonElement["EID"] as? Int{
                equipment.EID = eid
            }
            Equipments.add(equipment)
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate.itemsDownloaded(items: Equipments)
        })
    }
    func downloadItems() {
        guard let url: URL = URL(string: urlPath) else {return}
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
