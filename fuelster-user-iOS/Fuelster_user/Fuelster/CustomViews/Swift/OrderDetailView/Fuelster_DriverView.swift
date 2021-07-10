//
//  Fuelster_DriverView.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 13/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_DriverView: UIView {

    private var gradient : CAGradientLayer = CAGradientLayer()

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.gradient = self.applyScecondaryBackGroundGradient()
        
    }

    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        self.gradient.frame = self.bounds
    }


}
