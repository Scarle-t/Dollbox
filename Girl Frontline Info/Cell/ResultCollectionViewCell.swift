//
//  ResultCollectionViewCell.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    deinit {
        print("Deinit ResultCollectionViewCell")
    }
    
    @IBOutlet weak var imgResult: UIImageView!
    
    @IBOutlet weak var lblResult: UILabel!
    
}
