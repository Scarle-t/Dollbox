//
//  DeviceExtension.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 12/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3", "iPhone4,1":
            return "iPhone 4/s"
            
        case "iPhone5,1", "iPhone5,2", "iPhone5,3", "iPhone5,4", "iPhone6,1", "iPhone6,2", "iPhone8,4":
            return "iPhone 5/s/c/SE"
            
        case "iPhone7,2", "iPhone8,1", "iPhone9,1", "iPhone9,3", "iPhone10,1", "iPhone10,4":
            return "iPhone 6/s/7/8"
            
        case "iPhone7,1", "iPhone8,2", "iPhone9,2", "iPhone9,4", "iPhone10,2", "iPhone10,5":
            return "iPhone 6/s/7/8 Plus"
            
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4", "iPad3,1", "iPad3,2", "iPad3,3", "iPad3,4", "iPad3,5", "iPad3,6", "iPad4,1", "iPad4,2", "iPad4,3", "iPad5,3", "iPad5,4", "iPad6,11", "iPad6,12", "iPad7,5", "iPad7,6", "iPad2,5", "iPad2,6", "iPad2,7", "iPad4,4", "iPad4,5", "iPad4,6", "iPad4,7", "iPad4,8", "iPad4,9", "iPad5,1", "iPad5,2", "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2", "iPad7,3", "iPad7,4":
            
            return "iPad"
            
        case "i386", "x86_64":
            return "Simulator"
            
        default:
            return identifier
        }
    }
    
}
