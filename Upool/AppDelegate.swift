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
    static var DEVICE_FCM_TOKEN = String()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let googleAPIKey = "AIzaSyCA7Zio35GKOQkTXL0DJt8gGabNPkJOD_o"
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)

        
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
        return true
    }
    
    //Notifications pop up while app is running
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let db = Firestore.firestore()
        
        //Handle notifications associated with chat messages
        if let toId = userInfo["toId"] as? String{
            handleChatNotifications(db, toId)
        }
        
        //handle notifications associated with sending a rideRequest
        if let ridePostId = userInfo["ridePostId"] as? String{
            handleRideRequestSentNotifications(db, ridePostId)
        }
        
        completionHandler()
    }
    
    fileprivate func handleChatNotifications(_ db: Firestore, _ toId: String) {
        db.collection("users").document(toId).getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                let chatlogVC = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
                let toUser = UPoolUser(dictionary: (snapshot?.data())!)
                chatlogVC.toUser = toUser
                
                //Push the chat log VC
                if let mainTabBarVC = self.window?.rootViewController?.presentedViewController as? UITabBarController{
                    if let chatVC = mainTabBarVC.viewControllers?[2] as? UINavigationController{
                        mainTabBarVC.selectedIndex = 2
                        //Dont push another chat log VC when it is currently open
                        if let _ = chatVC.viewControllers.last as? ChatLogViewController{
                            print("This is the Same ViewController")
                        } else {
                            chatVC.pushViewController(chatlogVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func handleRideRequestSentNotifications(_ db: Firestore, _ ridePostId: String) {
        db.collection("ridePosts").document(ridePostId).getDocument { (snapshot, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                let ridePost = RidePost(dictionary: (snapshot?.data())!)
                if let mainTabBarVC = self.window?.rootViewController?.presentedViewController as? UITabBarController{
                    if let myStatusNavVC = mainTabBarVC.viewControllers?[1] as? UINavigationController{
                        mainTabBarVC.selectedIndex = 1
                        //myStatusNavVC.pushViewController(chatlogVC, animated: true)
                        let detailVC = MyStatusDetailViewController()
                        detailVC.ridePost = ridePost
                        myStatusNavVC.pushViewController(detailVC, animated: true)
                    }
                }
            }
        }
    }
    
    //when registration is done
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppDelegate.DEVICE_FCM_TOKEN = fcmToken
        
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
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
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

