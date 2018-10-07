//
//  OfflineSettingsViewController.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 2/7/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

class OfflineSettingsViewController: UITableViewController, VersionProtocol, localDBDelegate, localDataDelegate, URLSessionDelegate {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tsLabel: UILabel!
    @IBOutlet weak var offlineToggle: UITableViewCell!
    @IBOutlet weak var localVersion: UILabel!
    @IBOutlet weak var localTS: UILabel!
    @IBOutlet weak var localCheck: UILabel!
    @IBOutlet weak var donwImgToggle: UITableViewCell!
    
    let ver = Version()
    let switchView = UISwitch(frame: .zero)
    let downImgSwitch = UISwitch(frame: .zero)
    let localSearch = localDB()
    let localData = downloadData()
    let startAlert = UIAlertController(title: "下載中。。。", message: nil, preferredStyle: .alert)
    let prog = UIProgressView(frame: CGRect(x: 10, y: 50, width: 250, height: 0))
    let noti = UINotificationFeedbackGenerator()
    let tap = UISelectionFeedbackGenerator()
    let localPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let imgAlert = UIAlertController(title: "下載圖片", message: "這可能需要一分鐘至數分鐘時間，請耐心等候", preferredStyle: .alert)
    let delImgAlert = UIAlertController(title: "將刪除已下載圖片", message: nil, preferredStyle: .alert)
    
    var userDefaults = UserDefaults.standard
    var type = String()
    var localVerArray = [String]()
    var onlineVerArray = NSArray()
    
    func start(){
        prog.progressViewStyle = .bar
        prog.tintColor = UIColor(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0)
        if type == "update"{
            if localVerArray.count == 0 || onlineVerArray.count == 0 {
                ver.localVersion()
                ver.getVersion()
            }
            if localVerArray[0] == String(onlineVerArray[0] as! Int){
                let alert = UIAlertController(title: "已是最新版本，無需更新", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                noti.notificationOccurred(.warning)
            }else{
                startAlert.view.addSubview(prog)
                self.present(startAlert, animated: true, completion: nil)
                self.localData.getItems(type, source: self)
            }
        }else{
            startAlert.view.addSubview(prog)
            self.present(startAlert, animated: true, completion: nil)
            self.localData.getItems(type, source: self)
        }
        self.localCheck.isEnabled = true
    }
    func finish() {
        prog.progress = 1.0
        startAlert.dismiss(animated: true, completion: {
            let alert = UIAlertController(title: "下載完成", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        noti.notificationOccurred(.success)
        self.localSearch.readVersion()
    }
    func failed() {
        DispatchQueue.main.async(execute: {
            self.startAlert.dismiss(animated: true, completion: {
                let alert = UIAlertController(title: "下載失敗", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                    localDB().writeSettings(item: "isOffline", value: "0")
                    localDB().delete(self)
                    self.switchView.setOn(false, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "重試", style: .default, handler: { _ in
                    self.start()
                }))
                self.present(alert, animated: true, completion: nil)
                self.noti.notificationOccurred(.error)
            })
        })
    }
    func returndData(items: NSArray) {
        localVerArray = items as! [String]
        localVersion.text = " "
        localTS.text = " "
        localVersion.text = items[3] as? String
        localTS.text = items[1] as? String
    }
    func returnLocal(version: [String]) {
        localVerArray = version
        localVersion.text = "\(version[0])"
        localTS.text = "\(version[1])"
    }
    func returnVersion(version: NSMutableArray) {
        tap.selectionChanged()
        onlineVerArray = version
        versionLabel.text = "\(version[0])"
        tsLabel.text = "\(version[1])"
        
        let db = Session.sharedInstance.db
        if let mydb = db{
            let statement = mydb.fetch("dataversion", cond: nil, order: nil)
            if sqlite3_step(statement) != SQLITE_ROW{
                let _ = mydb.insert("dataversion", rowInfo: [
                    "online_last" : "'" + (version[1] as! String) + "'",
                    "online_version" : String(version[0] as! Int)
                    ])
            }else{
                let _ = mydb.update("dataversion", cond: nil, rowInfo: [
                    "online_last" : "'" + (version[1] as! String) + "'",
                    "online_version" : String(version[0] as! Int)
                    ])
            }
        }
    }
    func switchAlert(_ state: Bool) {
        if state{
            let db = Session.sharedInstance.db
            if let mydb = db{
                let statement = mydb.fetch("info", cond: nil, order: nil)
                if sqlite3_step(statement) == SQLITE_ROW{
                    let alert = UIAlertController(title: "更新資料檔", message: "這可能需要一分鐘至數分鐘時間，請耐心等候", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                        localDB().writeSettings(item: "isOffline", value: "1")
                        self.type = "update"
                        self.start()
                    }))
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                        self.switchView.setOn(false, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "下載資料檔", message: "這可能需要一分鐘至數分鐘時間，請耐心等候", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
                        localDB().writeSettings(item: "isOffline", value: "1")
                        self.type = "download"
                        self.start()
                    }))
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                        self.switchView.setOn(false, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }else{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "刪除離線資料檔", style: .destructive, handler: { _ in
                localDB().writeSettings(item: "isOffline", value: "0")
                localDB().delete(self)
                self.localVersion.text = " "
                self.localTS.text = " "
                self.localCheck.isEnabled = false
            }))
            alert.addAction(UIAlertAction(title: "保留離線資料檔", style: .default, handler: { _ in
                localDB().writeSettings(item: "isOffline", value: "0")
                self.localCheck.isEnabled = false
                self.noti.notificationOccurred(.success)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                self.switchView.setOn(true, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func parseImg(_ data: Data, mode: String){
        var jsonResult = NSArray()
        var jsonElement = NSDictionary()
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        } catch let error as NSError {
            print(error)
        }
        for i in 0 ..< jsonResult.count
        {
            jsonElement = jsonResult[i] as! NSDictionary
            
            guard let id = jsonElement["ID"] else {return}
            let cover = id as! String + ".jpg"
            if mode == "download"{
                let url = URL(string: "https://scarletsc.net/girlfrontline/img/" + cover)
                let filePath = self.localPath[self.localPath.count-1].absoluteString + cover
                DownloadPhoto().get(url: url!) { data, response, error in
                    guard let imgData = data, error == nil else { return }
                    DispatchQueue.main.async(execute: { () -> Void in
                        let img = UIImage(data: imgData)?.jpegData(compressionQuality: 0.1)
                        do{
                            try img?.write(to: URL(string: filePath)!)
                            self.prog.progress += 0.04
                        }catch{
                            print(error)
                        }
                    })
                }
            }else if mode == "delete"{
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
                let destinationPath = documentsPath.appendingPathComponent(cover)
                do{
                    try FileManager.default.removeItem(atPath: destinationPath)
                }catch{
                    print(error)
                }
            }
            
        }
    }
    func donwloadImg(){
        imgAlert.dismiss(animated: true, completion: nil)
        prog.progress = 0.0
        prog.progressViewStyle = .bar
        prog.tintColor = UIColor(red: 0.0, green: 122/255, blue: 255/255, alpha: 1.0)
        startAlert.view.addSubview(prog)
        self.present(startAlert, animated: true, completion: nil)
        if localDB().readSettings()[0]{
            let db = Session.sharedInstance.db
            if let mydb = db{
                let statement = mydb.fetch("info", cond: nil, order: nil)
                while sqlite3_step(statement) == SQLITE_ROW{
                    let cover = String(cString: sqlite3_column_text(statement, 0)) + ".jpg"
                    let url = URL(string: "https://scarletsc.net/girlfrontline/img/" + cover)
                    let filePath = self.localPath[self.localPath.count-1].absoluteString + cover
                    DownloadPhoto().get(url: url!) { data, response, error in
                        guard let imgData = data, error == nil else { return }
                        DispatchQueue.main.async(execute: { () -> Void in
                            let img = UIImage(data: imgData)?.jpegData(compressionQuality: 0.1)
                            do{
                                try img?.write(to: URL(string: filePath)!)
                                self.prog.progress += 0.04
                            }catch{
                                print(error)
                            }
                        })
                    }
                }
            }
        }else{
            let url: URL = URL(string: "https://scarletsc.net/girlfrontline/search.php")!
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil )
            let task = defaultSession.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print("Failed to download data")
                }else {
                    print("Data downloaded")
                    self.parseImg(data!, mode: "download")
                }
            }
            task.resume()
        }
        
        startAlert.dismiss(animated: true, completion: {
            let alert = UIAlertController(title: "下載完成", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        userDefaults.set(true, forKey: "offlineImg")
        noti.notificationOccurred(.success)
    }
    func removeImg(){
        delImgAlert.dismiss(animated: true, completion: nil)
        
        if localDB().readSettings()[0]{
            let db = Session.sharedInstance.db
            if let mydb = db{
                let statement = mydb.fetch("info", cond: nil, order: nil)
                while sqlite3_step(statement) == SQLITE_ROW{
                    let cover = String(cString: sqlite3_column_text(statement, 0)) + ".jpg"
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
                    let destinationPath = documentsPath.appendingPathComponent(cover)
                    do{
                        try FileManager.default.removeItem(atPath: destinationPath)
                    }catch{
                        print(error)
                    }
                }
            }
        }else{
            let url: URL = URL(string: "https://scarletsc.net/girlfrontline/search.php")!
            let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil )
            let task = defaultSession.dataTask(with: url) {
                (data, response, error) in
                if error != nil {
                    print("Failed to download data")
                }else {
                    print("Data downloaded")
                    self.parseImg(data!, mode: "delete")
                }
            }
            task.resume()
        }
        
        self.userDefaults.set(false, forKey: "offlineImg")
        let alert = UIAlertController(title: "已刪除", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        noti.notificationOccurred(.success)
    }
    func imgToggles(_ state: Bool){
        if state{
            self.present(imgAlert, animated: true, completion: nil)
        }else{
            self.present(delImgAlert, animated: true, completion: nil)
        }
    }
    @objc func switchChanged(_ sender : UISwitch!){
        switchAlert(sender.isOn)
    }
    @objc func imgSwitch(_ sender: UISwitch!){
        imgToggles(sender.isOn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
            self.donwloadImg()
        }))
        imgAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {_ in
            self.downImgSwitch.setOn(false, animated: true)
        }))
        delImgAlert.addAction(UIAlertAction(title: "確定", style: .default, handler: { _ in
            self.removeImg()
        }))
        delImgAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {_ in
            self.downImgSwitch.setOn(true, animated: true)
        }))
        
        switchView.setOn(localDB().readSettings()[0], animated: true)
        switchView.tag = 1 // for detect which row switch Changed
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        offlineToggle.accessoryView = switchView
        downImgSwitch.setOn(userDefaults.bool(forKey: "offlineImg"), animated: true)
        downImgSwitch.addTarget(self, action: #selector(self.imgSwitch(_:)), for: .valueChanged)
        donwImgToggle.accessoryView = downImgSwitch
        
        versionLabel.text = " "
        tsLabel.text = " "
        localVersion.text = " "
        localTS.text = " "
        ver.delegate = self
        localSearch.delegate = self
        ver.getVersion()
        localData.delegate = self
        
        if localDB().readSettings()[0]{
            ver.localVersion()
            localCheck.isEnabled = true
        }else{
            localCheck.isEnabled = false
        }
        let db = Session.sharedInstance.db
        if let mydb = db{
            let statement = mydb.fetch("info", cond: nil, order: nil)
            if sqlite3_step(statement) == SQLITE_ROW{
                ver.localVersion()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1, 2:
            return 3
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 1:
            switch indexPath.row{
            case 0:
                versionLabel.text = " "
                tsLabel.text = " "
                ver.getVersion()
            default:
                break
            }
        case 2:
            switch indexPath.row{
            case 0:
                if localDB().readSettings()[0]{
                    localVersion.text = " "
                    localTS.text = " "
                    ver.localVersion()
                    let db = Session.sharedInstance.db
                    if let mydb = db{
                        let statement = mydb.fetch("info", cond: nil, order: nil)
                        if sqlite3_step(statement) == SQLITE_ROW{
                            self.type = "update"
                            self.start()
                        }else{
                            self.type = "download"
                            self.start()
                        }
                    }
                }
            default:
                break
            }
        default:
            break
        }
    }

}
