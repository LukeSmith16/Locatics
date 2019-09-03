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

    var sut: App!

    override func setUp() {
        sut = App()
    }

    override func tearDown() {
        sut = nil

        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        super.tearDown()
    }

    func test_windowIsNotNil() {
        XCTAssertNotNil(sut.window)
    }

    func test_startApplicationCoordinatorGetsCalledWhenAppStarts() {
        sut.start()

        XCTAssertNotNil(sut.applicationCoordinator)
    }

    func test_startCallsMainAppCoordinatorWithConfigForOnboardingFlow() {
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

//    func test_startCallsMainAppCoordinatorWithConfigForMainFlow() {
//        OnboardingManager.setOnboarding(true)
//
//        sut.start()
//
//        guard let rootController = sut.window.rootViewController,
//            let rootNavController = rootController as? UINavigationController else {
//                XCTFail("Could not extract root VC as UINavigationController type")
//                return
//        }
//
//        guard let firstViewController = rootNavController.viewControllers.first else {
//            XCTFail("Could not extract root VC from root nav controller")
//            return
//        }
//
//        XCTAssertTrue(firstViewController is OnboardingViewController)
//    }
}
