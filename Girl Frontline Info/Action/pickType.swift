//
//  pickType.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 12/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class pickType: NSObject {
    
    deinit {
        print("Deinit pickType, pickType.swift")
    }
    
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
    
    func pickE(total: Int, manPower: Int, ammo: Int, ration: Int, parts: Int)->[String]{
        
        var appearType: [String] = ["瞄具"]
        
        if manPower >= 150 && ammo >= 150 && ration >= 150 && parts >= 150{
            appearType = ["all"]
        }
        
        if manPower >= 150 && ammo >= 50 && ration >= 50 && parts >= 50{
            appearType.append("4S消音器")
        }
        if manPower >= 200 && ammo >= 100 && ration >= 100 && parts >= 100{
            appearType.append("5S消音器")
        }
        
        if manPower >= 50 && ammo >= 200 && ration >= 100 && parts >= 50{
            appearType.append("4S高速彈")
        }
        if manPower >= 50 && ammo >= 250 && ration >= 150 && parts >= 100{
            appearType.append("5S高速彈")
        }
        
        if manPower >= 50 && ammo >= 150 && ration >= 50 && parts >= 100{
            appearType.append("4S穿甲彈")
        }
        if manPower >= 50 && ammo >= 200 && ration >= 100 && parts >= 150{
            appearType.append("5S穿甲彈")
        }
        
        if manPower >= 150 && ammo >= 50 && ration >= 100 && parts >= 50{
            appearType.append("4S瞄具")
        }
        if manPower >= 200 && ammo >= 50 && ration >= 150 && parts >= 100{
            appearType.append("5S瞄具")
        }
        
        if manPower >= 100 && ammo >= 50 && ration >= 150 && parts >= 50{
            appearType.append("4S夜戰裝備")
        }
        if manPower >= 150 && ammo >= 50 && ration >= 200 && parts >= 100{
            appearType.append("5S夜戰裝備")
        }
        
        if manPower >= 150 && ammo >= 50 && ration >= 50 && parts >= 150{
            appearType.append("4S外骨骼")
        }
        if manPower >= 200 && ammo >= 100 && ration >= 50 && parts >= 200{
            appearType.append("5S外骨骼")
        }
        
        if manPower >= 150 && ammo >= 50 && ration >= 200 && parts >= 50{
            appearType.append("4S偽裝披風")
        }
        if manPower >= 200 && ammo >= 100 && ration >= 250 && parts >= 100{
            appearType.append("5S偽裝披風")
        }
        
        if manPower >= 50 && ammo >= 50 && ration >= 50 && parts >= 250{
            appearType.append("5S彈藥箱")
        }
        
        return appearType
        
    }

}
