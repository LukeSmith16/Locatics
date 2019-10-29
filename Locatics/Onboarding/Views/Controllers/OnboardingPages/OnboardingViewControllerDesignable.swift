//
//  OnboardingDesignable.swift
//  Locatics
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol OnboardingViewControllerDesignable: UIViewController {
    var onboardingImageView: UIImageView! {get}
    var onboardingTitleLabel: UILabel! {get}
    var onboardingDetailLabel: UILabel! {get}

    var onboardingNavigationViewModel: OnboardingNavigationViewModelInterface? {get}

    func skipTapped(_ sender: Any)
    func nextTapped(_ sender: Any)
}

extension OnboardingViewControllerDesignable {
    func setupViews() {
        setupOnboardingImageView()
        setupOnboardingTitleLabel()
        setupOnboardingDetailLabel()
    }

    func setupOnboardingImageView() {
        self.onboardingImageView.clipsToBounds = false
        self.onboardingImageView.layer.shadowColor = UIColor.black.cgColor
        self.onboardingImageView.layer.shadowOpacity = 0.20
        self.onboardingImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func setupOnboardingTitleLabel() {
        self.onboardingTitleLabel.addCharacterSpacing()
    }

    func setupOnboardingDetailLabel() {
        self.onboardingDetailLabel.addCharacterSpacing()
        self.onboardingDetailLabel.textColor = UIColor(colorTheme: .Title_Action).withAlphaComponent(0.85)
    }
}
