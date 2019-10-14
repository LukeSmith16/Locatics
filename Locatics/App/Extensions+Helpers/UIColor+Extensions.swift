//
//  UIColor+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable identifier_name

import UIKit

enum ColorTheme: String {
    case Background = "background"

    case Interactable_Main = "interactable_main"
    case Interactable_Secondary = "interactable_secondary"
    case Interactable_Unselected = "interactable_unselected"
    case Title_Main = "title_main"
    case Title_Action = "title_action"
    case Title_Secondary = "title_secondary"
}

extension UIColor {
    convenience init(colorTheme: ColorTheme) {
        self.init(named: colorTheme.rawValue)!
    }
}
