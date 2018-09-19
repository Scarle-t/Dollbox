//
//  setupLocalDB.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 17/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

protocol localDBDelegate: class{
    func returndData(items: NSArray)
}

class localDB: NSObject {
    
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var db: SQLiteConnect?
    var feedItems = NSArray()
    weak var delegate: localDBDelegate?
    
    func setup(){
        let sqlitePath = urls[urls.count-1].absoluteString + "sqlite3.db"
        print(sqlitePath)
        Session.sharedInstance.db = SQLiteConnect(path: sqlitePath)
        db = Session.sharedInstance.db
        if let mydb = db {
            // create table
            let _ = mydb.createTable("buff", columnsInfo: [
                "effect text",
                "position integer",
                "area1 integer",
                "area2 integer",
                "area3 integer",
                "area4 integer",
                "area5 integer",
                "area6 integer",
                "area7 integer",
                "area8 integer",
                "area9 integer",
                "ID text primary key"
                ])
            let _ = mydb.createTable("consumption", columnsInfo: [
                "ammo integer",
                "mre integer",
                "ID text primary key"
                ])
            let _ = mydb.createTable("dataversion", columnsInfo: [
                "online_last text",
                "local_last text",
                "online_version integer",
                "local_version integer primary key"
                ])
            let _ = mydb.createTable("info", columnsInfo: [
                "ID text primary key",
                "Eng_Name text",
                "Zh_Name text",
                "type text",
                "Stars text"
                ])
            let _ = mydb.createTable("obtain", columnsInfo: [
                "build_time text",
                "obtain_method text",
                "ID text primary key"
                ])
            let _ = mydb.createTable("skill", columnsInfo: [
                "name text",
                "description text",
                "ID text primary key"
                ])
            let _ = mydb.createTable("stats", columnsInfo: [
                "health integer",
                "attack integer",
                "atk_speed integer",
                "hit_rate integer",
                "dodge_rate integer",
                "movement_speed integer",
                "crit_rate integer",
                "chain integer",
                "loads integer",
                "shield integer",
                "efficiency integer",
                "ID text primary key"
                ])
            let _ = mydb.createTable("settings", columnsInfo: [
                "isOffline integer",
                "isFirstTime integer"
                ])
            print("Table ready.")
            
            let statement = mydb.fetch("settings", cond: nil, order: nil)
            while sqlite3_step(statement) != SQLITE_ROW{
                let _ = mydb.insert("settings", rowInfo: [
                    "isOffline" : "0",
                    "isFirstTime" : "1"
                    ])
                break
            }
        }
    }
    func download(_ source: UIViewController?){
        downloadData().getItems("download")
        if let source = source{
            let finish = UIAlertController(title: "下載完成", message: nil, preferredStyle: .alert)
            finish.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
            }))
            source.present(finish, animated: true, completion: nil)
        }
    }
    func update(){
        downloadData().getItems("update")
    }
    func delete(){
        db = Session.sharedInstance.db
        if let mydb = db {
            let _ = mydb.delete("info", cond: nil)
            let _ = mydb.delete("buff", cond: nil)
            let _ = mydb.delete("stats", cond: nil)
            let _ = mydb.delete("obtain", cond: nil)
            let _ = mydb.delete("consumption", cond: nil)
            let _ = mydb.delete("skill", cond: nil)
        }
    }
    func readSettings()->[Bool]{
        var settings = [false, false]
        db = Session.sharedInstance.db
        if let mydb = db {
            let statement = mydb.fetch("settings", cond: nil, order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                let isOffline = String(cString: sqlite3_column_text(statement, 0))
                let isFirstTime = String(cString: sqlite3_column_text(statement, 1))
                if isOffline == "0" {
                    settings[0] = false
                }else{
                    settings[0] = true
                }
                if isFirstTime == "0" {
                    settings[1] = false
                }else{
                    settings[1] = true
                }
            }
        }
        return settings
    }
    func writeSettings(item: String, value: String){
        db = Session.sharedInstance.db
        if let mydb = db {
            let _ = mydb.update("settings", cond: nil, rowInfo: [item : value])
        }
    }
    func search(cond: String){
        db = Session.sharedInstance.db
        let tdolls = NSMutableArray()
        
        if let mydb = db{
            let statement = mydb.fetch("obtain", cond: cond, order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                let tdoll = TDoll()
                let id = String(cString: sqlite3_column_text(statement, 2))
                tdoll.ID = id
                tdoll.build_time = String(cString: sqlite3_column_text(statement, 0))
                tdoll.obtain_method = String(cString: sqlite3_column_text(statement, 1))
                let info = mydb.fetch("info", cond: "ID = '" + id + "'", order: nil)
                let buff = mydb.fetch("buff", cond: "ID = '" + id + "'", order: nil)
                let consumption = mydb.fetch("consumption", cond: "ID = '" + id + "'", order: nil)
                let stats = mydb.fetch("stats", cond: "ID = '" + id + "'", order: nil)
                let skill = mydb.fetch("skill", cond: "ID = '" + id + "'", order: nil)
                if sqlite3_step(stats) == SQLITE_ROW{
                    tdoll.health = String(cString: sqlite3_column_text(stats, 0))
                    tdoll.attack = String(cString: sqlite3_column_text(stats, 1))
                    tdoll.speed = String(cString: sqlite3_column_text(stats, 2))
                    tdoll.hit_rate = String(cString: sqlite3_column_text(stats, 3))
                    tdoll.dodge = String(cString: sqlite3_column_text(stats, 4))
                    tdoll.movement = String(cString: sqlite3_column_text(stats, 5))
                    tdoll.critical = String(cString: sqlite3_column_text(stats, 6))
                    tdoll.chain = String(cString: sqlite3_column_text(stats, 7))
                    tdoll.loads = String(cString: sqlite3_column_text(stats, 8))
                    tdoll.shield = String(cString: sqlite3_column_text(stats, 9))
                    tdoll.efficiency = String(cString: sqlite3_column_text(stats, 10))
                }
                if sqlite3_step(buff) == SQLITE_ROW{
                    tdoll.effect = String(cString: sqlite3_column_text(buff, 0))
                    tdoll.position = String(cString: sqlite3_column_text(buff, 1))
                    tdoll.area1 = String(cString: sqlite3_column_text(buff, 2))
                    tdoll.area2 = String(cString: sqlite3_column_text(buff, 3))
                    tdoll.area3 = String(cString: sqlite3_column_text(buff, 4))
                    tdoll.area4 = String(cString: sqlite3_column_text(buff, 5))
                    tdoll.area5 = String(cString: sqlite3_column_text(buff, 6))
                    tdoll.area6 = String(cString: sqlite3_column_text(buff, 7))
                    tdoll.area7 = String(cString: sqlite3_column_text(buff, 8))
                    tdoll.area8 = String(cString: sqlite3_column_text(buff, 9))
                    tdoll.area9 = String(cString: sqlite3_column_text(buff, 10))
                }
                if sqlite3_step(consumption) == SQLITE_ROW{
                    tdoll.ammo = String(cString: sqlite3_column_text(consumption, 0))
                    tdoll.mre = String(cString: sqlite3_column_text(consumption, 1))
                }
                if sqlite3_step(info) == SQLITE_ROW{
                    tdoll.Eng_Name = String(cString: sqlite3_column_text(info, 1))
                    tdoll.Zh_Name = String(cString: sqlite3_column_text(info, 2))
                    tdoll.type = String(cString: sqlite3_column_text(info, 3))
                    tdoll.stars = String(cString: sqlite3_column_text(info, 4))
                }
                if sqlite3_step(skill) == SQLITE_ROW{
                    tdoll.skill_name = String(cString: sqlite3_column_text(skill, 0))
                    tdoll.skill_desc = String(cString: sqlite3_column_text(skill, 1))
                }
                tdolls.add(tdoll)
            }
        }
        self.delegate?.returndData(items: tdolls)
    }
    
}
