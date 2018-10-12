//
//  Notice.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class Notice: NSObject {
    
    var title: String?
    var content: String?
    var start_time: String?
    var end_time: String?
    var cover: String?
    var link: String?
    var NID: Int?
    
    override init() {
    }
    
    init(title: String, content: String, st: String, et: String, cover: String, link: String, nid: Int){
        self.title = title
        self.content = content
        self.start_time = st
        self.end_time = et
        self.cover = cover
        self.link = link
        self.NID = nid
    }

}
