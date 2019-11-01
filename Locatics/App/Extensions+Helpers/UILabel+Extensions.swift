//
//  UILabel+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 0.65) {
      if let labelText = text, labelText.count > 0 {
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: kernValue,
                                      range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
      }
    }
}
