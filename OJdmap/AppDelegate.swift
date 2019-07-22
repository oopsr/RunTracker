//
//  AppDelegate.swift
//  InfinityTracker
//
//  Created by Alex on 31/08/2017.
//  Copyright © 2017 AleksZilla. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	weak var KinjundofoikjjkController: KinjundofoikjjkController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Londpradarance.coklinuyhdsddNavigationBar()
        setWindowBackgroundColor()
		
        return true
    }
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		((window?.rootViewController as? UINavigationController)?.viewControllers.first as? BunceofimjunController)?.jinlokijnhuhshjjdsdPermission(updateView: true)
		KinjundofoikjjkController?.yeerrththfStopNeeded()
	}
    
    private func setWindowBackgroundColor() {
        window?.backgroundColor = UIColor.white
    }

}
