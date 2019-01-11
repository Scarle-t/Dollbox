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
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var starType: UILabel!
    @IBOutlet weak var obtain: UITextView!
    @IBOutlet weak var stat: UITextView!
    @IBOutlet weak var build_time: UILabel!
    @IBOutlet weak var build_label: UILabel!
    @IBAction func imgTap(_ sender: UITapGestureRecognizer) {
        let detailVC  = self.storyboard?.instantiateViewController(withIdentifier: "imgView") as! noticeEnlargeViewController
        detailVC.selectedImg = selectedImg
        self.present(detailVC, animated: true, completion: nil)
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
