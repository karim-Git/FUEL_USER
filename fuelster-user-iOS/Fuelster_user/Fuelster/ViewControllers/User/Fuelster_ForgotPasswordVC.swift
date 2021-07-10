//
//  Fuelster_ForgotPasswordVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_ForgotPasswordVC: Fuelster_BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var bottomIllustrater: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.emailTF.applyTextFieldPrimaryTheme()
        self.emailTF.addLeftView(EMAIL_SMALL_IMAGE)
        self.continueBtn.applyPrimaryShadow()
        self.cancelBtn.applyPlainStyle()
        self.applyBottomLineForIllustreter()
    }
    
    
    func applyBottomLineForIllustreter()
    {
        let seperaterLabel = UILabel(frame: CGRect(x: -100, y:bottomIllustrater.frame.size.height , width: self.view.frame.size.width+100 , height: 0.3))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        bottomIllustrater.clipsToBounds = false
        bottomIllustrater.addSubview(seperaterLabel)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissForgotPasswordVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func continueButtonAction(sender: AnyObject) {
        
        if self.emailTF.text?.validateEmail() == false {
            self.loginAlertVC.presentAlertWithTitleAndMessage (kEmailvalidationTitle, message:kforgotInvalidEmailMessage, controller: self)
            return
        }
        else {
            logFlurryEvent(kFlurryForgotPassword, email: emailTF.text!)
            self.emailTF.resignFirstResponder()
            self.view .initHudView(.Indeterminate, message: kHudWaitingMessage)

            let forgotBody = userModel.requestForForgotPasswordBody([self.emailTF.text!])
            userModel.requestForUserForgotPassword(forgotBody, success: { (result) in
                debug_print(result)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view .hideHudView()
                    let actionsArr:[()->()] = [{
                        _ in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        }]
                    self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: [kAlertOK], controller: self, message: kUsserPasswordResetMessage)
                }

            }) { (error) in
                debug_print(error)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view .hideHudView()
                    self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                    self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
                }
                return
            }
        }
    }
   
    
     func textFieldShouldReturn(textField: UITextField) -> Bool
     {
        textField.resignFirstResponder()
        return true
    }

}
