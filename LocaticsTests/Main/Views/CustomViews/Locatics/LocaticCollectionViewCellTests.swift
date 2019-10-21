//
//  LocaticCollectionViewCellTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticCollectionViewCellTests: XCTestCase {

    var sut: LocaticCollectionViewCell!

    override func setUp() {
        sut = LocaticCollectionViewCell()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
