//
//  View_ext.swift
//  DrillLogs
//
//  Created by Sandeep Kumar Rachha on 23/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

import UIKit

extension UIView {
    
    
    func initHudView(hudMode:MBProgressHUDMode, message:String!) -> Void
    {
        self.userInteractionEnabled = false
        var load : MBProgressHUD = MBProgressHUD()
        load = MBProgressHUD.showHUDAddedTo(self, animated: true)
        load.mode = MBProgressHUDMode.Indeterminate
        load.label.text = message
    }
    
    
    func hideHudView() -> Void
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.userInteractionEnabled = true
            MBProgressHUD.hideHUDForView(self, animated: true)
        }
    }
    
    
    func callContactPerson(number:String) -> Void
    {
        let phoneUrl = "tel://\(number)"
        let urlStr : NSString = phoneUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url:NSURL = NSURL(string: urlStr as String)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    func showImagePreview(sourceImage: UIImage) -> Void
    {
        if let preview = NSBundle.mainBundle().loadNibNamed("ImagePreview", owner: self, options: nil).first as? ImagePreview
        {
            preview.frame = self.frame
            preview.centerImagePreview.layer.cornerRadius = 15
            preview.centerImagePreview.layer.masksToBounds = true
             preview.centerImagePreview.contentMode = UIViewContentMode.ScaleAspectFit
            preview.centerImagePreview.image = sourceImage
            self.addSubview(preview)
            self.bringSubviewToFront(preview)
        }

    }
    func showImagePreview(sourceImage: UIImage, infoText: String) -> Void
     {
        if let preview = NSBundle.mainBundle().loadNibNamed("ImagePreview", owner: self, options: nil).first as? ImagePreview
        {
            preview.frame = self.frame
            preview.centerImagePreview.layer.cornerRadius = 15
            preview.centerImagePreview.layer.masksToBounds = true
            preview.centerImagePreview.contentMode = UIViewContentMode.ScaleAspectFit
            preview.centerImagePreview.image = sourceImage
            self.addSubview(preview)
            self.bringSubviewToFront(preview)
            preview.infoLabel.text = infoText
            preview.infoLabel.hidden = false
        }
    }
    
    func showImagePreviewWithURL(imageURL: NSURL, infoText: String) -> Void
    {
        if let preview = NSBundle.mainBundle().loadNibNamed("ImagePreview", owner: self, options: nil).first as? ImagePreview
        {
            preview.frame = self.frame
            preview.centerImagePreview.layer.cornerRadius = 15
            preview.centerImagePreview.layer.masksToBounds = true
            preview.centerImagePreview.contentMode = UIViewContentMode.ScaleAspectFit
            preview.centerImagePreview.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "Car_Orange")!)
            self.addSubview(preview)
            self.bringSubviewToFront(preview)
            
            preview.infoLabel.text = infoText
            preview.infoLabel.hidden = false
            
        }
        
    }
    
    func applyPrimaryTheme() -> Void {
        self.layer.cornerRadius = 13.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.appTheamColor().CGColor
    }
    func removePrimaryTheme() -> Void {
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 0.0
    }
    
    
    func applyScecondaryBackGroundGradient() -> CAGradientLayer {
        
      //  let gradient : CAGradientLayer = self.createGradientlayer(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor, secondColor: UIColor.init(red: 226.0/255.0, green: 229.0/255.0, blue: 236.0/255.0, alpha: 1.0).CGColor)
        
        let gradient : CAGradientLayer = self.createGradientlayer(UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor, secondColor: UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor)

        self.layer.insertSublayer(gradient, atIndex: 0)
        self.applyPrimaryShadow()
        
        return gradient
    }
    
    
    func applyPrimaryBackGroundGradient() -> Void {
        
        self.layer.insertSublayer(self.createGradientlayer(UIColor.init(red: 41.0/255.0, green: 184.0/255.0, blue: 214.0/255.0, alpha: 1.0).CGColor, secondColor: UIColor.init(red: 48.0/255.0, green: 99.0/255.0, blue: 200.0/255.0, alpha: 1.0).CGColor), atIndex: 0)
    }
    
    
    func applyHorizantalPrimaryBackGroundGradient() -> Void {
        self.layer.insertSublayer(self.createHorizantalGradientlayer(UIColor.init(red: 41.0/255.0, green: 184.0/255.0, blue: 214.0/255.0, alpha: 1.0).CGColor, secondColor: UIColor.init(red: 48.0/255.0, green: 99.0/255.0, blue: 200.0/255.0, alpha: 1.0).CGColor), atIndex: 0)
    }
    
    
    func applyPrimaryShadow() -> Void
    {
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = 4;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowRadius = 6;
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = UIColor.appLightFontColor().CGColor
    }
    
    func resetPrimaryShadow() -> Void
    {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 0;
        self.layer.shadowOpacity = 0;
    }
    
    func applyPlainStyle() -> Void {
       
        self.layer.masksToBounds = false;
        self.layer.cornerRadius = 20;
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1.0
    }
    
    
    func createGradientlayer(firstColor:CGColor,secondColor:CGColor) -> CAGradientLayer {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [firstColor, secondColor]

        return gradient
    }
    
    
    func createHorizantalGradientlayer(firstColor:CGColor,secondColor:CGColor) -> CAGradientLayer {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [firstColor, secondColor]
        gradient.startPoint = CGPointMake(0,0.5)
        gradient.endPoint = CGPointMake(1,0.5)
        
        return gradient
    }
    
    
    func createSliderGradient() -> UIImage {
        
        let sliderGradient = self.createGradientlayer(UIColor.init(red: 251.0/255.0, green: 143.0/255.0, blue: 80.0/255.0, alpha: 1.0).CGColor, secondColor: UIColor.init(red: 29.0/255.0, green: 96.0/255.0, blue: 200.0/255.0, alpha: 1.0).CGColor)
        sliderGradient.startPoint = CGPointMake(0.0, 0.5)
        sliderGradient.endPoint = CGPointMake(1.0, 0.5)

        UIGraphicsBeginImageContextWithOptions(sliderGradient.frame.size, sliderGradient.opaque, 0.0);
        sliderGradient.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        image.resizableImageWithCapInsets(UIEdgeInsetsZero)

        return image
    }
    
}