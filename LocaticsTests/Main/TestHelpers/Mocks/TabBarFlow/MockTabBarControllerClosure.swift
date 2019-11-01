//
//  MockTabBarControllerClosure.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@testable import Locatics
class MockTabBarControllerClosure {

    var calledOnMapFlowSelect = false
    var calledOnLocaticsFlowSelect = false

    var calledControllers: [UINavigationController] = []

    func addMapSelectClosure(sut: TabBarController) {
        sut.onMapFlowSelect = { [weak self] navController in
            guard let `self` = self else { return }

            self.calledOnMapFlowSelect = true
            self.calledControllers.append(navController)
        }
    }

    func addLocaticsSelectClosure(sut: TabBarController) {
        sut.onLocaticsFlowSelect = { [weak self] navController in
            guard let `self` = self else { return }

            self.calledOnLocaticsFlowSelect = true
            self.calledControllers.append(navController)
        }
    }
}
