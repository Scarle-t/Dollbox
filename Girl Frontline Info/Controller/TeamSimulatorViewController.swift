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
    var totalEffi: Int = 0
    var editState: Bool = false
    
    @IBOutlet var imgTDoll: [UIImageView]!
    @IBOutlet var imgDelete: [UIButton]!
    @IBOutlet var imgDim: [UIView]!
    @IBOutlet var imgName: [UILabel]!
    @IBOutlet weak var totalEfficiency: UILabel!
    @IBOutlet weak var creditText: UITextView!
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
            activityViewController.popoverPresentationController?.sourceView = self.view
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
        let key = Int(index!) - 1
        displayTDolls.removeObject(forKey: String(key))
        Session.sharedInstance.selectedTDoll = TDoll()
        imgTDoll[index!].image = #imageLiteral(resourceName: "SelectTDoll")
        if localDB().readSettings()[0]{
            imgName[index!].text = ""
            imgName[index!].isEnabled = false
            imgName[index!].isHidden = true
        }
        totalEffi = 0
        for (_, value) in displayTDolls{
            totalEffi += Int((value as! TDoll).efficiency!)!
        }
        totalEfficiency.text = "\(totalEffi)"
    }
    
    func addDisplay(){
        let index = Int(from)! - 1
        if let TDoll = selectedTDoll{
            displayTDolls[from] = TDoll
            if localDB().readSettings()[0]{
                imgName[index].text = TDoll.Zh_Name
                imgName[index].isEnabled = true
                imgName[index].isHidden = false
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return true
    }
}
