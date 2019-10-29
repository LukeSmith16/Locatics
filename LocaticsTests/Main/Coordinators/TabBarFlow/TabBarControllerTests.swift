//
//  TabBarControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class TabBarControllerTests: XCTestCase {

    var sut: TabBarController!

    override func setUp() {
        sut = createTabBarController(initialIndex: 0)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_tabIndex_rawValues() {
        XCTAssertEqual(TabIndex.map.rawValue, 0)
        XCTAssertEqual(TabIndex.locatics.rawValue, 1)
    }

    func test_viewControllerCount_isTwo() {
        XCTAssertNotNil(sut.viewControllers)
        XCTAssertEqual(sut.viewControllers.count, 2)
    }

    func test_setupTabBar_configuresTabBar() {
        _ = sut.view

        XCTAssertTrue(sut.tabBar.lineAlignment == .top)
        XCTAssertTrue(sut.tabBar.tabBarStyle == .nonScrollable)

        XCTAssertEqual(sut.tabBar.getLineColor(for: .selected),
                       UIColor(colorTheme: .Interactable_Main))
        XCTAssertEqual(sut.tabBar.getTabItemColor(for: .selected)!,
                       UIColor(colorTheme: .Interactable_Main))
        XCTAssertEqual(sut.tabBar.getTabItemColor(for: .normal)!,
                       UIColor(colorTheme: .Interactable_Unselected))

        XCTAssertEqual(sut.tabBar.backgroundColor,
                       UIColor(colorTheme: .Background))
        XCTAssertEqual(sut.tabBar.dividerColor,
                       UIColor(colorTheme: .Background))
    }

    func test_setupGestures_disablesSwipe() {
        _ = sut.view

        XCTAssertFalse(sut.isSwipeEnabled)
    }

    func test_setupTabs_setsTabs() {
        let mapFlowExpectation = expectation(description: "Wait for onMapFlowSelect")
        sut.onMapFlowSelect = { (navController) in
            mapFlowExpectation.fulfill()
        }

        let locaticsFlowExpectation = expectation(description: "Wait for onLocaticsFlowSelect")
        sut.onLocaticsFlowSelect = { (navController) in
            locaticsFlowExpectation.fulfill()
        }

        _ = sut.view

        wait(for: [mapFlowExpectation, locaticsFlowExpectation], timeout: 3, enforceOrder: true)
    }

    func test_setupTabItemForMapFlow_setsTabItem() {
        _ = sut.view

        guard let mapNavController = sut.viewControllers.first as? NavigationViewController else {
            XCTFail("Should be of type 'NavigationViewController'")
            return
        }

        XCTAssertNotNil(mapNavController.tabItem.image(for: .normal))
        XCTAssertNotNil(mapNavController.tabItem.image(for: .selected))
    }

    func test_setupTabItemForLocaticsFlow_setsTabItem() {
        _ = sut.view

        guard let locaticsNavController = sut.viewControllers.last as? NavigationViewController else {
            XCTFail("Should be of type 'NavigationViewController'")
            return
        }

        XCTAssertNotNil(locaticsNavController.tabItem.image(for: .normal))
        XCTAssertNotNil(locaticsNavController.tabItem.image(for: .selected))
    }
}

private extension TabBarControllerTests {
    func createTabBarController(initialIndex: Int) -> TabBarController {
        return TabBarController(viewControllers: [NavigationViewController(),
                                                  NavigationViewController()],
                                selectedIndex: initialIndex)
    }
}
