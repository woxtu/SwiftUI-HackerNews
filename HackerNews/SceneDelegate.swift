//
//  SceneDelegate.swift
//  HackerNews
//
//  Created by woxtu on 2019/06/08.
//  Copyright (c) 2019 woxtu. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: ContentView())
        self.window = window
        window.makeKeyAndVisible()
    }
}
