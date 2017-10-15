//
//  AppDelegate.swift
//  octoburrs
//
//  Created by Jabari Bell on 10/15/17.
//  Copyright © 2017 theowl. All rights reserved.
//

import UIKit
import Octokit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    
    let token = "e5e1263d0febf38385a334250e4afbf2dae51587"
    let config = TokenConfiguration(token)
    
    Octokit(config).me() { response in
      switch response {
      case .success(let user):
        print(user.login)
      
      case .failure(let error):
        print(error)
      }
    }
    
    let profileViewController = ProfileViewController()
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = profileViewController
    self.window?.makeKeyAndVisible()
    
    return true
  }
}

