//
//  AppDelegate.swift
//  ExpireMate
//
//  Created by Luthfi Asmara on 25/04/23.
//

import Foundation
import UserNotifications
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        UNUserNotificationCenter.current().delegate = self
        return true
    }
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("yoyo")
        completionHandler(.banner)
    }
    
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//            // Called when a new scene session is being created.
//            // Use this method to select a configuration to create the new scene with.
//            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//        }
}


