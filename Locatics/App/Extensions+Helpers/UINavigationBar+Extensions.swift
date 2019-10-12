//
//  UINavigationBar+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setupDefaultNavigationBarAppearance() {
        self.shadowImage = UIImage()
        self.isTranslucent = true

        let navigationBarBounds = self.bounds
        let gradientLayer = CAGradientLayer.Theme.navigationBar(size: navigationBarBounds)
        let gradientImage = UIImage.ImageFrom.gradientLayer(gradientLayer)

        self.setBackgroundImage(gradientImage, for: .default)
    }
}
