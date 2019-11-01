//
//  UIFont+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable identifier_name

import UIKit

struct Font {
    enum FontType {
        case installed(FontName)
    }

    enum FontName: String {
        case HelveticaRegular = "Helvetica"
        case HelveticaBold = "Helvetica-Bold"
    }

    enum FontSize {
        case standard(StandardSize)
        case custom(Double)

        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }

    enum StandardSize: Double {
        case h1 = 18.0
        case h2 = 14.0
        case h3 = 12.0
        case h4 = 10.0
    }

    var type: FontType
    var size: FontSize

    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    var instance: UIFont {
        var instanceFont: UIFont!

        switch type {
        case .installed(let fontName):
            let font = UIFont(name: fontName.rawValue, size: CGFloat(size.value))!
            instanceFont = font
        }
        return instanceFont
    }
}
