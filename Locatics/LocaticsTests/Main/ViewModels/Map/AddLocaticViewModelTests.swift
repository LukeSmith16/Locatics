//
//  AddLocaticViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class AddLocaticViewModelTests: XCTestCase {

    var sut: AddLocaticViewModel!

    override func setUp() {
        sut = AddLocaticViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
