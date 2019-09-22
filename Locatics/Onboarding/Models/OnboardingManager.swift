//
//  OnboardingManager.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

struct OnboardingManager {
    private static let identifier = "OnboardingCompleted"
    private static let userDefaults = UserDefaults.standard

    static func setOnboarding(_ value: Bool) {
        userDefaults.set(value, forKey: identifier)
    }

    static func hasOnboarded() -> Bool {
        return userDefaults.bool(forKey: identifier)
    }
}
