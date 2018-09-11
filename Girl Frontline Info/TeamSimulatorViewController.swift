//
//  TeamSimulatorViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 27/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class TeamSimulatorViewController: UIViewController {
    
    var selectedTDoll: TDoll?
    var from: String = ""
    var selectedTDImage: UIImage?
    
    var displayTDolls: NSMutableDictionary = NSMutableDictionary()
    
    @IBOutlet var imgTDoll: [UIImageView]!
    
    @IBOutlet var imgDelete: [UIButton]!
    
    @IBOutlet var imgDim: [UIView]!

    @IBOutlet weak var totalEfficiency: UILabel!
    
    var totalEffi: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedTDoll = Session.sharedInstance.loadTDoll()
        
        selectedTDImage = Session.sharedInstance.loadImage()
        
        if from != "" && Session.sharedInstance.selected{
            
            if displayTDolls.count > 0{
                
                for (_, item) in displayTDolls{
                    
                    if selectedTDoll?.Zh_Name == (item as! TDoll).Zh_Name{
                        
                        displayWarning(title: "重複人形")
                        return
                        
                    }

            }
            }
            addDisplay()
        }
        
        Session.sharedInstance.selected = false
        
    }
    
    func addDisplay(){
        let index = Int(from)! - 1
        
        if let TDoll = selectedTDoll{
            displayTDolls[from] = TDoll
            if let image = selectedTDImage{
                imgTDoll[index].image = image
                imgTDoll[index].alpha = 1.0
                totalEffi = 0
                for (_, value) in displayTDolls{
                    totalEffi += Int((value as! TDoll).efficiency!)!
                }
                totalEfficiency.text = "\(totalEffi)"
            }
        }
    }
    
    func displayWarning(title: String){
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if displayTDolls.count <= 5 {
            Session.sharedInstance.selected = false
            
            let selectVC = segue.destination as! SelectTDollViewController
            
            self.from = segue.identifier!
            
            selectVC.from = self.from
        }

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let id = Int(identifier){
            let key = displayTDolls[identifier] != nil
            if case 1...9 = id, !key {
                
                if displayTDolls.count == 5 {
                    
                    displayWarning(title: "已選擇5位人形")
                    
                    return false
                } else {
                    return true
                }
                
            }
            
            
        }
        
        // by default, transition
        return true
    }
    
    @IBOutlet weak var creditText: UITextView!
    
    var editState: Bool = false
    
    @IBOutlet weak var navBtn: UIBarButtonItem!
    
    
    @IBAction func btnShare(_ sender: UIBarButtonItem) {
        
        if editState {
            for i in 0...(imgDelete.count - 1){
                imgDelete[i].isHidden = true
                imgDim[i].isHidden = true
            }
            
            nav.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(btnShare(_:))), animated: true)
            
            editState = false
            
        }else{
            
            creditText.isHidden = false
            
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
            let image = renderer.image { ctx in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
            
            creditText.isHidden = true
            
            // set up activity view controller
            let imageToShare = [ image ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
        }

    }
    
    @IBOutlet weak var nav: UINavigationItem!
    
    @IBAction func imgLongPress(_ sender: UILongPressGestureRecognizer) {
        
        for i in 0...(imgDelete.count - 1){
            imgDelete[i].isHidden = false
            imgDim[i].isHidden = false
        }
        
        editState = true
        nav.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnShare(_:))), animated: true)

    }
    
    @IBAction func deleteTDoll(_ sender: UIButton){
        
        let index = imgDelete.index(of: sender)
        let key = index! - 1
        displayTDolls.removeObject(forKey: key)
        imgTDoll[index!].image = #imageLiteral(resourceName: "SelectTDoll")
        
        totalEffi = 0
        for (_, value) in displayTDolls{
            totalEffi += Int((value as! TDoll).efficiency!)!
        }
        totalEfficiency.text = "\(totalEffi)"
        
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
