//
//  ToolboxTableViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 4/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class ToolboxTableViewController: UITableViewController {
    
    deinit {
        print("Deinit ToolboxTableViewController")
    }
    
    let detailNCs = NSMutableArray()
    let detailVCs = NSMutableArray()
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ts = self.storyboard?.instantiateViewController(withIdentifier: "timeSearch") as! UINavigationController
        let ks = self.storyboard?.instantiateViewController(withIdentifier: "keySearch") as! UINavigationController
        let ss = self.storyboard?.instantiateViewController(withIdentifier: "starSearch") as! UINavigationController
        let all = self.storyboard?.instantiateViewController(withIdentifier: "allSearch") as! UINavigationController
        let bs = self.storyboard?.instantiateViewController(withIdentifier: "buildSim") as! UINavigationController
        let fs = self.storyboard?.instantiateViewController(withIdentifier: "teamSim") as! UINavigationController
        
        let tsv = self.storyboard?.instantiateViewController(withIdentifier: "timeSearchV") as! BuildtimeSearchCollectionViewController
        let ksv = self.storyboard?.instantiateViewController(withIdentifier: "keySearchV") as! KeySearchViewController
        let sv = self.storyboard?.instantiateViewController(withIdentifier: "starSearchV") as! StarSearchViewController
        let allv = self.storyboard?.instantiateViewController(withIdentifier: "allSearchV") as! allViewController
        let bsv = self.storyboard?.instantiateViewController(withIdentifier: "buildSimV") as! BuildSimulatorViewController
        let fsv = self.storyboard?.instantiateViewController(withIdentifier: "teamSimV") as! TeamSimulatorViewController
        
        detailNCs.add(ts)
        detailNCs.add(ks)
        detailNCs.add(all)
        detailNCs.add(ss)
        detailNCs.add(bs)
        detailNCs.add(fs)
        
        detailVCs.add(tsv)
        detailVCs.add(ksv)
        detailVCs.add(allv)
        detailVCs.add(sv)
        detailVCs.add(bsv)
        detailVCs.add(fsv)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor().white(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        return 2
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = 0
        switch indexPath.section {
        case 0:
            item = indexPath.row + 0
        case 1:
            item = indexPath.row + 2
        case 2:
            item = indexPath.row + 4
        default:
            break
        }
        
        if (self.splitViewController?.viewControllers.count)! > 1{
            self.splitViewController?.viewControllers[1] = detailNCs[item] as! UINavigationController
        }else{
            self.navigationController?.pushViewController(detailVCs[item] as! UIViewController, animated: true)
        }
        
    }
    
    // MARK: - Collection view data source

}
