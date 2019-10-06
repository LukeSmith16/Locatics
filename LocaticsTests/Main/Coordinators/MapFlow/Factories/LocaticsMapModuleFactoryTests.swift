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
        sut = LocaticsMapModuleFactory(storageManager: MockStorageManager(),
                                       locaticStorage: MockLocaticStorage())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_createLocaticsMainModule_locaticsViewModelIsNotNil() {
        let locaticsMapModule = sut.createLocaticsMapModule()

        XCTAssertNotNil(locaticsMapModule.locaticsMainViewModel)
    }

    func test_createLocaticsMainModule_addLocaticViewModelIsNotNil() {
        let locaticsMapModule = sut.createLocaticsMapModule()

        XCTAssertNotNil(locaticsMapModule.locaticsMainViewModel!.addLocaticViewModel)
    }

    func test_createLocaticsMainModule_locaticsMapViewModelIsNotNil() {
        let locaticsMapModule = sut.createLocaticsMapModule()

        XCTAssertNotNil(locaticsMapModule.locaticsMainViewModel!.locaticsMapViewModel)
    }
}
