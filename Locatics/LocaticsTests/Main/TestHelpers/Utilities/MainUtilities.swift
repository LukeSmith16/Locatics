//
//  MainUtilities.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@testable import Locatics

func createTabBarController() -> TabBarController {
    let mainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
    let tabBarController = mainStoryboard.instantiateInitialViewController() as? TabBarController

    return tabBarController!
}
