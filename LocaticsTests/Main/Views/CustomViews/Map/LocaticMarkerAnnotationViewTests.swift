//
//  LocaticMarkerAnnotationViewTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import MapKit

@testable import Locatics
class LocaticMarkerAnnotationViewTests: XCTestCase {

    var sut: LocaticMarkerAnnotationView!

    override func setUp() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = MockLocation().coordinate

        sut = LocaticMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_settingAnnotation_triggersConfigure() {
        XCTAssertTrue(sut.collisionMode == .circle)
        XCTAssertEqual(sut.clusteringIdentifier, "LocaticMarkerAnnotationView")
    }

}