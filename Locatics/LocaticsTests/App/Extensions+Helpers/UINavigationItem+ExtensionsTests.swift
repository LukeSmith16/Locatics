//
//  UINavigationItem+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class UINavigationItemExtensionsTests: XCTestCase {
    func test_setTitle_setsTitleViewWithTitleAndSubTitle() {
        let sut = UINavigationItem()
        sut.setTitle(title: "Main title", subtitle: "Subtitle")

        let mainTitleView = sut.titleView!.subviews.first { (view) -> Bool in
            if let label = view as? UILabel {
                return label.text == "Main title"
            }

            return false
        }

        guard let title = mainTitleView, let titleLabel = title as? UILabel else {
            XCTFail("Couldn't find a main title")
            return
        }

        XCTAssertEqual(titleLabel.text, "Main title")
        XCTAssertEqual(titleLabel.font.familyName, Font.FontName.HelveticaRegular.rawValue)
        XCTAssertEqual(titleLabel.font.pointSize, CGFloat(Font.FontSize.standard(.h1).value))
        XCTAssertEqual(titleLabel.textAlignment, NSTextAlignment.center)

        let subtitleView = sut.titleView!.subviews.first { (view) -> Bool in
            if let label = view as? UILabel {
                return label.text == "Subtitle"
            }

            return false
        }

        guard let subtitle = subtitleView, let subtitleLabel = subtitle as? UILabel else {
            XCTFail("Couldn't find a subtitle")
            return
        }

        XCTAssertEqual(subtitleLabel.text, "Subtitle")
        XCTAssertEqual(subtitleLabel.font.familyName, Font.FontName.HelveticaRegular.rawValue)
        XCTAssertTrue(subtitleLabel.font.pointSize == CGFloat(Font.FontSize.standard(.h2).value))
        XCTAssertEqual(subtitleLabel.textAlignment, NSTextAlignment.center)
    }
}
