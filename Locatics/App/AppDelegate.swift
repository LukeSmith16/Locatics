//
//  AppDelegate.swift
//  Locatics
//
//  Created by Luke Smith on 31/08/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable line_length

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var app: AppInterface? {
        didSet {
            app?.start()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupIQKeyboardManager()

        self.window = UIWindow()
        self.app = App(window: window!)

        return true
    }

    private func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }
}
