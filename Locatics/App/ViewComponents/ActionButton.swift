//
//  ActionButton.swift
//  Locatics
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

enum ActionButtonStyle {
    case save

    var textFont: UIFont {
        switch self {
        case .save:
            return Font.init(.installed(.HelveticaRegular), size: .standard(.h2)).instance
        }
    }

    var textColor: UIColor {
        switch self {
        case .save:
            return UIColor(colorTheme: .Background)
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .save:
            return UIColor(colorTheme: .Interactable_Main)
        }
    }
}

class ActionButton: UIButton {
    var style: ActionButtonStyle!
    var actionTitle: String!

    func setup(actionStyle: ActionButtonStyle, actionTitle: String) {
        self.style = actionStyle
        self.actionTitle = actionTitle

        setupTitle()
        setupColors()
        setupLayers()
    }
}

private extension ActionButton {
    func setupTitle() {
        setTitle(actionTitle, for: .normal)
        setTitleColor(style.textColor, for: .normal)

        guard let titleLabel = titleLabel else { return }
        titleLabel.font = style.textFont
    }

    func setupColors() {
        self.backgroundColor = style.backgroundColor
    }

    func setupLayers() {
        self.layer.cornerRadius = 25.0
    }
}
