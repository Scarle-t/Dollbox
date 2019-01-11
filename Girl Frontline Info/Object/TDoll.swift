//
//  TDoll.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 7/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit
import Foundation

class TDoll: NSObject {
    
    deinit {
        print("Deinit Object TDoll")
    }
    
    var ID: String?
    var Eng_Name: String?
    var Zh_Name: String?
    var type: String?
    var stars: String?
    var cv: String?
    
    var health: String?
    var attack: String?
    var speed: String?
    var hit_rate: String?
    var dodge: String?
    var movement: String?
    var critical: String?
    var chain: String?
    var loads: String?
    var shield: String?
    var efficiency: String?
    
    var ammo: String?
    var mre: String?
    
    var skill_name: String?
    var skill_desc: String?
    
    var area1: String?
    var area2: String?
    var area3: String?
    var area4: String?
    var area5: String?
    var area6: String?
    var area7: String?
    var area8: String?
    var area9: String?
    var position: String?
    var effect: String?
    
    var build_time: String?
    var obtain_method: String?
    
    var photo_path: String?
    
    override init(){
        
    }
    
    init(ID: String, Eng_name: String, Zh_name: String, type: String, stars: String, health: String, attack: String, speed: String, hit_rate: String, dodge: String, movement: String, critical: String, chain: String, loads: String, shield: String, efficiency: String, ammo: String, mre: String, skill_name: String, skill_desc: String, area1: String, area2: String, area3: String, area4: String, area5: String, area6: String, area7: String, area8: String, area9: String, position: String, effect: String, build_time: String, obtain_method: String, photo_path: String, cv: String){
        
        self.ID = ID
        self.Eng_Name = Eng_name
        self.Zh_Name = Zh_name
        self.type = type
        self.stars = stars
        self.health = health
        self.attack = attack
        self.speed = speed
        self.hit_rate = hit_rate
        self.dodge = dodge
        self.movement = movement
        self.critical = critical
        self.chain = chain
        self.loads = loads
        self.shield = shield
        self.efficiency = efficiency
        self.ammo = ammo
        self.mre = mre
        self.skill_name = skill_name
        self.skill_desc = skill_desc
        self.area1 = area1
        self.area2 = area2
        self.area3 = area3
        self.area4 = area4
        self.area5 = area5
        self.area6 = area6
        self.area7 = area7
        self.area8 = area8
        self.area9 = area9
        self.position = position
        self.effect = effect
        self.build_time = build_time
        self.obtain_method = obtain_method
        self.photo_path = photo_path
        self.cv = cv
        
    }

}
