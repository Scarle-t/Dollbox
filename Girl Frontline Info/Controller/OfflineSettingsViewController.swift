//
//  OfflineSettingsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class OfflineSettingsViewController: UITableViewController, VersionProtocol, localDBDelegate, localDataDelegate {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tsLabel: UILabel!
    @IBOutlet weak var offlineToggle: UITableViewCell!
    @IBOutlet weak var localVersion: UILabel!
    @IBOutlet weak var localTS: UILabel!
    @IBOutlet weak var localCheck: UILabel!
    
    let ver = Version()
    let switchView = UISwitch(frame: .zero)
    let localSearch = localDB()
    let localData = downloadData()
    let startAlert = UIAlertController(title: "下載中。。。", message: nil, preferredStyle: .alert)
    
    var type = String()
    var localVerArray = [String]()
    var onlineVerArray = NSArray()
    
    func start(){
        if type == "update"{
            if localVerArray.count == 0 || onlineVerArray.count == 0 {
                ver.localVersion()
                ver.getVersion()
            }
            if localVerArray[0] == String(onlineVerArray[0] as! Int){
                let alert = UIAlertController(title: "已是最新版本，無需更新", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                self.present(startAlert, animated: true, completion: nil)
                self.localData.getItems(type)
            }
        }else{
            self.present(startAlert, animated: true, completion: nil)
            self.localData.getItems(type)
        }
        
        self.localCheck.isEnabled = true
    }
    func finish() {
        startAlert.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "下載完成", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.localSearch.readVersion()
    }
    func failed() {
        let alert = UIAlertController(title: "下載失敗", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "重試", style: .default, handler: { _ in
            self.localData.getItems(self.type)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func returndData(items: NSArray) {
        localVerArray = items as! [String]
        localVersion.text = " "
        localTS.text = " "
        localVersion.text = items[3] as? String
        localTS.text = items[1] as? String
    }
    func returnLocal(version: [String]) {
        localVerArray = version
        localVersion.text = "\(version[0])"
        localTS.text = "\(version[1])"
    }
    func returnVersion(version: NSMutableArray) {
        onlineVerArray = version
        versionLabel.text = "\(version[0])"
        tsLabel.text = "\(version[1])"
        
        let db = Session.sharedInstance.db
        if let mydb = db{
            let statement = mydb.fetch("dataversion", cond: nil, order: nil)
            if sqlite3_step(statement) != SQLITE_ROW{
                let _ = mydb.insert("dataversion", rowInfo: [
                    "online_last" : "'" + (version[1] as! String) + "'",
                    "online_version" : String(version[0] as! Int)
                    ])
            }else{
                let _ = mydb.update("dataversion", cond: nil, rowInfo: [
                    "online_last" : "'" + (version[1] as! String) + "'",
                    "online_version" : String(version[0] as! Int)
                    ])
            }
        }
    }
    func switchAlert(_ state: Bool) {
        if state{
            let db = Session.sharedInstance.db
            if let mydb = db{
                let statement = mydb.fetch("info", cond: nil, order: nil)
                if sqlite3_step(statement) == SQLITE_ROW{
                    let alert = UIAlertController(title: "更新資料檔", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                        localDB().writeSettings(item: "isOffline", value: "1")
                        self.type = "update"
                        self.start()
                    }))
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                        self.switchView.setOn(false, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "下載資料檔", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                        localDB().writeSettings(item: "isOffline", value: "1")
                        self.type = "download"
                        self.start()
                    }))
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                        self.switchView.setOn(false, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }else{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "刪除離線資料檔", style: .destructive, handler: { _ in
                localDB().writeSettings(item: "isOffline", value: "0")
                localDB().delete(self)
                self.localVersion.text = " "
                self.localTS.text = " "
                self.localCheck.isEnabled = false
            }))
            alert.addAction(UIAlertAction(title: "保留離線資料檔", style: .default, handler: { _ in
                localDB().writeSettings(item: "isOffline", value: "0")
                self.localCheck.isEnabled = false
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                self.switchView.setOn(true, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @objc func switchChanged(_ sender : UISwitch!){
        switchAlert(sender.isOn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchView.setOn(localDB().readSettings()[0], animated: true)
        switchView.tag = 1 // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        offlineToggle.accessoryView = switchView
        
        versionLabel.text = " "
        tsLabel.text = " "
        localVersion.text = " "
        localTS.text = " "
        ver.delegate = self
        localSearch.delegate = self
        ver.getVersion()
        localData.delegate = self
        
        if localDB().readSettings()[0]{
            ver.localVersion()
            localCheck.isEnabled = true
        }else{
            localCheck.isEnabled = false
        }
        
        let db = Session.sharedInstance.db
        if let mydb = db{
            let statement = mydb.fetch("info", cond: nil, order: nil)
            if sqlite3_step(statement) == SQLITE_ROW{
                ver.localVersion()
            }
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1, 2:
            return 3
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 1:
            switch indexPath.row{
            case 0:
                versionLabel.text = " "
                tsLabel.text = " "
                ver.getVersion()
            default:
                break
            }
        case 2:
            switch indexPath.row{
            case 0:
                if localDB().readSettings()[0]{
                    localVersion.text = " "
                    localTS.text = " "
                    ver.localVersion()
                    let db = Session.sharedInstance.db
                    if let mydb = db{
                        let statement = mydb.fetch("info", cond: nil, order: nil)
                        if sqlite3_step(statement) == SQLITE_ROW{
                            self.type = "update"
                            self.start()
                        }else{
                            self.type = "download"
                            self.start()
                        }
                    }
                }
            default:
                break
            }
        default:
            break
        }
    }

}
