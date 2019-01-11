//
//  CategoryViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    deinit {
        print("Deinit CategoryViewController")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
