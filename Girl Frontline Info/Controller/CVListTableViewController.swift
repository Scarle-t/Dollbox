//
//  CVListTableViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 7/1/2019.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import UIKit

class CVListTableViewController: UITableViewController, cvDelegate, localDBDelegate {
    
    deinit {
        print("Deinit CVListTableViewController")
    }
    
    let getCVs = getCV()
    let localSearch = localDB()
    
    var feedItems = [String]()
    
    func returnItems(items: [String]) {
        feedItems = items
        cvList.reloadData()
    }
    func returndData(items: NSArray) {
        feedItems = items as! [String]
        cvList.reloadData()
    }
    
    @IBOutlet var cvList: UITableView!
    
    func getResult(){
        if localDB().readSettings()[0] {
            localSearch.cvList()
        }else{
            getCVs.downloadItems()
        }
        cvList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCVs.delegate = self
        cvList.delegate = self
        cvList.dataSource = self
        localSearch.delegate = self
        
        getResult()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavBarColor().white(self)
        getResult()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarColor().white(self)
        getResult()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cvName", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = feedItems[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let dest = segue.destination as! CVDollViewController
        dest.cvName = (cell.textLabel?.text)!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
