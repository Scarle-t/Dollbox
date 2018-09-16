//
//  TDollViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class TDollViewController: UIViewController {
    
    var selectedTDoll: TDoll?
    var selectedImg: UIImage?
    var from = ""
    var imgCache = Session.sharedInstance.imgSession
    var initialTouchPoint = CGPoint.zero
    
    @IBOutlet weak var Zh_name: UILabel!
    @IBOutlet weak var Eng_name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var efficiency: UILabel!
    @IBOutlet weak var health: UILabel!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var hitrate: UILabel!
    @IBOutlet weak var dodge: UILabel!
    @IBOutlet weak var movement_Speed: UILabel!
    @IBOutlet weak var crit_rate: UILabel!
    @IBOutlet weak var chain: UILabel!
    @IBOutlet weak var loads: UILabel!
    @IBOutlet weak var shield: UILabel!
    @IBOutlet weak var critLabel: UILabel!
    @IBOutlet weak var chainLabel: UILabel!
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var shieldLabel: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var ammo: UILabel!
    @IBOutlet weak var mre: UILabel!
    @IBOutlet weak var skill: UILabel!
    @IBOutlet weak var skill_desc: UITextView!
    @IBOutlet weak var build_time: UILabel!
    @IBOutlet weak var obtain_method: UITextView!
    @IBOutlet weak var area1: UIImageView!
    @IBOutlet weak var area2: UIImageView!
    @IBOutlet weak var area3: UIImageView!
    @IBOutlet weak var area4: UIImageView!
    @IBOutlet weak var area5: UIImageView!
    @IBOutlet weak var area6: UIImageView!
    @IBOutlet weak var area7: UIImageView!
    @IBOutlet weak var area8: UIImageView!
    @IBOutlet weak var area9: UIImageView!
    @IBOutlet weak var buff: UITextView!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        if dismissBtn.isHidden == false{
            let touchPoint = sender.location(in: view?.window)
            switch sender.state {
            case .began:
                initialTouchPoint = touchPoint
            case .changed:
                if touchPoint.y > initialTouchPoint.y {
                    view.frame.origin.y = touchPoint.y - initialTouchPoint.y
                }
            case .ended, .cancelled:
                if touchPoint.y - initialTouchPoint.y > 200 {
                    dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.frame = CGRect(x: 0,
                                                 y: 0,
                                                 width: self.view.frame.size.width,
                                                 height: self.view.frame.size.height)
                    })
                }
            case .failed, .possible:
                break
            }
        }
    }
    @IBOutlet weak var sepView: UISegmentedControl!
    @IBOutlet weak var info: UIView!
    @IBOutlet weak var consum: UIView!
    @IBOutlet weak var skillInfo: UIView!
    @IBOutlet weak var buffInfo: UIView!
    @IBOutlet weak var method: UIView!
    @IBAction func sepInfo(_ sender: UISegmentedControl) {
        swipeView()
    }
    
    func swipeView(){
        switch sepView.selectedSegmentIndex{
        case 0:
            info.isHidden = false
            consum.isHidden = true
            skillInfo.isHidden = true
            buffInfo.isHidden = true
            method.isHidden = true
            self.title = "人形資料"
        case 1:
            info.isHidden = true
            consum.isHidden = false
            skillInfo.isHidden = true
            buffInfo.isHidden = true
            method.isHidden = true
            self.title = "消耗"
        case 2:
            info.isHidden = true
            consum.isHidden = true
            skillInfo.isHidden = false
            buffInfo.isHidden = true
            method.isHidden = true
            self.title = "技能"
        case 3:
            info.isHidden = true
            consum.isHidden = true
            skillInfo.isHidden = true
            buffInfo.isHidden = false
            method.isHidden = true
            self.title = "增益"
        case 4:
            info.isHidden = true
            consum.isHidden = true
            skillInfo.isHidden = true
            buffInfo.isHidden = true
            method.isHidden = false
            self.title = "入手方法"
        default:
            print(sepView.selectedSegmentIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if from == "stats"{
            dismissBtn.isHidden = false
        }
        sepView.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Mohave", size: 14)!
            ], for: UIControlState.normal)
        sepView.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Mohave", size: 14)!
            ], for: UIControlState.selected)
        Zh_name.text = selectedTDoll?.Zh_Name
        Eng_name.text = selectedTDoll?.Eng_Name
        type.text = selectedTDoll?.type
        efficiency.text = selectedTDoll?.efficiency
        health.text = selectedTDoll?.health
        attack.text = selectedTDoll?.attack
        speed.text = selectedTDoll?.speed
        hitrate.text = selectedTDoll?.hit_rate
        dodge.text = selectedTDoll?.dodge
        movement_Speed.text = selectedTDoll?.movement
        if let critRate = selectedTDoll?.critical{
            if critRate == "0"{
                critLabel.isHidden = true
                crit_rate.isHidden = true
            }else{
                critLabel.isHidden = false
                crit_rate.isHidden = false
                crit_rate.text = critRate + "%"
            }
        }
        if selectedTDoll?.chain == "0" {
            chainLabel.isHidden = true
            chain.isHidden = true
        }else{
            chainLabel.isHidden = false
            chain.isHidden = false
            chain.text = selectedTDoll?.chain
        }
        if selectedTDoll?.loads == "0" {
            loadLabel.isHidden = true
            loads.isHidden = true
        }else{
            loadLabel.isHidden = false
            loads.isHidden = false
            loads.text = selectedTDoll?.loads
        }
        if selectedTDoll?.shield == "0" {
            shieldLabel.isHidden = true
            shield.isHidden = true
        }else{
            shieldLabel.isHidden = false
            shield.isHidden = false
            shield.text = selectedTDoll?.shield
        }
        ammo.text = selectedTDoll?.ammo
        mre.text = selectedTDoll?.mre
        skill.text = selectedTDoll?.skill_name
        skill_desc.text = selectedTDoll?.skill_desc
        if let buildtime = selectedTDoll?.build_time{
            if buildtime == "00:00:00"{
                build_time.text = "無法製造"
            }else{
                build_time.text = buildtime
            }
        }
        obtain_method.text = selectedTDoll?.obtain_method
        cover.image = selectedImg
        switch selectedTDoll?.position{
        case "1":
            area1.image = #imageLiteral(resourceName: "position")
        case "2":
            area2.image = #imageLiteral(resourceName: "position")
        case "3":
            area3.image = #imageLiteral(resourceName: "position")
        case "4":
            area4.image = #imageLiteral(resourceName: "position")
        case "5":
            area5.image = #imageLiteral(resourceName: "position")
        case "6":
            area6.image = #imageLiteral(resourceName: "position")
        case "7":
            area7.image = #imageLiteral(resourceName: "position")
        case "8":
            area8.image = #imageLiteral(resourceName: "position")
        case "9":
            area9.image = #imageLiteral(resourceName: "position")
        default:
            break
        }
        
        if selectedTDoll?.area1 == "1"{
            area1.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area2 == "1"{
            area2.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area3 == "1"{
            area3.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area4 == "1"{
            area4.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area5 == "1"{
            area5.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area6 == "1"{
            area6.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area7 == "1"{
            area7.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area8 == "1"{
            area8.image = #imageLiteral(resourceName: "area")
        }
        if selectedTDoll?.area9 == "1"{
            area9.image = #imageLiteral(resourceName: "area")
        }
        buff.text = selectedTDoll?.effect

        self.title = "人形資料"
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedTDoll?.stars == "2"{
            setNavBarColor().white(self)
        }
        if selectedTDoll?.stars == "3"{
            setNavBarColor().blue(self)
        }
        if selectedTDoll?.stars == "4"{
            setNavBarColor().green(self)
        }
        if selectedTDoll?.stars == "5"{
            setNavBarColor().gold(self)
        }
        if selectedTDoll?.stars == "EXTRA"{
            setNavBarColor().purple(self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
