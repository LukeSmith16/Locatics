//
//  SliderControlTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class SliderControlTests: XCTestCase {
    func test_sliderControl_distanceValues() {
        let sut = SliderControl()
        sut.setup(sliderStyle: .distance, minValue: 0, maxValue: 10)

        XCTAssertTrue(sut.style == SliderControlStyle.distance)
        XCTAssertEqual(sut.minimumValue, 0)
        XCTAssertEqual(sut.maximumValue, 10)
        XCTAssertEqual(sut.minimumTrackTintColor, UIColor(colorTheme: .Title_Main))
        XCTAssertEqual(sut.maximumTrackTintColor, UIColor(colorTheme: .Title_Secondary))
    }
}
