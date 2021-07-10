//
//  ImagePreview.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 29/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class ImagePreview: UIView {

    @IBOutlet weak var centerImagePreview: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBAction func closeImageAction(sender: AnyObject) {
        self.superview?.alpha = 1.0
        self.removeFromSuperview()
    }
}
