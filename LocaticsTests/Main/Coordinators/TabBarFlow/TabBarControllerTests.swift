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

    private var mockTabBarControllerClosures: MockTabBarControllerClosure!
    var sut: TabBarController!

    override func setUp() {
        mockTabBarControllerClosures = MockTabBarControllerClosure()

        sut = createTabBarController(initialIndex: 0)

        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        mockTabBarControllerClosures = nil
        super.tearDown()
    }

    func test_tabIndex_rawValues() {
        XCTAssertEqual(TabIndex.map.rawValue, 0)
        XCTAssertEqual(TabIndex.locatics.rawValue, 1)
    }

    func test_delegate_isNotNil() {
        XCTAssertNotNil(sut.delegate)
    }

    func test_viewControllerCount_isTwo() {
        XCTAssertNotNil(sut.viewControllers)
        XCTAssertEqual(sut.viewControllers.count, 2)
    }

    func test_setupTabBar_configuresTabBar() {
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
        XCTAssertFalse(sut.isSwipeEnabled)
    }

    func test_initialTabSelected_isMapFlow() {
        sut = createTabBarController(initialIndex: 0)

        mockTabBarControllerClosures.addMapSelectClosure(sut: sut)
        mockTabBarControllerClosures.addLocaticsSelectClosure(sut: sut)

        _ = sut.view

        XCTAssertTrue(mockTabBarControllerClosures.calledOnMapFlowSelect)
        XCTAssertFalse(mockTabBarControllerClosures.calledOnLocaticsFlowSelect)

        XCTAssertNotNil(mockTabBarControllerClosures.calledController)
    }
}

private extension TabBarControllerTests {
    func createTabBarController(initialIndex: Int) -> TabBarController {
        return TabBarController(viewControllers: [NavigationViewController(),
                                                  NavigationViewController()],
                                selectedIndex: initialIndex)
    }
}
