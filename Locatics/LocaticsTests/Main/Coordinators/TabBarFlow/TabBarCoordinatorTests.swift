//
//  TabBarCoordinatorTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class TabBarCoordinatorTests: XCTestCase {

    private var mockTabBarController: MockTabBarController!
    private var mockCoordinatorFactory: MockCoordinatorFactory!

    var sut: TabBarCoordinator!

    override func setUp() {
        mockTabBarController = MockTabBarController()
        mockCoordinatorFactory = MockCoordinatorFactory()

        sut = TabBarCoordinator(tabBarController: mockTabBarController, coordinatorFactory: mockCoordinatorFactory)
    }

    override func tearDown() {
        mockTabBarController = nil
        mockCoordinatorFactory = nil

        sut = nil
        super.tearDown()
    }

    func test_startMapFlowClosure_startsRunMapFlow() {
        sut.start()

        mockTabBarController.triggerRunMapFlow()

        XCTAssertTrue(mockCoordinatorFactory.calledCreateMapFlow)

    }

    func test_startLocaticsFlowClosure_startsRunLocaticsFlow() {
        sut.start()

        mockTabBarController.triggerRunLocaticsFlow()

        XCTAssertTrue(mockCoordinatorFactory.calledCreateLocaticsFlow)
    }
}

private extension TabBarCoordinatorTests {
    class MockTabBarController: TabBarControllerInterface {
        var onMapFlowSelect: ((UINavigationController) -> Void)?
        var onLocaticsFlowSelect: ((UINavigationController) -> Void)?

        func triggerRunMapFlow() {
            onMapFlowSelect?(UINavigationController())
        }

        func triggerRunLocaticsFlow() {
            onLocaticsFlowSelect?(UINavigationController())
        }
    }

    class MockCoordinatorFactory: CoordinatorFactoryInterface {

        var calledCreateMapFlow = false
        var calledCreateLocaticsFlow = false

        func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput {
            return OnboardingCoordinator(root: root, factory: OnboardingModuleFactory())
        }

        func createMapFlow(root: UINavigationController) -> CoordinatorInterface {
            calledCreateMapFlow = true
            return LocaticsMapCoordinator()
        }

        func createLocaticsFlow(root: UINavigationController) -> CoordinatorInterface {
            calledCreateLocaticsFlow = true
            return LocaticsCoordinator()
        }

        func createMainFlow(root: TabBarControllerInterface) -> CoordinatorInterface {
            return TabBarCoordinator(tabBarController: root, coordinatorFactory: CoordinatorFactory())
        }
    }
}
