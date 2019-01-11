//
//  TDollViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 8/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class TDollViewController: UIViewController {
    
    deinit {
        print("Deinit TDollViewController")
    }
    
    var selectedTDoll: TDoll?
    var selectedImg: UIImage?
    var from = ""
    var imgCache = Session.sharedInstance.imgSession
    var initialTouchPoint = CGPoint.zero
    var TDollQ = UIImage()
    
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
    @IBOutlet weak var cvName: UILabel!
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
    @IBAction func imgTap(_ sender: UITapGestureRecognizer) {
        let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "imgView") as! noticeEnlargeViewController
        detailVC.selectedImg = selectedImg
        self.present(detailVC, animated: true, completion: nil)
    }
    @IBOutlet weak var sepView: UISegmentedControl!
    @IBOutlet weak var sepView2: UISegmentedControl!
    @IBOutlet weak var info: UIScrollView!
    @IBOutlet weak var consum: UIScrollView!
    @IBOutlet weak var skillInfo: UIScrollView!
    @IBOutlet weak var buffInfo: UIScrollView!
    @IBOutlet weak var method: UIScrollView!
    @IBAction func sepInfo(_ sender: UISegmentedControl) {
        swipeView(sender)
    }
    
    func swipeView(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
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
    func accentColor(){
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accentColor()
        
        if let photo_path = selectedTDoll?.ID{
            let urlString = URL(string: "https://dollbox.scarletsc.net/img/Q/\(photo_path).png")
            let url = URL(string: "https://dollbox.scarletsc.net/img/Q/\(photo_path).png")
            
            if let imageFromCache = self.imgCache.object(forKey: url as AnyObject) as? UIImage{
                TDollQ = imageFromCache
            }else{
                DownloadPhoto().get(url: url!) { data, response, error in
                    guard let imgData = data, error == nil else { return }
                    print(url!)
                    print("Download Finished")
                    DispatchQueue.main.async(execute: { () -> Void in
                        let imgToCache = UIImage(data: imgData)
                        if urlString == url{
                            self.TDollQ = imgToCache ?? #imageLiteral(resourceName: "position")
                        }
                        if let imginCache = imgToCache{
                            self.imgCache.setObject(imginCache, forKey: urlString as AnyObject)
                        }
                    })
                }
            }
        }
        
        if from == "stats"{
            dismissBtn.isHidden = false
            sepView2.isHidden = false
        }
        sepView.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 14)!
            ], for: UIControl.State.normal)
        sepView.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 14)!
            ], for: UIControl.State.selected)
        sepView2.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 14)!
            ], for: UIControl.State.normal)
        sepView2.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Mohave", size: 14)!
            ], for: UIControl.State.selected)
        Zh_name.text = selectedTDoll?.Zh_Name
        Eng_name.text = selectedTDoll?.Eng_Name
        if selectedTDoll?.stars != "EXTRA"{
            type.text = (selectedTDoll?.stars)! + "星" + (selectedTDoll?.type)!
        }else{
            type.text = "特典" + (selectedTDoll?.type)!
        }
        
        efficiency.text = selectedTDoll?.efficiency
        health.text = selectedTDoll?.health
        attack.text = selectedTDoll?.attack
        speed.text = selectedTDoll?.speed
        hitrate.text = selectedTDoll?.hit_rate
        dodge.text = selectedTDoll?.dodge
        movement_Speed.text = selectedTDoll?.movement
        cvName.text = selectedTDoll?.cv
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
        accentColor()
        
        switch selectedTDoll?.position{
        case "1":
            area1.image = TDollQ
        case "2":
            area2.image = TDollQ
        case "3":
            area3.image = TDollQ
        case "4":
            area4.image = TDollQ
        case "5":
            area5.image = TDollQ
        case "6":
            area6.image = TDollQ
        case "7":
            area7.image = TDollQ
        case "8":
            area8.image = TDollQ
        case "9":
            area9.image = TDollQ
        default:
            break
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC  = segue.destination as! noticeEnlargeViewController
        detailVC.selectedImg = self.selectedImg
    }
}
