//
//  UINavigationBar+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class UINavigationBarExtensionsTests: XCTestCase {
    func test_navigationBar_defaultAppearance() {
        let sut = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        sut.setupDefaultNavigationBarAppearance()

        XCTAssertNotNil(sut.backgroundImage(for: .default))
    }
}
