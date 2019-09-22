//
//  UINavigationItem+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol NavigationTitleViewInterface: class {
    func setNewTitle(_ title: String?)
    func setNewSubtitle(_ subtitle: String?)
}

class NavigationTitleView: UIStackView, NavigationTitleViewInterface {

    private var mainTitleLabel: UILabel!
    private var subtitleLabel: UILabel!

    convenience init(mainTitleLabel: UILabel, subtitleLabel: UILabel) {
        self.init()
        self.mainTitleLabel = mainTitleLabel
        self.subtitleLabel = subtitleLabel
        self.insertArrangedSubview(mainTitleLabel, at: 0)
        self.insertArrangedSubview(subtitleLabel, at: 1)
    }

    func setNewTitle(_ title: String?) {
        self.mainTitleLabel.text = title
    }

    func setNewSubtitle(_ subtitle: String?) {
        self.subtitleLabel.text = subtitle
    }
}

extension UINavigationItem {
    func setupTitleView(title: String?, subtitle: String?) -> NavigationTitleViewInterface {
        let mainTitleLabel = UILabel()
        mainTitleLabel.text = title
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.font = Font.init(.installed(.HelveticaRegular), size: .standard(.h1)).instance
        mainTitleLabel.sizeToFit()

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = Font.init(.installed(.HelveticaRegular), size: .standard(.h2)).instance
        subtitleLabel.textAlignment = .center
        subtitleLabel.sizeToFit()

        let navigationTitleView = NavigationTitleView(mainTitleLabel: mainTitleLabel, subtitleLabel: subtitleLabel)
        navigationTitleView.distribution = .equalCentering
        navigationTitleView.axis = .vertical
        navigationTitleView.alignment = .center

        let width = max(mainTitleLabel.frame.size.width, subtitleLabel.frame.size.width)
        navigationTitleView.frame = CGRect(x: 0, y: 0, width: width, height: 35)

        mainTitleLabel.sizeToFit()
        subtitleLabel.sizeToFit()

        self.titleView = navigationTitleView

        return navigationTitleView
    }
}