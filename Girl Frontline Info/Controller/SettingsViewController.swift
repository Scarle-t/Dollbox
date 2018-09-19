//
//  SettingsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section{
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 1:
            switch indexPath.row{
            case 0:
                UIApplication.shared.open(URL(string: "https://gf.txwy.tw")!, options: [:], completionHandler: nil)
            case 1:
                UIApplication.shared.open(URL(string: "https://www.facebook.com/gf.txwy.tw")!, options: [:], completionHandler: nil)
            case 2:
                UIApplication.shared.open(URL(string: "https://www.facebook.com/Girlsfrontline.fanpage")!, options: [:], completionHandler: nil)
            default:
                break
            }
        case 2:
            switch indexPath.row{
            case 0:
                UIApplication.shared.open(URL(string: "https://gf.txwy.tw")!, options: [:], completionHandler: nil)
            case 1:
                UIApplication.shared.open(URL(string: "https://zh.moegirl.org/zh-tw/%e5%b0%91%e5%a5%b3%e5%89%8d%e7%ba%bf")!, options: [:], completionHandler: nil)
            default:
                break
            }
        case 3:
            UIApplication.shared.open(URL(string: "https://www.facebook.com/Scarlet.SC2")!, options: [:], completionHandler: nil)
        default:
            break
        }
        
    }
}
