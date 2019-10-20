//
//  DateFormatterManagerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 09/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class DateFormatterManagerTests: XCTestCase {

    func test_hoursMinutes_returnsHoursMinutesDateFormatterFormattedString() {
        let date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        let expectedDateString = dateFormatter.string(from: date)

        XCTAssertEqual(expectedDateString, DateFormatterManager.hoursMinutes(from: date))
    }
}
