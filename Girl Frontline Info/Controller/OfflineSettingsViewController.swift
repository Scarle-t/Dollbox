//
//  OfflineSettingsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class OfflineSettingsViewController: UITableViewController, VersionProtocol {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tsLabel: UILabel!
    @IBOutlet weak var offlineToggle: UITableViewCell!
    
    let ver = Version()
    let switchView = UISwitch(frame: .zero)
    
    func returnVersion(version: NSMutableArray) {
        
        versionLabel.text = "\(version[0])"
        tsLabel.text = "\(version[1])"
        
        let db = Session.sharedInstance.db
        if let mydb = db{
            let statement = mydb.fetch("dataversion", cond: nil, order: nil)
            if sqlite3_step(statement) != SQLITE_ROW{
                let _ = mydb.insert("dataversion", rowInfo: [
                    "online_last" : version[1] as! String,
                    "online_version" : String(version[0] as! Int),
                    ])
            }else{
                let _ = mydb.update("dataversion", cond: nil, rowInfo: [
                    "online_last" : version[1] as! String,
                    "online_version" : String(version[0] as! Int),
                    ])
            }
        }
        
//        let alert = UIAlertController(title: "當前版本: \(version[0])", message: "最後更新時間: \(version[1])", preferredStyle: UIAlertController.Style.alert)
//
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            }))
//
//        self.present(alert, animated: true, completion: nil)
    }
    func switchAlert(_ state: Bool) {
        if state{
            let alert = UIAlertController(title: "將會下載資料檔", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                localDB().download(self)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                self.switchView.setOn(false, animated: true)
                localDB().writeSettings(item: "isOffline", value: "0")
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            localDB().delete()
        }
        
    }
    @objc func switchChanged(_ sender : UISwitch!){
        sender.isOn ? localDB().writeSettings(item: "isOffline", value: "1") : localDB().writeSettings(item: "isOffline", value: "0")
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
        ver.delegate = self
        ver.getVersion()
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 3:
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
                ver.getVersion()
            default:
                break
            }
        default:
            break
        }
    }

}
