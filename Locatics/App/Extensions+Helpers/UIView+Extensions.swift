//
//  UIView+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        guard let nib = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as? T else {
            fatalError("Could not load nib with same name as owner")
        }

        return nib
    }
}
