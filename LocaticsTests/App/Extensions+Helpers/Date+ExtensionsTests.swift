//
//  Date+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 27/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class DateExtensionsTests: XCTestCase {
    func test_startOfWeek_returnsBeginningOfWeek() {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!

        XCTAssertEqual(Date().startOfWeek,
                       gregorian.date(byAdding: .day, value: -6, to: sunday)!)
    }

}
