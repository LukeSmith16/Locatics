//
//  UINavigationItem+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func setTitle(title: String?, subtitle: String?) {
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

        let stackView = UIStackView(arrangedSubviews: [mainTitleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center

        let width = max(mainTitleLabel.frame.size.width, subtitleLabel.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)

        mainTitleLabel.sizeToFit()
        subtitleLabel.sizeToFit()

        self.titleView = stackView
    }
}
