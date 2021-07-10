//
//  RBAImagePickerManager.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 24/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class RBAImagePickerManager: NSObject, UIActionSheetDelegate {
    
    var parentVC = Fuelster_BaseViewController()
    var imagePicker = UIImagePickerController()
    func setParent(parent:Fuelster_BaseViewController) -> Void {
        
        self.parentVC = parent
    }
    
    func showImagePicker() -> Void {
        self.imagePicker.delegate = self.parentVC
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            let imageOptions = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .ActionSheet)
            self.parentVC.presentViewController(imageOptions, animated: true, completion: nil)
            
            let albumAction = UIAlertAction (title: "Album", style: .Default, handler: { (action: UIAlertAction!) in
                self.imagePicker.sourceType = .PhotoLibrary
                self.parentVC.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
            
            let cameraAction = UIAlertAction (title: "Camera", style: .Default, handler: { (action: UIAlertAction!) in
                self.imagePicker.sourceType = .Camera
                self.parentVC.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction (title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
              
            })
            
            imageOptions.addAction(albumAction)
            imageOptions.addAction(cameraAction)
            imageOptions.addAction(cancelAction)
            
        } else {
            let imageOptions = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .ActionSheet)
            self.parentVC.presentViewController(imageOptions, animated: true, completion: nil)
            
            let albumAction = UIAlertAction (title: "Album", style: .Default, handler: { (action: UIAlertAction!) in
                self.imagePicker.sourceType = .PhotoLibrary
                self.parentVC.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction (title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                
            })
            
            imageOptions.addAction(albumAction)
            imageOptions.addAction(cancelAction)
        }
    }
    
    
    func showImageSelectionOptions() -> Void {
        
    }
    
    
    //MARK: UIActionsheetDelegate mathods
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        if buttonIndex == 0 {
            imagePicker.sourceType = .PhotoLibrary
            self.parentVC.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        else
        {
            self.imagePicker.sourceType = .Camera
            self.parentVC.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
    }
    
}
