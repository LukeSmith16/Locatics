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

        sut = createSUT()

        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        mockTabBarControllerClosures = nil
        super.tearDown()
    }

    private func createSUT() -> TabBarController {
        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        sut = mainStoryboard.instantiateInitialViewController() as? TabBarController

        return sut
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
        XCTAssertEqual(sut.viewControllers!.count, 2)
    }

    func test_initialTabSelected_isMapFlow() {
        sut = createSUT()

        mockTabBarControllerClosures.addMapSelectClosure(sut: sut)
        mockTabBarControllerClosures.addLocaticsSelectClosure(sut: sut)

        _ = sut.view

        XCTAssertTrue(mockTabBarControllerClosures.calledOnMapFlowSelect)
        XCTAssertFalse(mockTabBarControllerClosures.calledOnLocaticsFlowSelect)

        XCTAssertNotNil(mockTabBarControllerClosures.calledController)
    }

    func test_onMapTabSelect_callsMapClosureWithNavController() {
        sut = createSUT()
        sut.selectedIndex = 1

        mockTabBarControllerClosures.addMapSelectClosure(sut: sut)
        _ = sut.view

        sut.selectedIndex = 0

        sut.tabBarController(sut, didSelect: UINavigationController())

        XCTAssertTrue(mockTabBarControllerClosures.calledOnMapFlowSelect)
        XCTAssertNotNil(mockTabBarControllerClosures.calledController)
    }

    func test_didSelectViewController_returnsIfVCIsNotNavController() {
        sut = createSUT()

        mockTabBarControllerClosures.addMapSelectClosure(sut: sut)

        sut.tabBarController(sut, didSelect: UIViewController())

        XCTAssertNil(mockTabBarControllerClosures.calledController)
    }

    func test_didSelectViewController_callsMapClosureWithNavController() {
        sut = createSUT()
        sut.selectedIndex = 1

        mockTabBarControllerClosures.addMapSelectClosure(sut: sut)

        sut.selectedIndex = 0

        sut.tabBarController(sut, didSelect: UINavigationController())

        XCTAssertTrue(mockTabBarControllerClosures.calledOnMapFlowSelect)
        XCTAssertNotNil(mockTabBarControllerClosures.calledController)
    }

    func test_onLocaticsTabSelect_callsLocaticsClosureWithNavController() {
        sut = createSUT()
        sut.selectedIndex = 0

        mockTabBarControllerClosures.addLocaticsSelectClosure(sut: sut)
        _ = sut.view

        sut.selectedIndex = 1

        sut.tabBarController(sut, didSelect: UINavigationController())

        XCTAssertTrue(mockTabBarControllerClosures.calledOnLocaticsFlowSelect)
        XCTAssertNotNil(mockTabBarControllerClosures.calledController)
    }
}

private extension TabBarControllerTests {
    class MockTabBarControllerClosure {
        var calledOnMapFlowSelect = false
        var calledOnLocaticsFlowSelect = false

        var calledController: UINavigationController?

        func addMapSelectClosure(sut: TabBarController) {
            sut.onMapFlowSelect = { [weak self] navController in
                guard let `self` = self else { return }

                self.calledOnMapFlowSelect = true
                self.calledController = navController
            }
        }

        func addLocaticsSelectClosure(sut: TabBarController) {
            sut.onLocaticsFlowSelect = { [weak self] navController in
                guard let `self` = self else { return }

                self.calledOnLocaticsFlowSelect = true
                self.calledController = navController
            }
        }
    }
}
