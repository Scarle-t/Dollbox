//
//  setNavBarColor.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 12/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class setNavBarColor: NSObject {
    
    deinit {
        print("Deinit setNavBarColor, setNavBarColor.swift")
    }
    
    func set(_ view: UIViewController, r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat){
        view.navigationController?.navigationBar.barTintColor = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    func blue(_ view: UIViewController){
        view.navigationController?.navigationBar.barTintColor = UIColor(red: 116.0/255.0, green: 220.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
    
    func green(_ view: UIViewController){
        view.navigationController?.navigationBar.barTintColor = UIColor(red: 210.0/255.0, green: 226.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }

    func gold(_ view: UIViewController){
        view.navigationController?.navigationBar.barTintColor = UIColor(red: 253.0/255.0, green: 181.0/255.0, blue: 35.0/255.0, alpha: 1.0)
    }
    
    func purple(_ view: UIViewController){
        view.navigationController?.navigationBar.barTintColor = UIColor(red: 223.0/255.0, green: 180.0/255.0, blue: 253.0/255.0, alpha: 1.0)
    }
    
    func white(_ view: UIViewController){
        view.navigationController?.navigationBar.barTintColor = UIColor.white
    }
}
