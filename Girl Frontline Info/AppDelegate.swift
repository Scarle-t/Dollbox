//
//  AppDelegate.swift
//  Girl Frontline Info
//
//  Created by Scarlet on 7/5/2018.
//  Copyright © 2018 Scarlet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let modelName = UIDevice.current.modelName
        
        switch modelName{
            
        case "iPhone 6/s/7/8":
            let storyboard = UIStoryboard(name: "iPhone678", bundle: nil)
            let tabVc = storyboard.instantiateViewController(withIdentifier: "iPhone678TB") as! UITabBarController
            
            self.window?.rootViewController = tabVc
            
            print(modelName)
            
        case "iPhone X":
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabVc = storyboard.instantiateViewController(withIdentifier: "iPhoneX") as! UITabBarController
            
            self.window?.rootViewController = tabVc
            
            print(modelName)
            
        default:
            
            break
            
        }
        
        //self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVc = self.window?.rootViewController as! UITabBarController
        
        let searchNC = storyboard.instantiateViewController(withIdentifier: "searchNC") as! UINavigationController
        let cateNC = storyboard.instantiateViewController(withIdentifier: "cateNC") as! UINavigationController
        
        let simNC = storyboard.instantiateViewController(withIdentifier: "simNC") as! UINavigationController
        
        let typeSearch = storyboard.instantiateViewController(withIdentifier: "typeSearch")
        let starSearch = storyboard.instantiateViewController(withIdentifier: "starSearch")
        let timeSearch = storyboard.instantiateViewController(withIdentifier: "timeSearch")
        
        if shortcutItem.type == "net.scarletsc.Girl-Frontline-Info.TimeSearch"{
            
            tabVc.viewControllers = [searchNC, cateNC, simNC]
            tabVc.selectedViewController = searchNC
            searchNC.navigationController?.pushViewController(timeSearch, animated: true)
            searchNC.show(timeSearch, sender: self)
            self.window?.makeKeyAndVisible()
            
        }
        
        if shortcutItem.type == "net.scarletsc.Girl-Frontline-Info.StarSearch"{
            tabVc.viewControllers = [searchNC, cateNC, simNC]
            tabVc.selectedViewController = cateNC
            tabVc.navigationController?.pushViewController(starSearch, animated: true)
            cateNC.show(starSearch, sender: self)
            self.window?.makeKeyAndVisible()
        }
        
        if shortcutItem.type == "net.scarletsc.Girl-Frontline-Info.TypeSearch"{
            tabVc.viewControllers = [searchNC, cateNC, simNC]
            tabVc.selectedViewController = cateNC
            tabVc.navigationController?.pushViewController(typeSearch, animated: true)
            cateNC.show(typeSearch, sender: self)
            self.window?.makeKeyAndVisible()
        }
        
        if shortcutItem.type == "net.scarletsc.Girl-Frontline-Info.Simulator"{
            tabVc.viewControllers = [searchNC, cateNC, simNC]
            tabVc.selectedViewController = simNC
            //simNC.show(simNC, sender: self)
            self.window?.makeKeyAndVisible()
        }
 
        
    }


}

