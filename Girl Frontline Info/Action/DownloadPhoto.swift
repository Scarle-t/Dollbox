//
//  DownloadPhoto.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 12/9/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class DownloadPhoto: NSObject {
    
    let imgCache = Session.sharedInstance.imgSession
    
    deinit {
        print("Deinit DownloadPhoto, DownloadPhoto.swift")
    }
    
    func get(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

}
