//
//  LocaticsMapViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import MapKit

@testable import Locatics
class LocaticsMapViewControllerTests: XCTestCase {

    private var mockLocaticsMapViewModel: MockLocaticsViewModel!
    var sut: LocaticsMapViewController!

    override func setUp() {
        mockLocaticsMapViewModel = MockLocaticsViewModel()

        sut = LocaticsMapViewController()
        sut.locaticsMapViewModel = mockLocaticsMapViewModel

        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        mockLocaticsMapViewModel = nil
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

    func test_locationMarkerPin_isNotNil() {
        XCTAssertNotNil(sut.locationMarkerPin)
    }

    func test_addLocaticCardView_isNotNil() {
        XCTAssertNotNil(sut.addLocaticCardView)
    }

    func test_locationMarkerPin_isHiddenByDefault() {
        XCTAssertTrue(sut.locationMarkerPin.isHidden)
    }

    func test_setupNavigationTitle_setsMainTitleAndSubtitleFromViewModel() {
        XCTAssertTrue(mockLocaticsMapViewModel.calledGetMainTitle)
        XCTAssertTrue(mockLocaticsMapViewModel.calledGetSubtitle)

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

    func test_mapViewDelegate_isNotNil() {
        XCTAssertNotNil(sut.mapView.delegate)
    }

    func test_locaticsMapViewModelViewDelegate_isNotNil() {
        XCTAssertNotNil(sut.locaticsMapViewModel?.viewDelegate)
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

    func test_setupMapView_setsMapToShowUserLocation() {
        XCTAssertTrue(sut.mapView.showsUserLocation)
    }

    func test_setupMapView_callsGetUserRegion() {
        XCTAssertTrue(mockLocaticsMapViewModel.calledGetUserRegion)
    }

    func test_updateMapRegion_setsMapViewRegion() {
        let mockMapView = MockMapView(frame: CGRect.zero)
        sut.mapView = mockMapView

        let location = Coordinate(latitude: 25, longitude: 25)
        sut.updateMapRegion(location: location, latMeters: 15, lonMeters: 15)

        XCTAssertEqual(mockMapView.coordinateRegion.center.latitude, location.latitude)
        XCTAssertEqual(mockMapView.coordinateRegion.center.longitude, location.longitude)

        XCTAssertTrue(mockMapView.calledSetRegion)
    }

    func test_setupMapView_setsMapViewTintColorToInteractableSecondary() {
        XCTAssertEqual(sut.mapView.tintColor, UIColor(colorTheme: .Interactable_Secondary))
    }

    func test_addLocaticTapped_callsViewModelAddLocaticWasTapped() {
        sut.addLocaticTapped(UIButton())

        XCTAssertTrue(mockLocaticsMapViewModel.calledAddLocaticWasTapped)
    }

    func test_zoomToUserLocation_updatesMapRegion() {
        let oldRegion = MKCoordinateRegion(center:
            CLLocationCoordinate2D(latitude: 10,
                                   longitude: 5),
                                           latitudinalMeters: 50,
                                           longitudinalMeters: 50)
        sut.mapView.setRegion(oldRegion, animated: true)

        sut.zoomToUserLocation(latMeters: 0.0, lonMeters: 0.0)

        let currentCenter = sut.mapView.centerCoordinate

        XCTAssertNotEqual(currentCenter.latitude,
                          oldRegion.center.latitude)
        XCTAssertNotEqual(currentCenter.longitude,
                          oldRegion.center.longitude)
    }

    func test_showAddLocaticCardView_showsCardView() {
        sut.showAddLocaticCardView()

        XCTAssertFalse(sut.addLocaticCardView.isHidden)
    }

    func test_showAddLocaticCardView_addsViewToHierarchy() {
        sut.showAddLocaticCardView()
        XCTAssertNotNil(sut.view.subviews.first(where: { (view) -> Bool in
            return view is AddLocaticCardView
        }))
    }

    func test_showLocationMarkerPin_addsMarkerPinToCenterOfMap() {
        sut.showLocationMarkerPin()

        XCTAssertFalse(sut.locationMarkerPin.isHidden)
    }

    func test_getCenterMapCoordinate_returnsMapCenterCoordinate() {
        let centerCoordinate = sut.getCenterMapCoordinate()

        XCTAssertEqual(sut.mapView.centerCoordinate.latitude,
                       centerCoordinate.latitude)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude,
                       centerCoordinate.longitude)
    }

    func test_closeAddLocaticView_hidesAddLocaticCardView() {
        sut.closeAddLocaticCardView()

        XCTAssertTrue(sut.addLocaticCardView.isHidden)
    }

    func test_hideTabBar_unhidesTabBarWhenFalse() {
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([sut], animated: true)

        sut.hideTabBar(false)

        XCTAssertFalse(sut.tabBarController!.tabBar.isHidden)
    }
}

private extension LocaticsMapViewControllerTests {
    class MockLocaticsViewModel: LocaticsMapViewModelInterface {
        var calledGetMainTitle = false
        var calledGetSubtitle = false
        var calledGetUserRegion = false
        var calledAddLocaticWasTapped = false

        weak var viewDelegate: LocaticsMapViewModelViewDelegate?
        var addLocaticViewModel: AddLocaticViewModelInterface? {
            return AddLocaticViewModel(locaticStorage: MockLocaticStorage())
        }

        func getMainTitle() -> String {
            calledGetMainTitle = true
            return "The main title"
        }

        func getSubtitle() -> String {
            calledGetSubtitle = true
            return "the subtitle"
        }

        func getUserRegion() {
            calledGetUserRegion = true
        }

        func addLocaticWasTapped() {
            calledAddLocaticWasTapped = true
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

    class MockMapView: MKMapView {
        var calledSetRegion = false

        var coordinateRegion: MKCoordinateRegion!

        override func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
            self.calledSetRegion = true
            self.coordinateRegion = region
        }
    }
}
