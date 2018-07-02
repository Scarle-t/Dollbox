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
    
    var initialTouchPoint = CGPoint.zero
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if from == "stats"{
            dismissBtn.isHidden = false
        }
        
        sepView.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 14)
            ], for: UIControl.State.normal)
        
        sepView.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 14)
            ], for: UIControl.State.selected)
        
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
        
        
        if selectedTDoll?.stars == "2"{
            navigationController?.navigationBar.barTintColor = UIColor.white
            
            
        }
        
        if selectedTDoll?.stars == "3"{
            navigationController?.navigationBar.barTintColor = UIColor(red: 116.0/255.0, green: 220.0/255.0, blue: 204.0/255.0, alpha: 1.0)
            
        }
        
        if selectedTDoll?.stars == "4"{
            navigationController?.navigationBar.barTintColor = UIColor(red: 210.0/255.0, green: 226.0/255.0, blue: 102.0/255.0, alpha: 1.0)
           
        }
        
        if selectedTDoll?.stars == "5"{
            navigationController?.navigationBar.barTintColor = UIColor(red: 253.0/255.0, green: 181.0/255.0, blue: 35.0/255.0, alpha: 1.0)
           
        }
        
        if selectedTDoll?.stars == "EXTRA"{
            navigationController?.navigationBar.barTintColor = UIColor(red: 223.0/255.0, green: 180.0/255.0, blue: 253.0/255.0, alpha: 1.0)
        
        }
        
        self.title = "人形資料"
        
    }
    
    @IBOutlet weak var sepView: UISegmentedControl!
    
    @IBOutlet weak var info: UIView!
    @IBOutlet weak var consum: UIView!
    @IBOutlet weak var skillInfo: UIView!
    @IBOutlet weak var buffInfo: UIView!
    @IBOutlet weak var method: UIView!
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        
        if sepView.selectedSegmentIndex != 0{
            sepView.selectedSegmentIndex = sepView.selectedSegmentIndex - 1
            swipeView()
        }
        
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        
        if sepView.selectedSegmentIndex != 4{
            sepView.selectedSegmentIndex = sepView.selectedSegmentIndex + 1
            swipeView()
        }
        
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
    
    @IBAction func sepInfo(_ sender: UISegmentedControl) {
    
        swipeView()
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
