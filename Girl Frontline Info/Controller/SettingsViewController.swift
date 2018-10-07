//
//  SettingsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var appVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appVersion.text = "版本" + ((Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 3
        case 2, 3:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 1:
            switch indexPath.row{
            case 0:
                UIApplication.shared.open(URL(string: "https://gf.txwy.tw")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            case 1:
                UIApplication.shared.open(URL(string: "https://www.facebook.com/gf.txwy.tw")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            case 2:
                UIApplication.shared.open(URL(string: "https://www.facebook.com/Girlsfrontline.fanpage")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            default:
                break
            }
        case 2:
            switch indexPath.row{
            case 0:
                UIApplication.shared.open(URL(string: "https://gf.txwy.tw")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            case 1:
                UIApplication.shared.open(URL(string: "https://zh.moegirl.org/zh-tw/%e5%b0%91%e5%a5%b3%e5%89%8d%e7%ba%bf")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            default:
                break
            }
        case 3:
            switch indexPath.row{
            case 0:
                UIApplication.shared.open(URL(string: "https://www.facebook.com/Scarlet.SC2")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            case 1:
                UIApplication.shared.open(URL(string: "https://scarletsc.net")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            default:
                break
            }
        default:
            break
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
