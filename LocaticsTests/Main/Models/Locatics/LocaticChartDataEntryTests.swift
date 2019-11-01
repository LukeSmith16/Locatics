//
//  LocaticChartDataEntryTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticChartDataEntryTests: XCTestCase {
    func test_values_passedOnInit() {
        let entryDate = Date()
        let sut = LocaticChartDataEntry(entryDate: entryDate, entryValue: 10.0)

        XCTAssertEqual(sut.entryDate, entryDate)
        XCTAssertEqual(sut.entryValue!, 10.0)
    }
}
