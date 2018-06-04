//
//  Session.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 11/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class Session {
    
    static let sharedInstance = Session()
    
    var imgSession = NSCache<AnyObject, AnyObject>()
    
    var selectedTDoll = TDoll()
    
    var selectedTDImage = UIImage()
    
    var selected: Bool = false
    
    func loadImgSession() -> NSCache<AnyObject, AnyObject>{
        return imgSession
    }
    
    func loadTDoll() -> TDoll{
        return selectedTDoll
    }
    
    func loadImage() -> UIImage{
        return selectedTDImage
    }
    
}
