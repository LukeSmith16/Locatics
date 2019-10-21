//
//  TabBarController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Material

protocol TabBarControllerInterface: class {
    var onMapFlowSelect: ((UINavigationController) -> Void)? { get set }
    var onLocaticsFlowSelect: ((UINavigationController) -> Void)? { get set }
}

enum TabIndex: Int {
    case map, locatics
}

final class TabBarController: TabsController, TabBarControllerInterface {
    var onMapFlowSelect: ((UINavigationController) -> Void)?
    var onLocaticsFlowSelect: ((UINavigationController) -> Void)?

    override func prepare() {
        super.prepare()
        setupTabBar()
        setupGestures()
        setupTabs()
    }
}

private extension TabBarController {
    func setupTabBar() {
        tabBar.lineAlignment = .top
        tabBar.tabBarStyle = .nonScrollable

        tabBar.setLineColor(UIColor(colorTheme: .Interactable_Main), for: .selected)
        tabBar.setTabItemsColor(UIColor(colorTheme: .Interactable_Main), for: .selected)
        tabBar.setTabItemsColor(UIColor(colorTheme: .Interactable_Unselected), for: .normal)

        tabBar.backgroundColor = UIColor(colorTheme: .Background)
        tabBar.dividerColor = UIColor(colorTheme: .Background)
    }

    func setupGestures() {
        self.isSwipeEnabled = false
    }

    func setupTabs() {
        guard let mapNavController = viewControllers.first as? NavigationViewController,
            let locaticsNavController = viewControllers.last as? NavigationViewController else {
                fatalError("Could not get NavControllers")
        }

        onMapFlowSelect?(mapNavController)
        onLocaticsFlowSelect?(locaticsNavController)
    }
}
