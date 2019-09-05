//
//  AlertControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 05/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class AlertControllerTests: XCTestCase {

    func test_createAlert_returnsAlertConfigured() {
        let alert = AlertController.create(title: "A Title", message: "A message")

        XCTAssertEqual(alert.title, "A Title")
        XCTAssertEqual(alert.message, "A message")
        XCTAssertEqual(alert.actions.count, 1)
        XCTAssertEqual(alert.actions.first!.title, "Ok")
    }

}
