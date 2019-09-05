//
//  AlertController.swift
//  Locatics
//
//  Created by Luke Smith on 05/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

struct AlertController {
    static func create(title: String,
                       message: String,
                       actionTitle: String = "Ok",
                       actionCallback: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: actionTitle, style: .default) { (_) in
            actionCallback?()
        }

        alertController.addAction(defaultAction)
        return alertController
    }
}
