//
//  LocaticClusterMarkerViewTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import MapKit

@testable import Locatics
class LocaticClusterMarkerViewTests: XCTestCase {

    var sut: LocaticClusterMarkerView!

    override func setUp() {
        let annotation = MKPointAnnotation()
        let clusterAnnotation = MKClusterAnnotation(memberAnnotations: [annotation])

        sut = LocaticClusterMarkerView(annotation: clusterAnnotation, reuseIdentifier: nil)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_initWithCoder_throwsFatalError() {
        expectFatalError(expectedMessage: "init(coder:) has not been implemented") {
            self.sut = LocaticClusterMarkerView.init(coder: NSCoder())
        }
    }

    func test_displayPriority_isRequired() {
        XCTAssertTrue(sut.displayPriority == .required)
    }

    func test_collisionMode_isCircle() {
        XCTAssertTrue(sut.collisionMode == .circle)
    }

    func test_annotation_isNotNil() {
        XCTAssertNotNil(sut.annotation)
    }

    func test_image_isNotNil() {
        XCTAssertNotNil(sut.image)
    }
}
