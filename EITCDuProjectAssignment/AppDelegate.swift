//
//  AppDelegate.swift
//  EITCDuProjectAssignment
//
//  Created by Kirti Kalra on 18/10/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if isLoggedIn() {
                        
            let postsVC = storyboard.instantiateViewController(withIdentifier: "PostsViewController")
            window?.rootViewController = UINavigationController(rootViewController: postsVC)
            print("Navigating to HomeViewController")
        } else {
            print("Navigating to LoginViewController")
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            window?.rootViewController = UINavigationController(rootViewController: loginVC)
        }
        // Override point for customization after application launch.
        window?.makeKeyAndVisible()
        return true
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

// MARK: Private Methods
extension AppDelegate {
    private func isLoggedIn() -> Bool {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        return isLoggedIn
    }
}

