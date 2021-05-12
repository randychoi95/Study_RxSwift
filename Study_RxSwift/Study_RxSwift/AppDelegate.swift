//
//  AppDelegate.swift
//  Study_RxSwift
//
//  Created by 최제환 on 2021/03/22.
//

import UIKit
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let navigator = Navigator()

    let account = TwitterAccount().default
    let list = (username: "icanzilb", slug: "RxSwift")
    let testing = NSClassFromString("XCTest") != nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let service = TaskService()
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let taskViewModel = TasksViewModel(taskService: service, coordinator: sceneCoordinator)
        let firstScene = Scene.tasks(taskViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        // Override point for customization after application launch.
//        if !testing {
//          let feedNavigation = window!.rootViewController! as! UINavigationController
//          navigator.show(segue: .listTimeline(account, list), sender: feedNavigation)
//        }
        return true
    }

}

