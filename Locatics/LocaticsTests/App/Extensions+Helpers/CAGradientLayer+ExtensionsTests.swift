//
//  CAGradientLayer+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class CAGradientLayerExtensionsTests: XCTestCase {
    func test_themeFor_navigationBar() {
        let sizeForBounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        let gradient = CAGradientLayer.Theme.navigationBar(size: sizeForBounds)

        guard let colors = gradient.colors as? [CGColor] else {
            XCTFail("Gradient colors should contain array of CGColor type")
            return
        }

        XCTAssertEqual(gradient.bounds, sizeForBounds)
        XCTAssertEqual(colors, [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.yellow.cgColor])
        XCTAssertEqual(gradient.startPoint, CGPoint(x: 0, y: 0))
        XCTAssertEqual(gradient.endPoint, CGPoint(x: 1.0, y: 0.0))
    }
}
