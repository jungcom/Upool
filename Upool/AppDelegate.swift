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
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    static var DEVICEID = String()
    
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
        if let user = Auth.auth().currentUser {
            // segue to main view controller if the user is email verified
            if user.isEmailVerified{
                print("signed in")
                let loginVC = LoginViewController()
                window?.rootViewController = loginVC
                loginVC.signedIn = true
            } else {
                window?.rootViewController = LoginViewController()
            }

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
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
//        let settings: UIUserNotificationSettings =
//            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        application.registerUserNotificationSettings(settings)
//        
        return true
    }
    
    //local notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let db = Firestore.firestore()
        let chatlogVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        //Get the toId
        if let toId = userInfo["toId"] as? String{
            
            db.collection("users").document(toId).getDocument { (snapshot, error) in
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    let toUser = UPoolUser(dictionary: (snapshot?.data())!)
                    chatlogVC.toUser = toUser
                    
                    //Push the chat log VC
                    if let mainTabBarVC = self.window?.rootViewController?.presentedViewController as? UITabBarController{
                        if let chatVC = mainTabBarVC.viewControllers?[2] as? UINavigationController{
                            mainTabBarVC.selectedIndex = 2
                            chatVC.pushViewController(chatlogVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    //when registration is done
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppDelegate.DEVICEID = fcmToken
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
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

