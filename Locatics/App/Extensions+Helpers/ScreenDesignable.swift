//
//  ScreenDesignable.swift
//  Locatics
//
//  Created by Luke Smith on 20/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

struct ScreenDesignable {
    static let cornerRadius: CGFloat = {
        let sceenWidth = UIScreen.main.bounds.width
        return (sceenWidth / 18.5).rounded(.down)
    }()

    static let alertHeight: CGFloat = {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight / 2.2
    }()
}
