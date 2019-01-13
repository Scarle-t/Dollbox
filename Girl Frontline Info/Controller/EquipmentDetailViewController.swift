//
//  EquipmentDetailViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 17/10/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class EquipmentDetailViewController: UIViewController {
    
    deinit {
        print("Deinit EquipmentDetailViewController")
    }
    
    var selectedEquip: Equipment?
    var selectedImg: UIImage?
    var from: String?
    var initialTouchPoint = CGPoint.zero
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var starType: UILabel!
    @IBOutlet weak var obtain: UITextView!
    @IBOutlet weak var stat: UITextView!
    @IBOutlet weak var build_time: UILabel!
    @IBOutlet weak var build_label: UILabel!
    @IBOutlet weak var btnDismiss: UIButton!
    @IBAction func imgTap(_ sender: UITapGestureRecognizer) {
        let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "imgView") as! noticeEnlargeViewController
        detailVC.selectedImg = selectedImg
        self.present(detailVC, animated: true, completion: nil)
    }
    @IBAction func dismissBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        if btnDismiss.alpha == 1{
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let image = selectedImg else {return}
        guard let ename = selectedEquip?.name else {return}
        guard let star = selectedEquip?.star else {return}
        guard let type = selectedEquip?.type else {return}
        guard let obtain_method = selectedEquip?.obtain_method else {return}
        guard let bt = selectedEquip?.build_time else {return}
        guard let stats = selectedEquip?.stat else {return}
        
        self.title = ename
        
        if from == "stats"{
            btnDismiss.alpha = 1
        }
        
        img.image = image
        name.text = ename
        starType.text = "\(star)星" + type
        obtain.text = obtain_method
        stat.text = stats
        if bt == "00:00:00"{
            build_time.isHidden = true
            build_label.isHidden = true
        }else{
            build_time.isHidden = false
            build_label.isHidden = false
            build_time.text = bt
        }
        
        switch star {
        case 2:
            setNavBarColor().white(self)
        case 3:
            setNavBarColor().blue(self)
        case 4:
            setNavBarColor().green(self)
        case 5:
            setNavBarColor().gold(self)
        default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
