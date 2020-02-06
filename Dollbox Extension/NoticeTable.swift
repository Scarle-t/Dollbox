//
//  NoticeTable.swift
//  Dollbox Extension
//
//  Created by Scarlet on 31/1/2019.
//  Copyright © 2019 Scarlet. All rights reserved.
//

import WatchKit
import Foundation

class NoticeTable: WKInterfaceController, noticeDelegate {
    
    func returnItems(items: NSArray) {
        if items.count > 0{
            feedItems = items
            tableView.setNumberOfRows(items.count, withRowType: "cell")
            
            var i = 0 // Used to count each item
            for item in items { // Loop over each item in tableData
                let row = tableView.rowController(at: i) as! NoticeCell // Get a single row object for the current item
                row.noticeTitle.setText((item as! Notice).title) // Set the row text to the corresponding item
                i = i + 1 // Move onto the next item
            }
        }
    }
    
    let notice = getNotice()
    var feedItems = NSArray()
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        notice.delegate = self
        notice.downloadItems()
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        notice.delegate = self
        notice.downloadItems()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.pushController(withName: "noticeDetail", context: feedItems[rowIndex])
    }
    
}
