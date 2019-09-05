//
//  AppDelegate.swift
//  Locatics
//
//  Created by Luke Smith on 31/08/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable line_length

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var app: AppInterface? {
        didSet {
            app?.start()
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if CommandLine.arguments.contains("--uitesting") {
            resetState()
        }

        self.window = UIWindow()
        self.app = App(window: window!)
        return true
    }

    private func resetState() {
        let bundleID = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
}
