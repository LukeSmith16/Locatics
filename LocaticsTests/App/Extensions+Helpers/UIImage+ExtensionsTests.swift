//
//  UIImage+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class UIImageExtensionsTests: XCTestCase {
    func test_imageFrom_gradientLayer() {
        let gradientLayer = CAGradientLayer.Theme.navigationBar(size: CGRect(x: 0, y: 0, width: 50, height: 50))
        let gradientImage = UIImage.ImageFrom.gradientLayer(gradientLayer)

        XCTAssertTrue(gradientImage.resizingMode == .stretch)
        XCTAssertEqual(gradientImage.capInsets, UIEdgeInsets.zero)
    }

    func test_imageFrom_gradientLayerThrowsFatalErrorWhenGradientSizeIsNil() {
        let gradientLayer = CAGradientLayer.Theme.navigationBar(size: CGRect.zero)
        let expected = "The UIGraphicsContext could not be retrieved, make sure the gradient layer has a size set"

        expectFatalError(expectedMessage: expected) {
            _ = UIImage.ImageFrom.gradientLayer(gradientLayer)
        }
    }
}
