//
//  getSearchResult.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 7/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit
import Foundation

protocol getSearchProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class getSearchResult: NSObject, URLSessionDataDelegate {
    
    weak var delegate: getSearchProtocol?
    var data = Data()
    var urlPath: String = ""
    
    deinit {
        print("Deinit getSearchResult, getSearchResult.swift")
    }
    
    func parseJSON(_ data:Data) {
        
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        let TDolls = NSMutableArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            let tdoll = TDoll()

            if let id = jsonElement["ID"] as? String{
                tdoll.ID = id
            }
            if let Eng_name = jsonElement["Eng_Name"] as? String
            {
                tdoll.Eng_Name = Eng_name
            }
            if let Zh_name = jsonElement["Zh_Name"] as? String
            {
                tdoll.Zh_Name = Zh_name
            }
            if let type = jsonElement["type"] as? String
            {
                tdoll.type = type
            }
            if let stars = jsonElement["Stars"] as? String
            {
                tdoll.stars = stars
            }
            if let health = jsonElement["health"] as? Int
            {
                tdoll.health = "\(health)"
            }
            if let attack = jsonElement["attack"] as? Int
            {
                tdoll.attack = "\(attack)"
            }
            if let speed = jsonElement["atk_speed"] as? Int
            {
                tdoll.speed = "\(speed)"
            }
            if let hit_rate = jsonElement["hit_rate"] as? Int
            {
                tdoll.hit_rate = "\(hit_rate)"
            }
            if let dodge = jsonElement["dodge_rate"] as? Int
            {
                tdoll.dodge = "\(dodge)"
            }
            if let movement = jsonElement["movement_speed"] as? Int
            {
                tdoll.movement = "\(movement)"
            }
            if let critical = jsonElement["crit_rate"] as? Int
            {
                tdoll.critical = "\(critical)"
            }
            if let chain = jsonElement["chain"] as? Int
            {
                tdoll.chain = "\(chain)"
            }
            if let loads = jsonElement["loads"] as? Int
            {
                tdoll.loads = "\(loads)"
            }
            if let shield = jsonElement["shield"] as? Int
            {
                tdoll.shield = "\(shield)"
            }
            if let efficiency = jsonElement["efficiency"] as? Int
            {
                tdoll.efficiency = "\(efficiency)"
            }
            if let ammo = jsonElement["ammo"] as? Int
            {
                tdoll.ammo = "\(ammo)"
            }
            if let mre = jsonElement["mre"] as? Int
            {
                tdoll.mre = "\(mre)"
            }
            if let skill_name = jsonElement["name"] as? String
            {
                tdoll.skill_name = skill_name
            }
            if let skill_desc = jsonElement["description"] as? String
            {
                tdoll.skill_desc = skill_desc
            }
            if let effect = jsonElement["effect"] as? String
            {
                tdoll.effect = effect
            }
            if let position = jsonElement["position"] as? Int
            {
                tdoll.position = "\(position)"
            }
            if let area1 = jsonElement["area1"] as? Int
            {
                tdoll.area1 = "\(area1)"
            }
            if let area2 = jsonElement["area2"] as? Int
            {
                tdoll.area2 = "\(area2)"
            }
            if let area3 = jsonElement["area3"] as? Int
            {
                tdoll.area3 = "\(area3)"
            }
            if let area4 = jsonElement["area4"] as? Int
            {
                tdoll.area4 = "\(area4)"
            }
            if let area5 = jsonElement["area5"] as? Int
            {
                tdoll.area5 = "\(area5)"
            }
            if let area6 = jsonElement["area6"] as? Int
            {
                tdoll.area6 = "\(area6)"
            }
            if let area6 = jsonElement["area6"] as? Int
            {
                tdoll.area6 = "\(area6)"
            }
            if let area7 = jsonElement["area7"] as? Int
            {
                tdoll.area7 = "\(area7)"
            }
            if let area8 = jsonElement["area8"] as? Int
            {
                tdoll.area8 = "\(area8)"
            }
            if let area9 = jsonElement["area9"] as? Int
            {
                tdoll.area9 = "\(area9)"
            }
            if let build_time = jsonElement["build_time"] as? String
            {
                tdoll.build_time = build_time
            }
            if let obtain_method = jsonElement["obtain_method"] as? String
            {
                tdoll.obtain_method = obtain_method
            }
            if let photo_path = jsonElement["cover"] as? String
            {
                tdoll.photo_path = photo_path
            }
            if let cv = jsonElement["cv"] as? String
            {
                tdoll.cv = cv
            }
            TDolls.add(tdoll)
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.itemsDownloaded(items: TDolls)
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
