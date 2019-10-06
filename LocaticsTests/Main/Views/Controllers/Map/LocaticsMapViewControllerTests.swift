//
//  LocaticsMapViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsMapViewControllerTests: XCTestCase {

    var sut: LocaticsMapViewController!

    private var mockMapView: MockMapView!
    private var mockLocaticsMainViewModel: MockLocaticsMainViewModel!

    override func setUp() {
        mockMapView = MockMapView(frame: CGRect.zero)
        mockLocaticsMainViewModel = MockLocaticsMainViewModel()

        sut = LocaticsMapViewController()
        sut.locaticsMainViewModel = mockLocaticsMainViewModel

        _ = sut.view

        sut.mapView = mockMapView
    }

    override func tearDown() {
        sut = nil
        mockMapView = nil
        mockLocaticsMainViewModel = nil
        super.tearDown()
    }

    func test_view_isNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_mapView_isNotNil() {
        XCTAssertNotNil(sut.mapView)
    }

    func test_addLocaticButton_isNotNil() {
        XCTAssertNotNil(sut.addLocaticButton)
    }

    func test_closeLocaticCardViewButton_isNotNil() {
        XCTAssertNotNil(sut.closeLocaticCardViewButton)
    }

    func test_locationMarkerPin_isNotNil() {
        XCTAssertNotNil(sut.locationMarkerPin)
    }

    func test_addLocaticCardView_isNotNil() {
        XCTAssertNotNil(sut.addLocaticCardView)
    }

    func test_locationMarkerPin_isHiddenByDefault() {
        XCTAssertTrue(sut.locationMarkerPin.isHidden)
    }

    func test_closeLocaticCardViewButton_isHiddenByDefault() {
        XCTAssertTrue(sut.closeLocaticCardViewButton.isHidden)
    }

    func test_viewDidAppear_callsGoToUserRegion() {
        sut.viewDidAppear(true)

        XCTAssertTrue(mockMapView.calledGoToUserRegion)
    }

    func test_setupNavigationTitle_setsMainTitleAndSubtitleFromViewModel() {
        XCTAssertTrue(mockLocaticsMainViewModel.calledGetMainTitle)
        XCTAssertTrue(mockLocaticsMainViewModel.calledGetSubtitle)

        guard let titleView = sut.navigationItem.titleView else {
            XCTFail("TitleView on navigation item is nil")
            return
        }

        let mainTitleView = titleView.subviews.first { (view) -> Bool in
            if let label = view as? UILabel {
                return label.text == "The main title"
            }

            return false
        }

        guard mainTitleView != nil else {
            XCTFail("Couldn't find a main title")
            return
        }

        let subtitleView = sut.navigationItem.titleView!.subviews.first { (view) -> Bool in
            if let label = view as? UILabel {
                return label.text == "the subtitle"
            }

            return false
        }

        guard subtitleView != nil else {
            XCTFail("Couldn't find a subtitle")
            return
        }
    }

    func test_setupAddLocaticCardView_setsAddLocaticViewModel() {
        XCTAssertNotNil(sut.addLocaticCardView!.addLocaticViewModel)
    }

    func test_locaticsMainViewModelViewDelegate_isNotNil() {
        XCTAssertNotNil(sut.locaticsMainViewModel?.viewDelegate)
    }

    func test_locaticsMainViewModelAddLocaticViewDelegate_isNotNil() {
        XCTAssertNotNil(sut.locaticsMainViewModel?.addLocaticViewDelegate)
    }

    func test_setNavigationTitle_callsSetTitleWithValue() {
        let mockNavigationTitleView = MockNavigationTitleView()
        sut.navigationTitleView = mockNavigationTitleView

        sut.setNavigationTitle("Test")

        XCTAssertTrue(mockNavigationTitleView.calledSetNewTitle)
        XCTAssertTrue(mockNavigationTitleView.calledSetNewSubtitle)

        XCTAssertEqual(mockNavigationTitleView.setNewTitleValue, "Test")
        XCTAssertEqual(mockNavigationTitleView.setNewSubTitleValue, "the subtitle")
    }

    func test_addLocaticTapped_callsViewModelAddLocaticWasTapped() {
        sut.addLocaticTapped(UIButton())

        XCTAssertTrue(mockLocaticsMainViewModel.calledAddLocaticWasTapped)
    }

    func test_closeLocaticCardViewTapped_callsViewModelCloseLocaticWasTapped() {
        sut.closeLocaticCardViewTapped(UIButton())

        XCTAssertTrue(mockLocaticsMainViewModel.calledCloseLocaticCardViewWasTapped)
    }

    func test_shouldHideAddLocaticViewsTrue_hidesAddLocaticViews() {
        sut.shouldHideAddLocaticViews(true)

        XCTAssertTrue(sut.locationMarkerPin.isHidden)
        XCTAssertTrue(sut.addLocaticCardView.isHidden)
        XCTAssertTrue(sut.closeLocaticCardViewButton.isHidden)
    }

    func test_shouldHideAddLocaticViewsFalse_showsAddLocaticViews() {
        sut.shouldHideAddLocaticViews(false)

        XCTAssertFalse(sut.locationMarkerPin.isHidden)
        XCTAssertFalse(sut.addLocaticCardView.isHidden)
        XCTAssertFalse(sut.closeLocaticCardViewButton.isHidden)
    }

    func test_getLocationPinCoordinate_returnsPinCenterCoordinate() {
        let centerCoordinate = sut.getPinCurrentLocationCoordinate()

        let pinCenter = sut.locationMarkerPin.center
        let pinLocationOnMapView = sut.mapView.convert(pinCenter,
                                                       toCoordinateFrom: sut.mapView)

        XCTAssertEqual(pinLocationOnMapView.latitude,
                       centerCoordinate.latitude)
        XCTAssertEqual(pinLocationOnMapView.longitude,
                       centerCoordinate.longitude)
    }

    func test_hideTabBar_unhidesTabBarWhenFalse() {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([sut], animated: true)

        sut.hideTabBar(false)

        XCTAssertFalse(sut.tabBarController!.tabBar.isHidden)
    }
}

private extension LocaticsMapViewControllerTests {
    class MockLocaticsMainViewModel: LocaticsMainViewModelInterface {

        var calledGetMainTitle = false
        var calledGetSubtitle = false
        var calledAddLocaticWasTapped = false
        var calledCloseLocaticCardViewWasTapped = false

        weak var viewDelegate: LocaticsMainViewModelViewDelegate?
        weak var addLocaticViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate?

        var addLocaticViewModel: AddLocaticViewModelInterface? {
            return AddLocaticViewModel(locaticStorage: MockLocaticStorage())
        }

        var locaticsMapViewModel: LocaticsMapViewModelInterface? {
            return LocaticsMapViewModel()
        }

        func getMainTitle() -> String {
            calledGetMainTitle = true
            return "The main title"
        }

        func getSubtitle() -> String {
            calledGetSubtitle = true
            return "the subtitle"
        }

        func addLocaticWasTapped() {
            calledAddLocaticWasTapped = true
        }

        func closeLocaticCardViewWasTapped() {
            calledCloseLocaticCardViewWasTapped = true
        }
    }

    class MockNavigationTitleView: NavigationTitleViewInterface {
        var calledSetNewTitle = false
        var calledSetNewSubtitle = false

        var setNewTitleValue = ""
        var setNewSubTitleValue = ""

        func setNewTitle(_ title: String?) {
            calledSetNewTitle = true
            setNewTitleValue = title ?? ""
        }

        func setNewSubtitle(_ subtitle: String?) {
            calledSetNewSubtitle = true
            setNewSubTitleValue = subtitle ?? ""
        }
    }

    class MockMapView: LocaticsMapView {
        var calledGoToUserRegion = false

        override func goToUserRegion() {
            calledGoToUserRegion = true
        }
    }
}
