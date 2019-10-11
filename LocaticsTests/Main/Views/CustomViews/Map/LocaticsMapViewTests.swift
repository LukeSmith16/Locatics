//
//  LocaticsMapViewTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import MapKit

@testable import Locatics
class LocaticsMapViewTests: XCTestCase {

    var sut: LocaticsMapView!

    private var mockLocaticsMapViewModel: MockLocaticsMapViewModel!

    override func setUp() {
        sut = LocaticsMapView(frame: CGRect.zero)

        mockLocaticsMapViewModel = MockLocaticsMapViewModel()
        sut.locaticsMapViewModel = mockLocaticsMapViewModel
    }

    override func tearDown() {
        mockLocaticsMapViewModel = nil
        sut = nil
        super.tearDown()
    }

    func test_delegate_isNotNil() {
        XCTAssertNotNil(sut.delegate)
    }

    func test_addLocaticMapRadiusCircle_isNil() {
        XCTAssertNil(sut.addLocaticMapRadiusCircle)
    }

    func test_addLocaticMapCircleRadius_isNil() {
        XCTAssertNil(sut.addLocaticMapCircleRadius)
    }

    func test_setupMapView_showsUserLocation() {
        XCTAssertTrue(sut.showsUserLocation)
    }

    func test_setupMapView_setsTintColorInteractableSecondary() {
        XCTAssertEqual(sut.tintColor,
                       UIColor(colorTheme: .Interactable_Secondary))
    }

    func test_zoomToUserLocation_updatesMapRegion() {
        let oldRegion = MKCoordinateRegion(center:
            CLLocationCoordinate2D(latitude: 10,
                                   longitude: 5),
                                           latitudinalMeters: 50,
                                           longitudinalMeters: 50)
        sut.setRegion(oldRegion, animated: true)

        sut.zoomToUserLocation(latMeters: 0.0, lonMeters: 0.0)

        let currentCenter = sut.centerCoordinate

        XCTAssertNotEqual(currentCenter.latitude,
                          oldRegion.center.latitude)
        XCTAssertNotEqual(currentCenter.longitude,
                          oldRegion.center.longitude)
    }

    func test_updatePinAnnotationRadius_addsCircleAnnotation() {
        sut.updatePinAnnotationRadius(toRadius: 50)

        XCTAssertNotNil(sut.addLocaticMapRadiusCircle)
        XCTAssertEqual(sut.addLocaticMapRadiusCircle!.radius,
                       50)

        XCTAssertEqual(sut.overlays.count, 1)
        XCTAssertTrue(sut.overlays.first! is MKCircle)
    }

    func test_updatePinAnnotationRadius_callsGetLocationPinCoordinate() {
        sut.updatePinAnnotationRadius(toRadius: 20)

        XCTAssertTrue(mockLocaticsMapViewModel.calledGetLocationPinCoordinate)

        XCTAssertEqual(sut.addLocaticMapRadiusCircle!.coordinate.latitude,
                       mockLocaticsMapViewModel.getLocationPinCoordinate().latitude)
        XCTAssertEqual(sut.addLocaticMapRadiusCircle!.coordinate.longitude,
                       mockLocaticsMapViewModel.getLocationPinCoordinate().longitude)
    }

    func test_addLocaticMapAnnotation_addsLocaticMarkerAnnotationView() {
        let locatic = MockLocatic()
        locatic.iconPath = "addLocaticButtonIcon"

        sut.addLocaticMapAnnotation(locatic)

        XCTAssertEqual(sut.annotations.count, 1)
    }

    func test_addLocaticMapAnnotation_addsLocaticMarkerAnnotationViewWithValues() {
        let locatic = MockLocatic()
        locatic.iconPath = "addLocaticButtonIcon"

        sut.addLocaticMapAnnotation(locatic)

        guard let pointAnnotation = sut.annotations.first as? MKPointAnnotation else {
            XCTFail("Annotation should be of type 'MKPointAnnotation'")
            return
        }

        XCTAssertEqual(pointAnnotation.coordinate.latitude,
                       locatic.latitude)
        XCTAssertEqual(pointAnnotation.coordinate.longitude,
                       locatic.longitude)
    }

    func test_removeLocaticMapAnnotation_removesAnnotationMatchingCoordinate() {
        let locatic = MockLocatic()
        sut.addLocaticMapAnnotation(locatic)

        let coordinate = Coordinate(latitude: locatic.latitude,
                                    longitude: locatic.longitude)
        sut.removeLocaticMapAnnotation(at: coordinate)

        XCTAssertEqual(sut.annotations.count, 0)
    }

    func test_mapViewRegionDidChange_callsSetupAddLocaticMapRadiusCircleIfNotNil() {
        sut.updatePinAnnotationRadius(toRadius: 20)

        let newRegionCoordinate = Coordinate(latitude: 15, longitude: 20)
        mockLocaticsMapViewModel.coordinate = newRegionCoordinate

        sut.mapView(sut, regionDidChangeAnimated: true)

        XCTAssertEqual(sut.addLocaticMapRadiusCircle!.coordinate.latitude,
                       newRegionCoordinate.latitude)
        XCTAssertEqual(sut.addLocaticMapRadiusCircle!.coordinate.longitude,
                       newRegionCoordinate.longitude)
    }

    func test_mapViewRegionDidChange_doesNothingIfMapRadiusCircleIsNil() {
        XCTAssertNil(sut.addLocaticMapRadiusCircle)

        sut.mapView(sut, regionDidChangeAnimated: true)

        XCTAssertNil(sut.addLocaticMapRadiusCircle)
    }

    func test_mapViewDidFinishRenderingMap_callsGoToUserRegion() {
        sut.mapViewDidFinishRenderingMap(sut, fullyRendered: true)

        XCTAssertTrue(mockLocaticsMapViewModel.calledGoToUserRegion)
    }

    func test_mapViewDidFinishRenderingMap_callsGoToUserRegionWithoutForce() {
        sut.mapViewDidFinishRenderingMap(sut, fullyRendered: true)

        XCTAssertFalse(mockLocaticsMapViewModel.passedGoToUserRegionForce!)
    }
}
