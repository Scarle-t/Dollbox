//
//  downloadData.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 17/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

protocol localDataDelegate:class{
    func finish()
    func failed()
}

class downloadData: NSObject, URLSessionDelegate {
    
    let db = Session.sharedInstance.db
    
    var data = Data()
    var urlPath: String = "https://dollbox.scarletsc.net/search.php"
    var defaultSession = URLSession()
    weak var delegate: localDataDelegate?
    var counter = 0
    
    deinit {
        print("Deinit downloadData, downloadData.swift")
    }
    
    func parse(_ data:Data, _ action: String, source: UIViewController) {
        let src = source as! OfflineSettingsViewController
        DispatchQueue.main.async(flags: .barrier){
            src.prog.progress = 0/100
        }
        
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            
            if counter == 0{
                if let id = jsonElement["ID"] as? String, let Eng_name = jsonElement["Eng_Name"] as? String, let Zh_name = jsonElement["Zh_Name"] as? String, let type = jsonElement["type"] as? String, let stars = jsonElement["Stars"] as? String, let cv = jsonElement["cv"] as? String, let cover = jsonElement["cover"] as? String
                {
                    if let mydb = db{
                        if action == "download"{
                            let _ = mydb.insert("info", rowInfo: [
                                "ID" : "'" + id + "'",
                                "Eng_Name" : "'" + Eng_name + "'",
                                "Zh_Name" : "'" + Zh_name + "'",
                                "type" : "'" + type + "'",
                                "Stars" : "'" + stars + "'",
                                "cv" : "'" + cv + "'",
                                "cover" : "'" + cover + "'"
                                ])
                        }else if action == "update"{
                            let _ = mydb.update("info", cond: "ID = " + "'" + id + "'", rowInfo: [
                                "Eng_Name" : "'" + Eng_name + "'",
                                "Zh_Name" : "'" + Zh_name + "'",
                                "type" : "'" + type + "'",
                                "Stars" : "'" + stars + "'",
                                "cv" : "'" + cv + "'",
                                "cover" : "'" + cover + "'"
                                ])
                        }
                    }
                }
                if let id = jsonElement["ID"] as? String, let health = jsonElement["health"] as? Int, let attack = jsonElement["attack"] as? Int, let speed = jsonElement["atk_speed"] as? Int, let hit_rate = jsonElement["hit_rate"] as? Int, let dodge = jsonElement["dodge_rate"] as? Int, let movement = jsonElement["movement_speed"] as? Int, let critical = jsonElement["crit_rate"] as? Int, let chain = jsonElement["chain"] as? Int, let loads = jsonElement["loads"] as? Int, let shield = jsonElement["shield"] as? Int, let efficiency = jsonElement["efficiency"] as? Int
                {
                    if let mydb = db{
                        if action == "download"{
                            let _ = mydb.insert("stats", rowInfo: [
                                "ID" : "'" + id + "'",
                                "health" : String(health),
                                "attack" : String(attack),
                                "atk_speed" : String(speed),
                                "hit_rate" : String(hit_rate),
                                "dodge_rate" : String(dodge),
                                "movement_speed" : String(movement),
                                "crit_rate" : String(critical),
                                "chain" : String(chain),
                                "loads" : String(loads),
                                "shield" : String(shield),
                                "efficiency" : String(efficiency)
                                ])
                        }else if action == "update"{
                            let _ = mydb.update("stats", cond: "ID = " + "'" + id + "'", rowInfo: [
                                "health" : String(health),
                                "attack" : String(attack),
                                "atk_speed" : String(speed),
                                "hit_rate" : String(hit_rate),
                                "dodge_rate" : String(dodge),
                                "movement_speed" : String(movement),
                                "crit_rate" : String(critical),
                                "chain" : String(chain),
                                "loads" : String(loads),
                                "shield" : String(shield),
                                "efficiency" : String(efficiency)
                                ])
                        }
                    }
                }
                if let id = jsonElement["ID"] as? String, let ammo = jsonElement["ammo"] as? Int, let mre = jsonElement["mre"] as? Int
                {
                    if let mydb = db{
                        if action == "download"{
                            let _ = mydb.insert("consumption", rowInfo: [
                                "ID" : "'" + id + "'",
                                "ammo" : String(ammo),
                                "mre" : String(mre)
                                ])
                        }else if action == "update"{
                            let _ = mydb.update("consumption", cond: "ID = " + "'" + id + "'", rowInfo: [
                                "ammo" : String(ammo),
                                "mre" : String(mre)
                                ])
                        }
                    }
                    
                }
                if let id = jsonElement["ID"] as? String, let skill_name = jsonElement["name"] as? String, let skill_desc = jsonElement["description"] as? String
                {
                    if let mydb = db{
                        if action == "download"{
                            let _ = mydb.insert("skill", rowInfo: [
                                "ID" : "'" + id + "'",
                                "name" : "'" + skill_name + "'",
                                "description" : "'" + skill_desc + "'"
                                ])
                        }else if action == "update"{
                            let _ = mydb.update("skill", cond: "ID = " + "'" + id + "'", rowInfo: [
                                "name" : "'" + skill_name + "'",
                                "description" : "'" + skill_desc + "'"
                                ])
                        }
                    }
                }
                if let id = jsonElement["ID"] as? String, let effect = jsonElement["effect"] as? String, let position = jsonElement["position"] as? Int, let area1 = jsonElement["area1"] as? Int, let area2 = jsonElement["area2"] as? Int, let area3 = jsonElement["area3"] as? Int, let area4 = jsonElement["area4"] as? Int, let area5 = jsonElement["area5"] as? Int, let area6 = jsonElement["area6"] as? Int, let area7 = jsonElement["area7"] as? Int, let area8 = jsonElement["area8"] as? Int, let area9 = jsonElement["area9"] as? Int
                {
                    if let mydb = db{
                        if action == "download"{
                            let _ = mydb.insert("buff", rowInfo: [
                                "ID" : "'" + id + "'",
                                "effect" : "'" + effect + "'",
                                "position" : String(position),
                                "area1" : String(area1),
                                "area2" : String(area2),
                                "area3" : String(area3),
                                "area4" : String(area4),
                                "area5" : String(area5),
                                "area6" : String(area6),
                                "area7" : String(area7),
                                "area8" : String(area8),
                                "area9" : String(area9)
                                ])
                        }else if action == "update"{
                            let _ = mydb.update("buff", cond: "ID = " + "'" + id + "'", rowInfo: [
                                "effect" : "'" + effect + "'",
                                "position" : String(position),
                                "area1" : String(area1),
                                "area2" : String(area2),
                                "area3" : String(area3),
                                "area4" : String(area4),
                                "area5" : String(area5),
                                "area6" : String(area6),
                                "area7" : String(area7),
                                "area8" : String(area8),
                                "area9" : String(area9)
                                ])
                        }
                    }
                }
                if let id = jsonElement["ID"] as? String, let build_time = jsonElement["build_time"] as? String, let obtain_method = jsonElement["obtain_method"] as? String
                {
                    if let mydb = db{
                        if action == "download"{
                            let _ = mydb.insert("obtain", rowInfo: [
                                "ID" : "'" + id + "'",
                                "build_time" : "'" + build_time + "'",
                                "obtain_method" : "'" + obtain_method + "'"
                                ])
                        }else if action == "update"{
                            let _ = mydb.update("obtain", cond: "ID = " + "'" + id + "'", rowInfo: [
                                "build_time" : "'" + build_time + "'",
                                "obtain_method" : "'" + obtain_method + "'"
                                ])
                        }
                    }
                }
            }else if counter == 1{
                if let name = jsonElement["Name"] as? String, let type = jsonElement["Type"] as? String, let star = jsonElement["Star"] as? Int, let bt = jsonElement["Build_Time"] as? String, let stat = jsonElement["Stat"] as? String, let ob = jsonElement["Obtain_Method"] as? String, let cover = jsonElement["cover"] as? String, let EID = jsonElement["EID"] as? Int{
                    if let mydb = db{
                        if action == "download"{
                            let _ = mydb.insert("info_e", rowInfo: [
                                "Name" : "'" + name + "'",
                                "Type" : "'" + type + "'",
                                "Star" : String(star),
                                "Build_Time" : "'" + bt + "'",
                                "Stat" : "'" + stat + "'",
                                "Obtain_Method" : "'" + ob + "'",
                                "cover" : "'" + cover + "'",
                                "EID" : String(EID)
                                ])
                        }else if action == "update"{
                            let _ = mydb.update("info_e", cond: "EID = \(EID)" , rowInfo: [
                                "Name" : "'" + name + "'",
                                "Type" : "'" + type + "'",
                                "Star" : String(star),
                                "Build_Time" : "'" + bt + "'",
                                "Stat" : "'" + stat + "'",
                                "Obtain_Method" : "'" + ob + "'",
                                "cover" : "'" + cover + "'"
                                ])
                        }
                    }
                }
            }else if counter == 2{
                    if let cv = jsonElement["cv"] as? String{
                        if cv != "無"{
                            if let mydb = db{
                                if action == "download"{
                                    let _ = mydb.insert("cv", rowInfo: [
                                        "id" : String(i),
                                        "cv" : "'" + cv + "'"
                                        ])
                                }else if action == "update"{
                                    let _ = mydb.update("cv", cond: "id = \(i)" , rowInfo: [
                                        "cv" : "'" + cv + "'"
                                        ])
                                }
                            }
                        }
                    }
            }
            
            DispatchQueue.global(qos: .background).async{
//                Thread.sleep(forTimeInterval: 0.25)
                DispatchQueue.main.async(flags: .barrier){
                    src.prog.progress += 0.002
                }
            }
        }
        
        if counter == 0{
            self.urlPath = "https://dollbox.scarletsc.net/search_e"
            self.getItems(action, source: source)
            counter = 1
        }else if counter == 1{
            self.urlPath = "https://dollbox.scarletsc.net/getCV"
            self.getItems(action, source: source)
            counter = 2
        }else if counter == 2{
            counter = 0
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.urlPath = "https://dollbox.scarletsc.net/getVersion.php"
                self.getVersion()
            })
        }
    }
    func parseVersion(_ data:Data) {
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
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
            if let mydb = db{
                let statement = mydb.fetch("dataversion", cond: nil, order: nil)
                if sqlite3_step(statement) == SQLITE_ROW{
                    let _ = mydb.update("dataversion", cond: nil, rowInfo: [
                        "local_version" : String(id as! Int),
                        "local_last" : "'" + (last_update as! String) + "'"
                        ])
                }else{
                    let _ = mydb.insert("dataversion", rowInfo: [
                        "local_version" : String(id as! Int),
                        "local_last" : "'" + (last_update as! String) + "'"
                        ])
                }
            }
        }
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.finish()
        })
    }
    func getItems(_ action: String, source: UIViewController) {
        
        if Reachability().isConnectedToNetwork(){
            let url: URL = URL(string: urlPath)!
            defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil )
            let task = defaultSession.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print("Failed to download data")
                    self.delegate?.failed()
                }else {
                    print("Data downloaded")
                    self.parse(data!, action, source: source)
                }
            }
            task.resume()
        }else{
            let alert = UIAlertController(title: "未能連接至互聯網。\n請檢查連線狀況。", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                source.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
    func getVersion(){
        
        if Reachability().isConnectedToNetwork(){
            let url: URL = URL(string: urlPath)!
            defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil )
            let task = defaultSession.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print("Failed to download data")
                    self.delegate?.failed()
                }else {
                    print("Data downloaded")
                    self.parseVersion(data!)
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
