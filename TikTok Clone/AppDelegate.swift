//
//  AppDelegate.swift
//  TikTok Clone
//
//  Created by Azim Güneş on 22.07.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configInitialVC()
        // Override point for customization after application launch.
        return true
    }
    
    func configInitialVC(){
    var initialVC = UIViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if Auth.auth().currentUser != nil {
            initialVC = storyboard.instantiateViewController(withIdentifier: tabbarId)
        } else {
            initialVC = storyboard.instantiateViewController(withIdentifier: mainId)
        }
      
}
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

