//
//  DateUtilityTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 27/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class DateUtilityTests: XCTestCase {
    func test_differenceInHours_returnsDifferenceConvertedToHours() {
        let now = Date()
        let twoHours = Date().addingTimeInterval(7200)

        XCTAssertEqual(DateUtility().differenceInHours(from: now,
                                                       to: twoHours),
                       2)
    }
}
