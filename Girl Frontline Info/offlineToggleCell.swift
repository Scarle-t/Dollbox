//
//  offlineToggleCell.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class offlineToggleCell: UITableViewCell {

    let switchView = UISwitch(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchView.setOn(readPlist(), animated: true)
        switchView.tag = 1 // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        self.accessoryView = switchView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
//        sender.isOn ? writePlist(toggle: true) : writePlist(toggle: false)
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
        print(readPlist())
        
    }
    
    func readPlist()->Bool{
        
        let plistPath:String? = Bundle.main.path(forResource: "settings", ofType: "plist")!
        
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let plistPath = urls[urls.count-1].absoluteString + "settings.plist"
//        print(plistPath)
        let plistSettings = NSMutableDictionary(contentsOfFile: plistPath!)

        return plistSettings!["isOffline"]! as! Bool
        
    }
    
//    func writePlist(toggle: Bool){
//        
////        let plistPath:String? = Bundle.main.path(forResource: "settings", ofType: "plist")!
//        
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let plistPath = urls[urls.count-1].absoluteString + "settings.plist"
//        let plistSettings = NSMutableDictionary(contentsOfFile: plistPath)
//        
//        plistSettings!["isOffline"] = toggle
//        
//        plistSettings?.write(toFile: plistPath, atomically: true)
//        
//        print(plistPath)
//        
//    }

}
