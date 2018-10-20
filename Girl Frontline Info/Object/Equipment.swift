//
//  Equipment.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 15/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class Equipment: NSObject {
    
    var name: String?
    var type: String?
    var star: Int?
    var build_time: String?
    var obtain_method: String?
    var stat: String?
    var cover: String?
    var EID: Int?
    
    override init(){
    }
    
    init(name: String, type: String, star: Int, build_time: String, obtain_method: String, cover: String, stat: String, EID: Int){
        self.name = name
        self.type = type
        self.star = star
        self.build_time = build_time
        self.obtain_method = obtain_method
        self.stat = stat
        self.cover = cover
        self.EID = EID
    }

}
