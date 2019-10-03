//
//  UIViewController+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 03/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

extension UIViewController {
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let yPosition = frame.origin.y + (frame.size.height * factor)

                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x,
                                                                 y: yPosition,
                                                                 width: frame.width,
                                                                 height: frame.height)
                })

                return
            }
        }

        self.tabBarController?.tabBar.isHidden = hidden
    }
}
