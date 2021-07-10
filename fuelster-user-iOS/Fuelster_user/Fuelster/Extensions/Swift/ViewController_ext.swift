//
//  ViewController_ext.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 21/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit
import Flurry_iOS_SDK

extension UIViewController
{
    func storyBoard() -> UIStoryboard {
        
        let storyboard = UIStoryboard.init(name:"Main" , bundle: nil)
        
        return storyboard
    }
    
    func  getViewControllerWithIdentifier(identifier:String) -> UIViewController {
        
        let sb = self.storyBoard()
        let vc = sb.instantiateViewControllerWithIdentifier(identifier)
        return vc
    }
    
    func pushViewControllerWithIdentifier(identifier:String) -> Void
    {
        let vc = self.getViewControllerWithIdentifier(identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Multiple Storyboards
    func storyBoardWithName(name:String) -> UIStoryboard {
        
        let storyboard = UIStoryboard.init(name:name , bundle: nil)
        
        return storyboard
    }
    
    func  getViewControllerWithIdentifierAndStoryBoard(identifier:String, storyBoard:String) -> UIViewController {
        
        let sb = self.storyBoardWithName(storyBoard)
        let vc = sb.instantiateViewControllerWithIdentifier(identifier)
        return vc
    }
    func pushViewControllerWithIdentifierAndStoryBoard(identifier:String, storyBoard:String) -> Void
    {
        let vc = self.getViewControllerWithIdentifierAndStoryBoard(identifier,storyBoard: storyBoard)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func applyTintColorForLeftBarButtonWith(color:UIColor)  {
        self.navigationItem.leftBarButtonItem?.tintColor = color
    }
    
    func applyTintColorForRightBarButtonWith(color:UIColor)  {
        self.navigationItem.rightBarButtonItem?.tintColor = color
    }
    
    func deviceWidth() -> CGFloat {
        
        let  width  = UIScreen.mainScreen().bounds.size.width
        
        return width
        
    }
    
    func deviceHeight() -> CGFloat {
        
        let  height  = UIScreen.mainScreen().bounds.size.height
        
        return height
    }
    
    
    func deviceSize() -> CGSize {
        
        let  size  = UIScreen.mainScreen().bounds.size
        
        return size
    }
    
    
    func getStringFromSelectedDate(date:NSDate) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, YYYY h:mm:ss a"//"dd-MM-YYYY hh:mm a"
        let dateStr = formatter.stringFromDate(date)
        
        return dateStr;
    }
    
    
    func presentAlertController(alertControllerToPresent: O1AlertController, animated flag: Bool, completion: () -> Void) {
       
        if (alertControllerToPresent is UIAlertController) {
            self.presentViewController((alertControllerToPresent as! UIViewController), animated: flag, completion: completion)
        }
        else {
            alertControllerToPresent.presentAlertAnimated(flag, by: self, completion: completion)
            
        }
    }
    
    //MARK:--- Flurry Events
    func logFlurryEvent(event:String) -> Void
    {
        let email : String =  UserModel.sharedInstance.userInfo!["email"] as! String
       // Flurry.logEvent(email + " : " + event)
         Flurry.logEvent( event)
    }
    
    func logFlurryEvent(event:String, email:String) -> Void
    {
       // Flurry.logEvent(email + " " + event)
        Flurry.logEvent( event)
    }
    
    func saveImageData(image: UIImage)
    {
        //let data : NSData = UIImagePNGRepresentation(image)!
        let data : NSData = UIImageJPEGRepresentation(image, 0.1)!

        UIImageJPEGRepresentation(image, 0.1)!
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "userPic")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getProfilePic() -> UIImage! {
        
        var data: NSData? = nil
        data  = NSUserDefaults.standardUserDefaults().objectForKey("userPic") as? NSData
     
        if (data != nil)
        {
            let image = UIImage.init(data: data!)
            return image
        }
        return nil
    }
    
 
    func loadProfilePic(button: UIButton, userModel:UserModel) -> Void
    {
        let profileURL = userModel.userInfo![kUserProfilePicture] as? String
        
        if  (profileURL != nil)
        {
            
            let image = RBAKeyChainWrapper.sharedInstance.getProfilePic()
            if image != nil {
                button.setImage(image, forState: .Normal)
            }
            else
            {
                button.setImage(UIImage.init(named: PROFILRPIC_PLACEHOLDER_IMAGE), forState: .Normal)
            }
            button.sd_setImageWithURL(NSURL.init(string: profileURL!), forState: .Normal,placeholderImage:button.imageForState(.Normal) , completed: { (image :UIImage!, error : NSError!, cacheType, url:NSURL!) in
                if(image != nil)
                {
                    RBAKeyChainWrapper.sharedInstance.saveUserProfilePicInKeychain(image)
                }
            })
        }

    }
    
    func loadProfilePicOnImageView(imageView: UIImageView, userModel:UserModel) -> Void
    {
        let profileURL = userModel.userInfo![kUserProfilePicture] as? String
        
        if  (profileURL != nil)
        {
            
            let image = RBAKeyChainWrapper.sharedInstance.getProfilePic()
            if image != nil {
               imageView.image = image
            }
            else
            {
                imageView.image = UIImage.init(named: PROFILRPIC_PLACEHOLDER_IMAGE)
            }
            
            imageView.sd_setImageWithURL(NSURL.init(string: profileURL!), placeholderImage: imageView.image, completed: { (image :UIImage!, error : NSError!, cacheType, url:NSURL!) in
                if(image != nil)
                {
                    RBAKeyChainWrapper.sharedInstance.saveUserProfilePicInKeychain(image)
                }
            })
            
        }
        
    }
    
    //MARK:---- Navigation back
    func setBackBarButtonToView() -> Void
    {
        let backItem = UIBarButtonItem.init(image: UIImage.init(named: "BackArrow"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backToPopView))
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    func backToPopView()  {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addNoDataMessageView(message : String) -> NoSearchResult! {
       
        if let preview = NSBundle.mainBundle().loadNibNamed("NoSearchResult", owner: self, options: nil).first as? NoSearchResult
        {
            preview.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
            self.view.addSubview(preview)
            self.view.bringSubviewToFront(preview)
            preview.hidden = true
            preview.center = self.view.center
            preview.showMessage(message)
            return preview
        }
        return nil
    }
}


