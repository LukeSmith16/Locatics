//
//  CoreDataStackTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class CoreDataStackTests: XCTestCase {
    func test_createApplicationPersistenceContainer_createsAndReturnsPC() {
        createApplicationPersistenceContainer { (persistentContainer) in
            XCTAssertEqual(persistentContainer.name, "LocaticsDatabase")
        }
    }
}
