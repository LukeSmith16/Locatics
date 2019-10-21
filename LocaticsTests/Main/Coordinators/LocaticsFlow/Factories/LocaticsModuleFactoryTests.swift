//
//  LocaticsModuleFactoryTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsModuleFactoryTests: XCTestCase {

    var sut: LocaticsModuleFactory!

    override func setUp() {
        sut = LocaticsModuleFactory(storageManager: MockStorageManager(),
                                    locaticStorage: MockLocaticStorage())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_createLocaticsListModule_returnsLocaticsListViewController_withLocaticsViewModel() {
        let createLocaticsListModule = sut.createLocaticsListModule()

        XCTAssertNotNil(createLocaticsListModule.locaticsViewModel)
    }
}
