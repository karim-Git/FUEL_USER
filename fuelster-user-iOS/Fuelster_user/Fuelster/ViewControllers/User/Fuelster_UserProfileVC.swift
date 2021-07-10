//
//  Fuelster_UserProfileVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import SDWebImage

class Fuelster_UserProfileVC:  UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    let vehicleModel = VehicleModel.sharedInstance
    let cardsModel = CardsModel.sharedInstance
    let loginAlertVC = RBAAlertController()
    let userModel =  UserModel.sharedInstance
    let alertVC = RBAAlertController()
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var userNameTF: RBATextField!
    @IBOutlet weak var firstNameTF: RBATextField!
    @IBOutlet weak var lastNameTF: RBATextField!
    
    @IBOutlet weak var emailTF: RBATextField!
    @IBOutlet weak var phoneTF: REFormattedNumberField!

    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var profileView: UIView!
    
    var isEdit = false
    var isImagePicked = false
    var sliderVC : UIViewController!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        sliderVC = self.slideMenuController()
        sliderVC.navigationItem.rightBarButtonItem = nil
        self.phoneTF.format = "(XXX) XXX-XXXX"
        resetButton.applyPrimaryShadow()
        self.emailTF.adjustsFontSizeToFitWidth = true
        self.phoneTF.adjustsFontSizeToFitWidth = true

        self.emailTF.addLeftView(EMAIL_SMALL_IMAGE)
        self.emailTF.leftView?.alpha = 0.7
        self.phoneTF.addLeftView(CALL_IMAGE)
        self.profileView.applyPrimaryShadow()
        
        self.tableView.tableFooterView = self.emptyViewToHideUnNecessaryRows()
        self.tableView.separatorColor = UIColor.clearColor()
        self.updateUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        profilePicButton.layer.cornerRadius = profilePicButton.frame.size.width/2
        profilePicButton.layer.masksToBounds = true
        
        var sliderVC : UIViewController!
        sliderVC = self.slideMenuController()
        sliderVC.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle =  MENU_PROFILE
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        sliderVC.navigationItem.titleView = titleLabel

        if (self.isEdit) // Selecting Image From Camera or Gallery
        {
            if SDImageCache.sharedImageCache().imageFromMemoryCacheForKey(kUserProfilePicture) != nil
            {
                self.profilePicButton .setImage(SDImageCache.sharedImageCache().imageFromMemoryCacheForKey(kUserProfilePicture), forState: .Normal)
            }
        }

        self.view.initHudView(.Indeterminate, message:kHudLoadingMessage)

            userModel.requestForUserProfileDetails(
                { (result) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.hideHudView()
                        self.updateUI()
                    }
                }) { (error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.hideHudView()
                        //Handle Error
                    }

            }
    }
    
    @IBAction func editImageButtonAction(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
      
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            let imageOptions = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .ActionSheet)
            self.presentViewController(imageOptions, animated: true, completion: nil)
            
            let albumAction = UIAlertAction (title: "Album", style: .Default, handler: { (action: UIAlertAction!) in
                self.isImagePicked = true
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            })
            
            let cameraAction = UIAlertAction (title: "Camera", style: .Default, handler: { (action: UIAlertAction!) in
                self.isImagePicked = true
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction (title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                
            })
            
            imageOptions.addAction(albumAction)
            imageOptions.addAction(cameraAction)
            imageOptions.addAction(cancelAction)

        }
        else {
            self.isImagePicked = true
            let imageOptions = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .ActionSheet)
            self.presentViewController(imageOptions, animated: true, completion: nil)

            let albumAction = UIAlertAction (title: "Album", style: .Default, handler: { (action: UIAlertAction!) in
                self.isImagePicked = true
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            })
            
            let cancelAction = UIAlertAction (title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                
            })
            
            imageOptions.addAction(albumAction)
            imageOptions.addAction(cancelAction)
        }
    }
    
    
    func validateUpdatedData() -> Bool
    {
        if (firstNameTF.text!.characters.count == 0 || lastNameTF.text!.characters.count == 0 || phoneTF.text!.characters.count == 0)
        {
           // loginAlertVC.presentAlertWithMessage(kSignUpAllDetailsMessage, controller: self)
            
            loginAlertVC.presentAlertWithTitleAndMessage (kSignUpAllDetailsTitle, message:kSignUpAllDetailsMessage, controller: self)

            
            return false
        }
        return true
    }
    @IBAction func editButtonAction(sender: AnyObject) {
        self.isEdit = !self.isEdit
        let editButton = sender as! UIButton
        if self.isEdit == true {
            editButton.setImage(UIImage.init(named: SAVE_IMAGE), forState: .Normal)
            self.enableControls(self.isEdit)
        }
        else {
            
            // Validating fields
            if validateUpdatedData() == false {
                
                return
            }
            var profileBody: [NSObject:AnyObject]
            if self.profilePicButton.currentImage != UIImage.init(named: CAMERA_IMAGE) {
                profileBody = userModel.requestForProfileUpdateBody([self.firstNameTF.text!,self.lastNameTF.text!,self.emailTF.text!,self.phoneTF.text!,UIImageJPEGRepresentation(self.profilePicButton.currentImage!, 0.1)!])
            }
            else {
                profileBody = userModel.requestForProfileUpdateBody([firstNameTF.text!,lastNameTF.text!,emailTF.text!,phoneTF.text!,""])
            }
                
            if self.lastNameTF.text?.characters.count<=0 || self.firstNameTF.text?.characters.count<=0
            {
                self.loginAlertVC.presentAlertWithTitleAndMessage (kUserNameValidationMaxLengthTitle, message: kUserNameValidationMaxLengthMessage, controller: self)
                return
            }
            
            if (phoneTF.text?.characters.count < 14)
            {
                 self.loginAlertVC.presentAlertWithTitleAndMessage (kPhoneNumberValidationTitle, message:kPhoneNumberProfileValidationMessage, controller: self)
                return
            }
            
            self.view.initHudView(.Indeterminate, message:"")
            userModel.requestForUserProfileUpdate(profileBody, success: { (result) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.hideHudView()
                    self.enableControls(self.isEdit)
                    self.updateUI()
//                    self.loginAlertVC.presentAlertWithTitleAndMessage (MENU_PROFILE, message:kUserProfileUpdatedMessage, controller: self)
                    editButton.setImage(UIImage.init(named: EDIT_SMALL_IMAGE), forState: .Normal)
                }

                }, failureBlock: { (error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view.hideHudView()
                         self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
                    }
            })
        }
    }
    
    
    @IBAction func resetButtonAction(sender: AnyObject) {
        
        logFlurryEvent(kFlurryResetPassowrd)
        if let preview = NSBundle.mainBundle().loadNibNamed("ResetPassword", owner: self, options: nil).first as? ResetPassword
        {
            preview.frame = self.view.frame
            preview.parent = self
            self.view.addSubview(preview)
            self.view.bringSubviewToFront(preview)
            self.navigationController?.navigationBarHidden = true
        }
    }
    
    
    func enableControls(enable:Bool) -> Void {
     
        self.profilePicButton.userInteractionEnabled = enable

        self.firstNameTF.userInteractionEnabled = enable
        self.firstNameTF.enabled = enable
        self.lastNameTF.enabled = enable
        self.userNameTF.enabled = !enable
        self.firstNameTF.hidden = !enable
        self.lastNameTF.hidden = !enable
        self.userNameTF.hidden = enable

        self.phoneTF.enabled = enable
        self.phoneTF.userInteractionEnabled = enable
        
        if enable == true
        {
            self.firstNameTF.applyTextFieldPrimaryTheme()
            self.lastNameTF.applyTextFieldPrimaryTheme()
            self.phoneTF.applyTextFieldPrimaryTheme()
        }
        else
        {
            self.firstNameTF.backgroundColor = UIColor.clearColor()
             self.lastNameTF.backgroundColor = UIColor.clearColor()
             self.phoneTF.backgroundColor = UIColor.clearColor()
        }
    }
    
    
    func updateUI() -> Void
    {
        self.userNameTF.text = "\(userModel.userInfo![kUserFirstName]!) \(userModel.userInfo![kUserLastName]!)"
        self.firstNameTF.text = userModel.userInfo![kUserFirstName] as? String
        self.lastNameTF.text = userModel.userInfo![kUserLastName] as? String
        self.emailTF.text = userModel.userInfo![kUserEmail] as? String
        self.phoneTF.text = userModel.userInfo![kUserPhone] as? String
       
        if isImagePicked == false
        {
            let profileURL = userModel.userInfo![kUserProfilePicture] as? String
            if  (profileURL != nil)
            {
                let image = RBAKeyChainWrapper.sharedInstance.getProfilePic()
                if image != nil {
                    self.profilePicButton.setImage(image, forState: .Normal)
                }
                else
                {
                    self.profilePicButton.setImage(UIImage.init(named: PROFILRPIC_PLACEHOLDER_IMAGE), forState: .Normal)
                }
                self.profilePicButton.sd_setImageWithURL(NSURL.init(string: profileURL!), forState: .Normal,placeholderImage:self.profilePicButton.imageForState(.Normal) , completed: { (image :UIImage!, error : NSError!, cacheType, url:NSURL!) in
                    if(image != nil)
                    {
                        RBAKeyChainWrapper.sharedInstance.saveUserProfilePicInKeychain(image)
                    }
                })
            }
        }
        
        isImagePicked = false
        self.tableView.reloadData()
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    
    //MARK: ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.profilePicButton.setImage(pickedImage, forState: .Normal)
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PROFILECELL, forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.textColor = UIColor.appFontColor()
        cell.textLabel?.font = UIFont.appRegularFontWithSize14()
        
        if indexPath.row == 0
        {
            cell.textLabel?.text = VEHICLE_LIST_TITLE
            cell.detailTextLabel?.text = "\(userModel.vehicleCount)"
        }
        else
        {
            cell.textLabel?.text = CARDS_LIST_TITLE
            cell.detailTextLabel?.text = "\(userModel.cardCount)"
        }
        
        
        let seperaterLabel = UILabel(frame: CGRect(x:5 , y:cell.contentView.frame.size.height , width: self.view.frame.size.width-10 , height: 0.3))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        cell.contentView.addSubview(seperaterLabel)
        

        return cell
    }
 

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            let vehcilVC =  self.getViewControllerWithIdentifierAndStoryBoard(VEHICLEVC, storyBoard: VEHICLE_STORYBOARD) as! Fuelster_VehiclesListVC
            vehcilVC.isFromMenu = false
            self.navigationController?.pushViewController(vehcilVC, animated: true)
        }
        else {
            self.pushViewControllerWithIdentifierAndStoryBoard(PAYMENTCARDVC, storyBoard: PAYMENTCARDSTORYBOARD)
        }

    }
   
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 60.0;
    }
    
    
    func emptyViewToHideUnNecessaryRows() -> UIView?
    {
        //Return this clear color view for footer
        let view = UIView(frame: CGRectMake(0, 0, 320, 100))
        view.backgroundColor = UIColor.clearColor()
        return view
    }

}
