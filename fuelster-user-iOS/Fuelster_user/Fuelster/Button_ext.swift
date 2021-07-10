//
//  Button_ext.swift
//  Fuelster
//
//  Created by Kareem on 24/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit


extension UIButton
{
    func setUnderLineText() -> Void {
       
        let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedText = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        self.titleLabel?.attributedText = attributedText
    }
    
    func setUnderLineText(subString: String) -> Void {
        
     /*   let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedText = NSAttributedString(string: self.currentAttributedTitle!, attributes: attributes)
        
        self.titleLabel?.attributedText = attributedText
        
        let output = NSMutableAttributedString(attributedString: self.currentAttributedTitle!)
        let underlineRange = output.string.rangeOfString(subString)
        output.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleNone.rawValue, range: NSMakeRange(0, output.length))
        output.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: underlineRange)*/

    }
    func setTickAtRight() -> Void {
        self.setImage(UIImage.init(named: "DownArrow_small"), forState: .Normal)
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -self.frame.size.width + 30)
    }
}