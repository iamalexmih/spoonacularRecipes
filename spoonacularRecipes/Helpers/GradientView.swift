//
//  GradientView.swift
//  spoonacularRecipes
//
//  Created by Eduard Tokarev on 07.03.2023.
//

import UIKit

final class GradientView: UIView {
    private var gradientLayer = CAGradientLayer()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        gradientLayer.colors = [
            UIColor.label.withAlphaComponent(1.0).cgColor,
            UIColor.label.withAlphaComponent(0).cgColor
        ]

        self.layer.addSublayer(gradientLayer)
    }
}
