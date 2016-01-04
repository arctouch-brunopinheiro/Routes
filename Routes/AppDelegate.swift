//
//  AppDelegate.swift
//  Routes
//
//  Created by Marcone Magnus on 12/21/15.
//  Copyright © 2015 Marcone Magnus. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var routeListTVC : RouteListTVC?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.routeListTVC = RouteListTVC()
        
        self.window?.rootViewController = routeListTVC
        
        self.window?.makeKeyAndVisible()
        return true
    }

}

