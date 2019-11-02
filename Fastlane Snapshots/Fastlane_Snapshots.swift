//
//  Fastlane_Snapshots.swift
//  Fastlane Snapshots
//
//  Created by Luke Smith on 02/11/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

class FastlaneSnapshots: XCTestCase {

    override func setUp() {
        let app = XCUIApplication()
        setupSnapshot(app)

        app.launch()
    }

    override func tearDown() {}

    func test_snapshot() {
        
    }
}
