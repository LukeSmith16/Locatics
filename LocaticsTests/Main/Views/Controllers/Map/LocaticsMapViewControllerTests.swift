//
//  LocaticsMapViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreData

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

    func test_setupAddLocaticButton_addsShadowToAddLocaticButton() {
        let addLocaticButtonLayer = sut.addLocaticButton.layer

        XCTAssertEqual(addLocaticButtonLayer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(addLocaticButtonLayer.shadowOpacity, 0.20)
        XCTAssertEqual(addLocaticButtonLayer.shadowOffset, CGSize(width: 0, height: 5))
    }

    func test_setupLocationMarkerPin_shadowIsConfigured() {
        XCTAssertFalse(sut.locationMarkerPin.clipsToBounds)

        let locationMarkerPinLayer = sut.locationMarkerPin.layer
        XCTAssertEqual(locationMarkerPinLayer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(locationMarkerPinLayer.shadowOpacity, 0.15)
        XCTAssertEqual(locationMarkerPinLayer.shadowOffset, CGSize(width: 0, height: 5))
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

    func test_addLocaticTapped_callsClearValuesOnAddLocaticCardView() {
        let mockAddLocaticCardView = MockAddLocaticCardView(frame: CGRect.zero)
        sut.addLocaticCardView = mockAddLocaticCardView

        sut.addLocaticTapped(UIButton())

        XCTAssertTrue(mockAddLocaticCardView.calledClearValues)
    }

    func test_closeLocaticCardViewTapped_callsViewModelCloseLocaticWasTapped() {
        sut.closeLocaticCardViewTapped(UIButton())

        XCTAssertTrue(mockLocaticsMainViewModel.calledCloseLocaticCardViewWasTapped)
    }

    func test_closeLocaticCardViewTapped_callsClearValuesOnAddLocaticCardView() {
        let mockAddLocaticCardView = MockAddLocaticCardView(frame: CGRect.zero)
        sut.addLocaticCardView = mockAddLocaticCardView

        sut.closeLocaticCardViewTapped(UIButton())

        XCTAssertTrue(mockAddLocaticCardView.calledClearValues)
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

    func test_shouldHideAddLocaticViews_removeAddLocaticRadiusAnnotation() {
        sut.shouldHideAddLocaticViews(true)

        XCTAssertTrue(mockMapView.calledRemoveAddLocaticRadiusAnnotation)
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
}
