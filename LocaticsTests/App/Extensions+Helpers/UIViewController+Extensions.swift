//
//  UIViewController+Extensions.swift
//  LocaticsTests
//
//  Created by Luke Smith on 03/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class UIViewControllerExtensions: XCTestCase {
    func test_setTabBarHidden() {
        let sut = UIViewController()

        let tabBar = UITabBarController()
        tabBar.setViewControllers([sut], animated: false)

        XCTAssertNotNil(sut.tabBarController?.tabBar)
        XCTAssertFalse(sut.tabBarController!.tabBar.isHidden)

        sut.setTabBarHidden(true, animated: true, duration: 0.5)
    }
}
