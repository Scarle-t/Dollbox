//
//  noticeDetailViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 10/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class noticeDetailViewController: UIViewController {
    var selectedNotice = Notice()
    
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBAction func moreBtn(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: (selectedNotice.link)!)!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    @IBAction func imgTap(_ sender: UITapGestureRecognizer) {
        let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "imgView") as! noticeEnlargeViewController
        detailVC.selectedImg = Session.sharedInstance.selectedNoticeImg
        self.present(detailVC, animated: true, completion: nil)
    }
    @IBOutlet weak var more: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        selectedNotice = Session.sharedInstance.selectedNotice
        self.title = selectedNotice.title
        content.text = selectedNotice.content
        cover.image = Session.sharedInstance.selectedNoticeImg
        
        if selectedNotice.link == nil{
            more.isHidden = true
        }else{
            more.isHidden = false
        }
        
        if selectedNotice.start_time == nil{
            timeLabel.isHidden = true
            durationLabel.isHidden = true
        }else{
            if let st = selectedNotice.start_time{
                if let et = selectedNotice.end_time{
                    durationLabel.text = st + " 至 " + et
                }else{
                    durationLabel.text = st
                }
                timeLabel.isHidden = false
                durationLabel.isHidden = false
            }
        }
        content.isHidden = false
        cover.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        content.isHidden = true
        cover.isHidden = true
        timeLabel.isHidden = true
        durationLabel.isHidden = true
        more.isHidden = true
    }

}

fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
