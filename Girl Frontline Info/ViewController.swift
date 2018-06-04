//
//  ViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 7/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var db: SQLiteConnect?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let sqlitePath = urls[urls.count-1].absoluteString + "sqlite3.db"
        
        print(sqlitePath)
        
        db = SQLiteConnect(path: sqlitePath)
        
        if let mydb = db{
            
            let _ = mydb.createTable("firstTime", columnsInfo:
                ["id text primary key",
                "firstTimeApp text",
                "firstTimeSearch text",
                "firstTimeCatalog text",
                "firsttimeDetail text",
                "firstTimeBuildSim text",
                "firstTimeTeamSim text"
                ])

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

