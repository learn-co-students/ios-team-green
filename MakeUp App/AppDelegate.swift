//
//  AppDelegate.swift
//  MakeUp App
//
//  Created by Raquel Rahmey on 4/4/17.
//  Copyright © 2017 Raquel Rahmey. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var user: String? {
        return UserDefaults.standard.string(forKey: "userID")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: - Firebase and Facebook Config
        FIRApp.configure()
        
        // Initialize Facebook SDK and login User on the basis of persisted data
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //MARK: - Determine Initial View and Setup Window
        if user == nil {
            let signupViewController = SignUpViewController()
            setupWindow(with: UINavigationController(rootViewController: signupViewController))
        } else {
            guard let userID = user else { return false } // make sure user exists
            FirebaseManager.shared.loadUser(userID, completion: { () in
                let pageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
                self.setupWindow(with: pageViewController)
            })
        }
       
        //MARK: - Global Navigation and Button Styling
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: Fonts.Playfair(withStyle: .regular, sizeLiteral: 10)], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: Fonts.Playfair(withStyle: .black, sizeLiteral: 16), NSForegroundColorAttributeName: Palette.black.color], for: .normal)
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }

    
    func setupWindow(with rootViewController: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
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
        // Saves changes in the application's managed object context before the application terminates.
    }

}

