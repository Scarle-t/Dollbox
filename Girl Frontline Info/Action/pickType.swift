//
//  pickType.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 12/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class pickType: NSObject {
    
    func pick(total: Int, manPower: Int, ammo: Int, ration: Int, parts: Int)->[String]{
        
        var appearType: [String] = ["SMG"]
        
        if total < 920 {
            if manPower >= 130 && ammo >= 130 && ration >= 130 && parts >= 130{
                appearType.append("5SHG")
            }
            appearType.append("HG")
        }
        if total > 800 {
            if manPower >= 30 && ammo >= 400 && ration >= 400 && parts >= 30{
                appearType.append("5SAR")
            }else{
                appearType.append("AR")
            }
        }
        if manPower >= 400 && ammo >= 400 && ration >= 30 && parts >= 30{
            appearType.append("5SSMG")
        }
        if manPower >= 300 && ration >= 300{
            if manPower >= 400 && ammo >= 30 && ration >= 400 && parts >= 30{
                appearType.append("5SRF")
            }
            appearType.append("RF")
        }
        if manPower >= 400 && ammo >= 600 && parts >= 300{
            if manPower >= 600 && ammo >= 600 && ration >= 100 && parts >= 400{
                appearType.append("5SMG")
            }
            appearType.append("MG")
        }
        return appearType
    }
    
    func randomize(list: [String]){
        
    }

}
