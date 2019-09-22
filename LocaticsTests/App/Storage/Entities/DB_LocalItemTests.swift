//
//  DB_LocalItemTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 22/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class DBLocalItemTests: XCTestCase {
    func test_DB_LocalItemMappingKey_values() {
        XCTAssertEqual(DB_LocalItemMappingKey.identity.rawValue, "identity")
    }
}
