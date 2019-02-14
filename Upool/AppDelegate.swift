//
//  AppDelegate.swift
//  Upool
//
//  Created by Anthony Lee on 1/22/19.
//  Copyright © 2019 anthonyLee. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let googleAPIKey = "AIzaSyCA7Zio35GKOQkTXL0DJt8gGabNPkJOD_o"
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if let _ = Auth.auth().currentUser {
            // segue to main view controller
            print("signed in")
            let loginVC = LoginViewController()
            window?.rootViewController = loginVC
            loginVC.signedIn = true
        } else {
            // sign in
            window?.rootViewController = LoginViewController()
            
        }
        
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("Signout Unsuccessful")
//        }


//        let ridesVC = OfferedRidesCollectionViewController(collectionViewLayout: UICollectionViewLayout())
//        let navigationVC = UINavigationController(rootViewController: ridesVC)
//        window?.rootViewController = navigationVC
//        UINavigationBar.appearance().barTintColor = Colors.maroon
//        UINavigationBar.appearance().titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor : UIColor.white,
//        ]
        
        
        //notifications
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in
                
        })
//        let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        application.registerUserNotificationSettings(settings)
//        
//        application.registerForRemoteNotifications()
        let a = 10
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


}

