//
//  ResetPassword.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 02/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class ResetPassword: UIView,UITextFieldDelegate {
    
    @IBOutlet weak var oldPsswordTF: RBATextField!
    @IBOutlet weak var newPasswordTF: RBATextField!
    @IBOutlet weak var confirmPasswordTF: RBATextField!
    let model = Model.sharedInstance
    var parent = UIViewController()
    let fieldValidator = RAFieldValidator.sharedInsatnce()
    let resetAlertVC = RBAAlertController()
    
    @IBOutlet weak var resetBtn: UIButton!
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        fieldValidator.requiredFields = [[kValidatorField:oldPsswordTF,kValidatorFieldKey:"oldPssword"],[kValidatorField:newPasswordTF,kValidatorFieldKey:"newPassword"],[kValidatorField:confirmPasswordTF,kValidatorFieldKey:"confirmPassword"]]
        self.oldPsswordTF.applyTextFieldPrimaryTheme()
        self.newPasswordTF.applyTextFieldPrimaryTheme()
        self.confirmPasswordTF.applyTextFieldPrimaryTheme()
        
        self.oldPsswordTF.addLeftView(PASSWORD_SMALL_IMAGE)
        self.newPasswordTF.addLeftView(PASSWORD_SMALL_IMAGE)
        self.confirmPasswordTF.addLeftView(PASSWORD_SMALL_IMAGE)
        resetBtn.applyPrimaryShadow()
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        
        let validator = fieldValidator.validateReuiredFields()
        if (validator == nil) {
            
            if oldPsswordTF.text != RBAKeyChainWrapper.userPassword() {
                resetAlertVC.presentAlertWithTitleAndMessage("Password", message: "The old password is not recognized.", controller: self.parent)
                
                return
            }
            
            if newPasswordTF.text?.characters.count<6 || newPasswordTF.text?.characters.count>20{
                resetAlertVC.presentAlertWithTitleAndMessage(kPasswordValidationMaxLengthTitle, message: kPasswordValidationMaxLengthMessage, controller: self.parent)
                
                return
            }
            
            if oldPsswordTF.text?.characters.count<6 || oldPsswordTF.text?.characters.count>20{
                resetAlertVC.presentAlertWithTitleAndMessage(kPasswordValidationMaxLengthTitle, message: kPasswordValidationMaxLengthMessage, controller: self.parent)
                
                return
            }
            
            if newPasswordTF.text != confirmPasswordTF.text {
                resetAlertVC.presentAlertWithTitleAndMessage("", message: "Passwords do not match", controller: self.parent)
                kPasswordValidationMaxLengthMessage
                
                return
            }
            
            if self.oldPsswordTF.text == self.newPasswordTF.text {
                resetAlertVC.presentAlertWithTitleAndMessage("", message: "New password and confirm password should not be same.", controller: self.parent)
                
                return
            }
            
            self.initHudView(.Indeterminate, message: kHudWaitingMessage)
            
            let resetBody = model.prepareresetPasswordRequestBody([self.oldPsswordTF.text!,self.newPasswordTF.text!])
            let userModel = UserModel.sharedInstance
            userModel.requestForResetPassword(resetBody, success: { (result) in
                
                debug_print(result)
                dispatch_async(dispatch_get_main_queue()) {
                    self.hideHudView()
                    self.resetAlertVC.presentAlertWithTitleAndMessage("", message: "Your password has been changed.", controller: self.parent)
                    self.parent.navigationController?.navigationBarHidden = false
                    self.removeFromSuperview()
                }
                
                }, failureBlock: { (error) in
                    debug_print(error)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.hideHudView()
                        self.resetAlertVC.presentAlertWithTitleAndMessage(kErrorTitle, message: error.localizedDescription, controller: self.parent)
                        
                        return
                    }
                    
            })
        }
        else {
            let tf = validator[kValidatorField] as! UITextField
            
            if tf == oldPsswordTF {
                resetAlertVC.presentAlertWithTitleAndMessage(kSignUpAllDetailsTitle, message: kSignUpAllDetailsMessage, controller: self.parent)
                
                return
            }
            else {
                resetAlertVC.presentAlertWithTitleAndMessage(kSignUpAllDetailsTitle, message: kSignUpAllDetailsMessage, controller: self.parent)
                
                return
            }
            
            
        }
    }
    
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        
        self.parent.navigationController?.navigationBarHidden = false
        self.removeFromSuperview()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == oldPsswordTF {
            newPasswordTF.becomeFirstResponder()
        }
        else if textField == newPasswordTF {
            confirmPasswordTF.becomeFirstResponder()
        }
        else
        {
            confirmPasswordTF.resignFirstResponder()
        }
        
        return true
    }
}
