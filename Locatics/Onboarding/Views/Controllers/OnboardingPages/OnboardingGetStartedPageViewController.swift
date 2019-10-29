//
//  OnboardingGetStartedPageViewController.swift
//  Locatics
//
//  Created by Luke Smith on 04/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class OnboardingGetStartedPageViewController: UIViewController, OnboardingViewControllerDesignable {
    @IBOutlet weak var onboardingImageView: UIImageView!

    @IBOutlet weak var onboardingTitleLabel: UILabel!
    @IBOutlet weak var onboardingDetailLabel: UILabel!

    var onboardingNavigationViewModel: OnboardingNavigationViewModelInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    /// Not required as this is the last PageVC for onboarding
    func skipTapped(_ sender: Any) {}

    /// Not required as this is the last PageVC for onboarding
    func nextTapped(_ sender: Any) {}
}
