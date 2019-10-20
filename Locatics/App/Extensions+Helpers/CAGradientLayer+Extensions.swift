//
//  CAGradientLayer+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    struct Theme {
        static func navigationBar(size: CGRect) -> CAGradientLayer {
            let gradient = CAGradientLayer()
            gradient.bounds = size
            gradient.colors = [UIColor(colorTheme: .Background).cgColor,
                               UIColor(colorTheme: .Background).withAlphaComponent(0.75).cgColor,
                               UIColor(colorTheme: .Background).withAlphaComponent(0.00).cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)

            return gradient
        }
    }
}
