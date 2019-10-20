//
//  AppTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class AppTests: XCTestCase {

    var window: UIWindow!
    var sut: App!

    override func setUp() {
        window = UIWindow()
        sut = App(window: window)
    }

    override func tearDown() {
        window = nil
        sut = nil

        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        super.tearDown()
    }

    func test_window_isNotNil() {
        XCTAssertNotNil(sut.window)
    }

    func test_window_usesInitWindow() {
        XCTAssertEqual(sut.window, window)
    }

    func test_start_setsUpStorageManager() {
        sut.start()
    }

    func test_startApplicationCoordinatorGetsCalled_whenAppStarts() {
        sut.start()

        XCTAssertNotNil(sut.applicationCoordinator)
    }

    func test_startCallsMainAppCoordinatorWithConfig_forOnboardingFlow() {
        OnboardingManager.setOnboarding(false)

        sut.start()

        guard let rootController = sut.window.rootViewController,
              let rootNavController = rootController as? UINavigationController else {
            XCTFail("Could not extract root VC as UINavigationController type")
            return
        }

        guard let firstViewController = rootNavController.viewControllers.first else {
            XCTFail("Could not extract root VC from root nav controller")
            return
        }

        XCTAssertTrue(firstViewController is OnboardingViewController)
    }

    func test_startCallsMainAppCoordinatorWithConfig_forMainFlow() {
        OnboardingManager.setOnboarding(true)

        sut.start()

        guard let rootController = sut.window.rootViewController,
            let rootTabController = rootController as? TabBarController else {
                XCTFail("Could not extract root VC as TabBarController type")
                return
        }

        guard rootTabController.viewControllers.last is NavigationViewController else {
            XCTFail("Could not extract root VC from root nav controller")
            return
        }
    }
}
