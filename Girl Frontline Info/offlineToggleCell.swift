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
        switchView.setOn(Plist().read(), animated: true)
        switchView.tag = 1 // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        self.accessoryView = switchView
        switchView.isEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        print("table row switch Changed \(sender.tag)")
//        sender.isOn ? writePlist(toggle: true) : writePlist(toggle: false)
        print("The switch is \(sender.isOn ? "ON" : "OFF")")
        
    }

}
