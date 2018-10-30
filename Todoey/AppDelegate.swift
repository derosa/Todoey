//
//  AppDelegate.swift
//  Todoey
//
//  Created by David Erosa on 28/10/18.
//  Copyright © 2018 David Erosa. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print (Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            _ = try Realm()
        } catch{
            print("Error initializing Realm: \(error)   ")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }


    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
}

