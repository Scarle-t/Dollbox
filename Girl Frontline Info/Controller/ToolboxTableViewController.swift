//
//  ToolboxTableViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 4/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class ToolboxTableViewController: UITableViewController, localDBDelegate, VersionProtocol {
    
    let localSearch = localDB()
    let version = Version()
    var versions = NSMutableDictionary()
    
    func returndData(items: NSArray) {
        versions.setValue("\(items[3])", forKey: "local")
    }
    func returnVersion(version: NSMutableArray) {
        versions.setValue("\(version[0])", forKey: "online")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localSearch.delegate = self
        version.delegate = self
        localDB().setup()
        versions.addEntries(from: ["online": ""])
        versions.addEntries(from: ["local" : ""])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if localDB().readSettings()[0]{
            print("Getting versions")
            version.getVersion()
            localSearch.readVersion()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavBarColor().white(self)
        if localDB().readSettings()[0]{
            version.getVersion()
            if (versions.value(forKey: "local") as! String) != (versions.value(forKey: "online") as! String){
                let alert = UIAlertController(title: "離線資料檔有可用的更新", message: "新版本：\(versions.value(forKey: "online") ?? ""), 當前版本：\(versions.value(forKey: "local") ?? "")", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                    let storyboard = selectDevice().storyboard()
                    let offlineSettings = storyboard.instantiateViewController(withIdentifier: "offlineSettings")
                    self.navigationController?.pushViewController(offlineSettings, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 3
        }else{
            return 2
        }
    }

}
