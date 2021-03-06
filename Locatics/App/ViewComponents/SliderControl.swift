//
//  SliderControl.swift
//  Locatics
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

enum SliderControlStyle {
    case distance

    var minTrackColor: UIColor {
        switch self {
        case .distance:
            return UIColor(colorTheme: .Title_Main)
        }
    }

    var maxTackColor: UIColor {
        switch self {
        case .distance:
            return UIColor(colorTheme: .Title_Secondary)
        }
    }
}

class SliderControl: UISlider {
    var style: SliderControlStyle?

    func setup(sliderStyle: SliderControlStyle, minValue: Float, maxValue: Float) {
        self.style = sliderStyle
        self.minimumValue = minValue
        self.maximumValue = maxValue

        setupColors()
    }
}

private extension SliderControl {
    func setupColors() {
        self.minimumTrackTintColor = style?.minTrackColor
        self.maximumTrackTintColor = style?.maxTackColor
    }
}
