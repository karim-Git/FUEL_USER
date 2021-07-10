//
//  OrderCancellationView.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 14/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class OrderCancellationView: UIView,UITextViewDelegate
{

    @IBOutlet weak var otherTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var parentVC = Fuelster_BaseViewController()

    var radioButtonsArr : [UIButton] =  []
    let model = Model.sharedInstance
    var cancelledReason = ""
    @IBAction func closeButtonAction(sender: AnyObject) {
        self.superview?.alpha = 1.0
        self.removeFromSuperview()
        
       

    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.layer.cornerRadius = 10.0
        for superView in self.subviews
        {
            if superView is UIButton {
                
            }
            else {
                for subview in superView.subviews
                {
                    if subview is UIButton {
                        let btn = subview as! UIButton
                        if btn.tag < 6 {
                            self.radioButtonsArr .append(btn)
                        }
                        if  btn.tag == 1{
                            self.cancelledReason = model.cancelledReasonArr[btn.tag-1]
                        }
                    }
                }
            }
        }
        
        cancelButton.applyPlainStyle()
        containerView.layer.cornerRadius = 10;
        containerView.layer.masksToBounds = true
        
        otherTextView.layer.cornerRadius = 10;
        otherTextView.layer.masksToBounds = true
        otherTextView.layer.borderColor = UIColor.appUltraLightFontColor().CGColor
        otherTextView.layer.borderWidth = 0.1
        otherTextView.backgroundColor = UIColor.textFieldPrimaryBackgroundColor()
    }
 
    @IBAction func cancelOrderButtonAction(sender: AnyObject) {
      
        if self.cancelledReason.characters.count == 0 {
               // self.parentVC.loginAlertVC.presentAlertWithMessage("Please provide cancellation reason.", controller:  self.parentVC)
            
            self.parentVC.loginAlertVC.presentAlertWithTitleAndMessage ("", message:"Please provide cancellation reason.", controller: self.parentVC)

            
            return
        }
        
        self.superview?.alpha = 1.0
        self.removeFromSuperview()
        self.parentVC.cancelOrder(self.cancelledReason)
    }

    
    @IBAction func orderCancelReasonAction(sender: AnyObject) {
        
        for button in self.radioButtonsArr {
            
            button.setImage(UIImage.init(named: "Order_Status_Gray"), forState: .Normal)
        }
        
        otherTextView.hidden = true
        otherTextView.resignFirstResponder()
        sender.setImage(UIImage.init(named: "Confirm_Small"), forState: .Normal)

        if sender.tag == 5 {
           otherTextView.hidden = false
            otherTextView.becomeFirstResponder()

            return
        }
        
        self.cancelledReason = model.cancelledReasonArr[sender.tag-1]
    }
    
    
    
    //MARK: TextView Delegate methods
     internal func textViewDidEndEditing(textView: UITextView) {
        
        self.cancelledReason = textView.text!
    }
internal func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
{
    
    if (text == "\n")
    {
        textView.resignFirstResponder()
        return false
    }
    return true
    }
    
}
