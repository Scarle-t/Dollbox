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
    var selectedNotice = Notice()
    var selectedNoticeImg = UIImage()
    var selectedLink = String()

    var total2T = Int()
    var total3T = Int()
    var total4T = Int()
    var total5T = Int()
    var totalMPT = Int()
    var totalAMT = Int()
    var totalRTT = Int()
    var totalPTT = Int()
    var constructedT = NSMutableArray()

    var total2E = Int()
    var total3E = Int()
    var total4E = Int()
    var total5E = Int()
    var totalMPE = Int()
    var totalAME = Int()
    var totalRTE = Int()
    var totalPTE = Int()
    var constructedE = NSMutableArray()
    
    var db: SQLiteConnect?
    
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
