//
//  noticeDetailViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class noticeDetailViewController: UIViewController {
    
    var selectedNotice: Notice?
    var selectedImg: UIImage?
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBAction func moreBtn(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: (selectedNotice?.link)!)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    @IBOutlet weak var more: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = selectedNotice?.title
        content.text = selectedNotice?.content
        cover.image = selectedImg
        
        if selectedNotice?.link == nil{
            more.isHidden = true
        }
        
        if selectedNotice?.start_time == nil{
            timeLabel.isHidden = true
            durationLabel.isHidden = true
        }else{
            if let st = selectedNotice?.start_time{
                if let et = selectedNotice?.end_time{
                    durationLabel.text = st + " 至 " + et
                }else{
                    durationLabel.text = st
                }
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC  = segue.destination as! noticeEnlargeViewController
        detailVC.selectedImg = self.selectedImg
    }

}

fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
