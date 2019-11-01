//
//  Calendar+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 27/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class CalendarExtensionsTests: XCTestCase {
    func test_isDateInThisWeekReturnsTrue_whenDateIsThisWeek() {
        let today = Date()
        XCTAssertTrue(Calendar.current.isDateInThisWeek(today))
    }

    func test_isDateInThisWeekReturnsFalse_whenDateIsNotInThisWeek() {
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        XCTAssertFalse(Calendar.current.isDateInThisWeek(nextWeek))
    }
}
