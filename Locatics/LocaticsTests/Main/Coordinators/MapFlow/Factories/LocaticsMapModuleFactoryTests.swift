//
//  LocaticsMapModuleFactoryTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsMapModuleFactoryTests: XCTestCase {

    var sut: LocaticsMapModuleFactory!

    override func setUp() {
        sut = LocaticsMapModuleFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
