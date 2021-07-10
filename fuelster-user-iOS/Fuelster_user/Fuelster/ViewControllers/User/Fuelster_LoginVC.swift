//
//  Fuelster_LoginVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 09/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

class Fuelster_LoginVC: Fuelster_BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var loginScrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var emailTF: RBATextField!
    @IBOutlet weak var passwordTF: RBATextField!
    @IBOutlet weak var bottomIllustrater: UIImageView!
    let locationManager = O1LocationManager.sharedInstance()
    let fieldValidator = RAFieldValidator.sharedInsatnce()
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        self.emailTF.applyTextFieldPrimaryTheme()
        self.emailTF.addLeftView(EMAIL_SMALL_IMAGE)
        self.emailTF.leftView?.alpha = 0.7
        self.passwordTF.applyTextFieldPrimaryTheme()
        self.passwordTF.addLeftView(PASSWORD_SMALL_IMAGE)
        
        fieldValidator.requiredFields = [[kValidatorField:self.emailTF,kValidatorFieldKey:kUserEmail],[kValidatorField:self.passwordTF,kValidatorFieldKey:kUserPassword]]
        signInButton.applyPrimaryShadow()
        
        self.applyBottomLineForIllustreter()
        
        //Set Attribute text for sigup button
        let fullString = signUpButton.titleLabel?.text
        let subString = kSignUpAllDetailsTitle
        let range = ((fullString! as NSString)).rangeOfString(subString)
        let underlineAttributedString = NSMutableAttributedString(string:fullString!)
        
        //Under line
        underlineAttributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
        signUpButton.setAttributedTitle(underlineAttributedString, forState: .Normal)
        
        //Font
        underlineAttributedString.addAttribute(NSFontAttributeName, value: UIFont.appRegularFontWithSize12() , range: NSRange(location: 0, length: fullString!.characters.count))
        
        //Text Color
        underlineAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.appLightFontColor() , range: NSRange(location: 0, length: fullString!.characters.count - 7 ))
        underlineAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.appFontColor() , range: range)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)

        forgotPassword.setUnderLineText()
        self.view.bringSubviewToFront(signUpButton)
        emailTF.text = ""
        passwordTF.text = ""
        fieldValidator.requiredFields = [[kValidatorField:self.emailTF,kValidatorFieldKey:kUserEmail],[kValidatorField:self.passwordTF,kValidatorFieldKey:kUserPassword]]
        
        checkAutoLogin()
    }
    
    
    func showLoginControls(show:Bool) ->Void
    {
        emailTF.hidden = !show
        passwordTF.hidden = !show
        forgotPassword.hidden = !show
        signUpButton.hidden = !show
        signInButton.hidden = !show
    }
    
    
    func applyBottomLineForIllustreter()
    {
        let seperaterLabel = UILabel(frame: CGRect(x: -100, y:bottomIllustrater.frame.size.height , width: self.view.frame.size.width+100 , height: 0.5))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        bottomIllustrater.clipsToBounds = false
        bottomIllustrater.addSubview(seperaterLabel)
    }
    
    
    func checkAutoLogin()
    {
        let (username,password) = RBAKeyChainWrapper.getCredentialsFromKeychain()
        
        if (username.characters.count > 0 && password.characters.count > 0)
        {
            self.showLoginControls(false)
            emailTF.text = username
            passwordTF.text = password
            signInButtonAction(signInButton)
        }
        else {
            self.showLoginControls(true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func signInButtonAction(sender: AnyObject)
    {
        self.loginScrollView.contentOffset = CGPointZero
        let defaults = NSUserDefaults.standardUserDefaults()
        var deviceTokenString = defaults.stringForKey(kDeviceToken)
        if deviceTokenString == nil {
            deviceTokenString = "1234"
        }
        //debug_print(deviceTokenString)
        debug_print(deviceTokenString)
        let validator = fieldValidator.validateReuiredFields()
        if (validator == nil) {
            if self.emailTF.text?.validateEmail() == true {
                self.view .initHudView(.Indeterminate, message: kHudLoggingMessage)
                self.logFlurryEvent(kFlurryLogin,email: emailTF.text!)
                let userInfo = userModel.requestForLoginBody([self.emailTF.text!,self.passwordTF.text!,kUserRoleKey,deviceTokenString!])
                    userModel.requestForUserSignIn(userInfo, success: { (result) in
                    debug_print(result)
                    self.keychain .saveCredentialsInKeychain(self.emailTF.text!, password: self.passwordTF.text!)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view .hideHudView()
                        self.presentMenuVC()
                    }
                    return
                    
                }) { (error) in
                    debug_print(error)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.view .hideHudView()
                        self.showLoginControls(true)
                        // Checking Auto update error
                        let statusCode = error.userInfo[krequestStatusCode]
                        if(statusCode != nil)
                        {
                            if  (statusCode!.integerValue == kRequestError426)
                            {
                                self.checkVersionUpdated(error)
                                return
                            }
                        }
                        
                        self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)

                    }
                }
            }
            else {
                loginAlertVC.presentAlertWithTitleAndMessage (kEmailvalidationTitle, message:kLoginInvalidEmailMessage, controller: self)
                self.showLoginControls(true)
                return
            }
        }
        else {
            self.showLoginControls(true)
            if self.emailTF.text?.characters.count == 0 && self.passwordTF.text?.characters.count == 0 {
                loginAlertVC.presentAlertWithTitleAndMessage (kLoginAllDetailsTitle, message:kLoginAllDetailsMessage, controller: self)
                return
            }
            
            let tf = validator[kValidatorField] as! UITextField
            if tf == self.emailTF {
                loginAlertVC.presentAlertWithTitleAndMessage (kEmailvalidationTitle, message:kEmailvalidationMessage, controller: self)
                return
            }
            else {
                    loginAlertVC.presentAlertWithTitleAndMessage (kPasswordRequiredTitle, message:kPasswordRequiredMessage, controller: self)
                return
            }
        }
    }
    
    
    func presentMenuVC() -> Void {
        let nvc = self.getViewControllerWithIdentifier(NAVIGATIONVC)
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    
    //MARK:--- Show Alert For Update Application
    func checkVersionUpdated(error: NSError) -> Bool {
        // Update
        let dict : NSMutableDictionary = NSMutableDictionary()
        dict.setObject(kFuelsterAppUpdateMessage, forKey: kNotificationMessage)
        dict.setObject(APPSTORE_LINK, forKey: kAppStoreLink)
        showUpdateAppAlert(dict)
        return false
    }
    
    
    func showUpdateAppAlert(response:AnyObject )
    {
        let message = response.objectForKey(kNotificationMessage)as! String
        let actionsArr:[()->()] = [{
            _ in
           UIApplication.sharedApplication().openURL(NSURL.init(string: response.objectForKey(kAppStoreLink) as! String)!)
            
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: [kAlertUpdate], controller: self, message: message)
    }
 
    
}
