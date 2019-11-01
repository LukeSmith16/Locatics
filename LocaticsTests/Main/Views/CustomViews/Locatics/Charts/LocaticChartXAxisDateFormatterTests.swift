//
//  LocaticChartXAxisDateFormatterTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticChartXAxisDateFormatterTests: XCTestCase {
    func test_stringForValue_formatsValueUsingDateFormatter() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"

        let sut = LocaticChartXAxisDateFormatter(dateFormatter: dateFormatter)

        let stringForValue = sut.stringForValue(0, axis: nil)
        XCTAssertEqual(stringForValue, "THU")
    }
}
