//
//  selectDevice.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 20/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class selectDevice: NSObject {
    
    func storyboard()->UIStoryboard{
        let modelName = UIDevice.current.modelName
        
        switch modelName{
        case "iPad":
            if #available(iOS 12.0, *){
                return UIStoryboard(name: "iPhone678", bundle: nil)
            }else{
                return UIStoryboard(name: "small", bundle: nil)
            }
        case "iPhone 5/s/c/SE":
            return UIStoryboard(name: "small", bundle: nil)
        case "iPhone 6/s/7/8", "iPhone 6/s/7/8 Plus":
            return UIStoryboard(name: "iPhone678", bundle: nil)
        case "iPhone X":
            return UIStoryboard(name: "Main", bundle: nil)
        default:
            return UIStoryboard(name: "small", bundle: nil)
        }
    }

}
