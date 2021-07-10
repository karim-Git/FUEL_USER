//
//  Fuelster_RegistrationVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 09/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_RegistrationVC: Fuelster_BaseViewController {
    
    @IBOutlet weak var firstNameTF: RBATextField!
    @IBOutlet weak var lastNameTF: RBATextField!
    @IBOutlet weak var phoneNumberTF: REFormattedNumberField!
    @IBOutlet weak var emailTF: RBATextField!
    @IBOutlet weak var passwordTF: RBATextField!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signupScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var signupSuccessView: UIView!
    @IBOutlet weak var signupOKBtn: UIButton!
    
    var profileImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        firstNameTF.applyTextFieldPrimaryTheme()
        lastNameTF.applyTextFieldPrimaryTheme()
        phoneNumberTF.applyTextFieldPrimaryTheme()
        emailTF.applyTextFieldPrimaryTheme()
        passwordTF.applyTextFieldPrimaryTheme()
        
        imageButton.layer.cornerRadius = imageButton.layer.frame.size.width/2
        imageButton.layer.masksToBounds = true
        
        phoneNumberTF.format = "(XXX) XXX-XXXX"
        signUpButton.applyPrimaryShadow()
        signupOKBtn.applyPrimaryShadow()
        
        //Set Attribute text for Sign in button
        let fullString = signInButton .titleLabel?.text
        let subString = kLoginAllDetailsTitle
        let range = ((fullString! as NSString)).rangeOfString(subString)
        let underlineAttributedString = NSMutableAttributedString(string:fullString!)
        
        //Under line
        underlineAttributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
        
        //Font
        underlineAttributedString.addAttribute(NSFontAttributeName, value: UIFont.appRegularFontWithSize12() , range: NSRange(location: 0, length: fullString!.characters.count))
        
        //Text Color
        underlineAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.appLightFontColor() , range: NSRange(location: 0, length: fullString!.characters.count - 7 ))
        underlineAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.appFontColor() , range: range)
        
        signInButton.setAttributedTitle(underlineAttributedString, forState: .Normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func dismissSignupViewController(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func signupButtonAction(sender: AnyObject) {
        
        let (valid,tf) = self.validateFields()
        
        if  valid == false {
            
            if (tf == firstNameTF || tf == lastNameTF)
            {
                self.loginAlertVC.presentAlertWithTitleAndMessage (kSignUpAllDetailsTitle, message:kSignUpAllDetailsMessage, controller: self)
                return
            }
            if tf == emailTF {
                
                self.loginAlertVC.presentAlertWithTitleAndMessage (kEmailvalidationTitle, message:kSignupInvalidEmailMessage, controller: self)
                return
            }
            if tf == phoneNumberTF {
                self.loginAlertVC.presentAlertWithTitleAndMessage (kPhoneNumberValidationTitle, message:kPhoneNumberValidationMessage, controller: self)
                return
            }
            if passwordTF.text?.characters.count<6 || passwordTF.text?.characters.count>20{
                self.loginAlertVC.presentAlertWithTitleAndMessage (kPasswordValidationMaxLengthTitle, message:kPasswordValidationMaxLengthMessage, controller: self)
                return
            }
            
            self.loginAlertVC.presentAlertWithTitleAndMessage (kSignUpAllDetailsTitle, message:kSignUpAllDetailsMessage, controller: self)
            
            return
        }
        self.view .initHudView(.Indeterminate, message: kHudRegisteringMessage)
        
        var imageObject : AnyObject
        // checking vehicle image have nill value
        if profileImage != nil
        {
            imageObject = UIImageJPEGRepresentation(profileImage!, 0.1)!
        }
        else
        {
            imageObject = ""
        }
        
        let trimmedEmail = emailTF.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        
        let signUpBody = userModel.requestForRegistrationBody([firstNameTF.text!,lastNameTF.text!,trimmedEmail,phoneNumberTF.text!,passwordTF.text!,imageObject])
        
        userModel.requestForUserRegistartion(signUpBody, success: { (result) in
            debug_print(result)
            dispatch_async(dispatch_get_main_queue()) {
                self.view .hideHudView()
                self.enableViews(false)
            }
            
        }) { (error) in
            debug_print(error)
            dispatch_async(dispatch_get_main_queue()) {
                self.view .hideHudView()
                self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
            }
        }
    }
    
    
    func validateFields() -> (Bool,UITextField?) {
        
        for v in signupScrollView.subviews {
            if v is UITextField {
                let tf = v as! UITextField
                tf.resignFirstResponder()
                if tf.text?.characters.count <= 0 {
                    return (false,tf)
                }
            }
        }
        
        if (phoneNumberTF.text?.characters.count < 14) {
            return (false,phoneNumberTF)
        }
        
        let trimmedEmail = emailTF.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        print("trimmedEmail=== \(trimmedEmail)")
        if ((trimmedEmail.validateEmail()) == false) {
            
            return (false,emailTF)
        }
        if passwordTF.text?.characters.count<6 || passwordTF.text?.characters.count>20
        {
            return (false,passwordTF)
        }
        
        return (true,nil)
    }
    
    
    @IBAction func okButtonAction(sender: AnyObject) {
        
        self.enableViews(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func enableViews(show:Bool) -> Void {
        self.signupSuccessView.hidden = show
        self.signupScrollView.hidden = !show
    }
    
    
    @IBAction func takeImageAction(sender: AnyObject) {
        
        let imagPicker = RBAImagePickerManager()
        imagPicker.setParent(self)
        imagPicker.showImagePicker()
    }
    
    
    //MARK: ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            profileImage = pickedImage
            imageButton.setImage(pickedImage, forState: .Normal)
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
