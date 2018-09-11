//
//  Plist.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 16/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class Plist: NSObject {
    
    let plistUrl = Bundle.main.path(forResource: "settings", ofType: "plist")!
    let fileManager = FileManager.default
    var plistLoaded = ["isOffline": false]
    
    func read()->Bool{
        do {
            
            let url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let file = url.absoluteString + "settings.plist"
            if let plistSettings = NSMutableDictionary(contentsOfFile: file){
                plistLoaded["isOffline"] = plistSettings["isOffline"] as? Bool
            }
            
            
        }catch{
            print(error)
        }
        
        return plistLoaded["isOffline"]! 
        
    }
    
    func write(){
        
    }

}
