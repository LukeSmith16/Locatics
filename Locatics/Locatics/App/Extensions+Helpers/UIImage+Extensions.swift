//
//  UIImage+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

extension UIImage {
    struct ImageFrom {
        static func gradientLayer(_ gradientLayer: CAGradientLayer) -> UIImage {
            var gradientImage: UIImage?

            UIGraphicsBeginImageContext(gradientLayer.frame.size)
            guard let context = UIGraphicsGetCurrentContext() else {
                /// This error could get triggered from the CAGradientLayer size being nil/empty
                fatalError("The UIGraphicsContext could not be retrieved")
            }

            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(
                withCapInsets: UIEdgeInsets.zero,
                resizingMode: .stretch)

            UIGraphicsEndImageContext()

            return gradientImage!
        }
    }
}
