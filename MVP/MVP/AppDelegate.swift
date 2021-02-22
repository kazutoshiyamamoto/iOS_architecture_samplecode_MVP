//
//  AppDelegate.swift
//  MVP
//
//  Created by home on 2020/06/25.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let searchUserViewController = UIStoryboard(name: "SearchUser", bundle: nil).instantiateInitialViewController() as! SearchUserViewController
        let navigationController = UINavigationController(rootViewController: searchUserViewController)

        let model = SearchUserModel()
        let presenter = SearchUserPresenter(view: searchUserViewController, model: model)
        searchUserViewController.inject(presenter: presenter)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

