//
//  AddLocaticCardView.swift
//  Locatics
//
//  Created by Luke Smith on 14/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class AddLocaticCardView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locaticNameTextField: UITextField!
    @IBOutlet var radiusSlider: UISlider!
    @IBOutlet var addNewLocaticButton: UIButton!

    var addLocaticViewModel: AddLocaticViewModelInterface? {
        didSet {
            awakeFromNib()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupRadiusSlider()
        setupAddNewLocaticButton()

        setupShadow()
        setupCorners()
    }

    @objc func radiusSliderChanged(_ sender: Any) {

    }

    @objc func addLocaticTapped(_ sender: Any) {

    }
}

private extension AddLocaticCardView {
    func setupRadiusSlider() {
        let sliderControl = SliderControl(sliderStyle: .distance,
                                          minValue: 0,
                                          maxValue: 100)
        sliderControl.addTarget(self, action: #selector(radiusSliderChanged(_:)), for: .valueChanged)
        self.radiusSlider = sliderControl
    }

    func setupAddNewLocaticButton() {
        let actionButton = ActionButton(actionStyle: .save,
                                        actionTitle: "Add new Locatic")
        actionButton.addTarget(self, action: #selector(addLocaticTapped(_:)), for: .touchUpInside)
        self.addNewLocaticButton = actionButton
    }

    func setupShadow() {
        self.layer.shadowRadius = 4.0
    }

    func setupCorners() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 25.0
    }
}
