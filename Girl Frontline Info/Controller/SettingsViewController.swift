//
//  SettingsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    deinit {
        print("Deinit SettingsViewController")
    }
    
    @IBOutlet weak var appVersion: UILabel!
    
    let detailNCs = NSMutableArray()
    let detailVCs = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarColor().white(self)
        appVersion.numberOfLines = 0
        var verTxt = "版本 " + ((Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)!) + " (" + ((Bundle.main.infoDictionary!["CFBundleVersion"] as? String)!) + ")"
//        verTxt += "\nTESTFLIGHT BETA"
        verTxt += "\nAPPSTORE"
        appVersion.text = verTxt
        
        let wv = self.storyboard?.instantiateViewController(withIdentifier: "webView") as! UINavigationController
        let sv = self.storyboard?.instantiateViewController(withIdentifier: "settings") as! UINavigationController
        let cv = self.storyboard?.instantiateViewController(withIdentifier: "cv") as! UINavigationController
        
        let wvc = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as! DisclaimerViewController
        let osv = self.storyboard?.instantiateViewController(withIdentifier: "offlineSettings") as! OfflineSettingsViewController
        let cvl = self.storyboard?.instantiateViewController(withIdentifier: "cvlist") as! CVListTableViewController
        
        wv.addChild(wvc)
        
        detailNCs.add(sv)
        detailNCs.add(wv)
        detailNCs.add(cv)
        
        detailVCs.add(osv)
        detailVCs.add(wvc)
        detailVCs.add(cvl)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor().white(self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dis"{
            let dest = segue.destination as! DisclaimerViewController
            dest.urlString = "https://scarletsc.net/disclaimer_glflInfo.cshtml"
            dest.title = "Disclaimer"
        }
        if segue.identifier == "pp"{
            let dest = segue.destination as! DisclaimerViewController
            dest.urlString = "https://scarletsc.net/privacy_glflInfo.cshtml"
            dest.title = "Privacy Policy"
        }
        if segue.identifier == "license"{
            let dest = segue.destination as! DisclaimerViewController
            dest.urlString = "https://dollbox.scarletsc.net/external_lib.html"
            dest.title = "License"
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0, 1:
            return 1
        case 2, 4:
            return 3
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            if (self.splitViewController?.viewControllers.count)! > 1{
                self.splitViewController?.viewControllers[1] = detailNCs[2] as! UINavigationController
            }else{
                self.navigationController?.pushViewController(detailVCs[2] as! UIViewController, animated: true)
            }
        case 1:
            if (self.splitViewController?.viewControllers.count)! > 1{
                self.splitViewController?.viewControllers[1] = detailNCs[0] as! UINavigationController
            }else{
                self.navigationController?.pushViewController(detailVCs[0] as! UIViewController, animated: true)
            }
        case 2:
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
        case 3:
            switch indexPath.row{
            case 0:
                UIApplication.shared.open(URL(string: "https://www.facebook.com/Scarlet.SC2")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            case 1:
                UIApplication.shared.open(URL(string: "https://scarletsc.net")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            default:
                break
            }
        case 4:
            let dest = detailVCs[1] as! DisclaimerViewController
            switch indexPath.row{
            case 0:
                dest.urlString = "https://scarletsc.net/disclaimer_glflInfo.cshtml"
                dest.title = "Disclaimer"
            case 1:
                dest.urlString = "https://scarletsc.net/privacy_glflInfo.cshtml"
                dest.title = "Privacy Policy"
            case 2:
                dest.urlString = "https://dollbox.scarletsc.net/external_lib.html"
                dest.title = "License"
            default:
                break
            }
            if (self.splitViewController?.viewControllers.count)! > 1{
                self.splitViewController?.viewControllers[1] = dest
                dest.viewDidAppear(true)
            }else{
                self.navigationController?.pushViewController(detailVCs[1] as! UIViewController, animated: true)
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
