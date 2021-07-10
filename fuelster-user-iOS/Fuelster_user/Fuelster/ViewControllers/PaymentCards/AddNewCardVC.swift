//
//  AddNewCardVC.swift
//  Fuelster
//
//  Created by Prasad on 8/24/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import Stripe

class AddNewCardVC: Fuelster_BaseViewController,UITextFieldDelegate, CardIOPaymentViewControllerDelegate
{
    
    //UI Outlets
    @IBOutlet weak var cardTypeView: UIView!
    
    @IBOutlet weak var nameOnCardTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: REFormattedNumberField!
    @IBOutlet weak var expiryDateTextField: REFormattedNumberField!
    @IBOutlet weak var cvvTextField: REFormattedNumberField!
    @IBOutlet weak var whatIsThisButton: UIButton!
    @IBOutlet weak var saveCardButton: UIButton!
    @IBOutlet weak var orlbl: UILabel!
    
    @IBOutlet weak var scanCardButton: UIButton!
    //Variables
    let fieldValidator = RAFieldValidator.sharedInsatnce()
   
    var editOrAddVehicleVC: Fuelster_AddNewVehicle!
    
    // viewDidLoad - any additional setup after loading the view.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        if CardIOUtilities.canReadCardWithCamera() == true {
            CardIOUtilities.preload()
            self.showCardScanner()
        }
        else {
            self.showControl(true)
            scanCardButton.hidden = true
            orlbl.hidden = true
        }


        scanCardButton.addUnderLine()

        let selftitle =  "Add New Card"
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel

        
        //Configuring UI
        nameOnCardTextField.applyTextFieldPrimaryTheme()
        cardNumberTextField.applyTextFieldPrimaryTheme()
        expiryDateTextField.applyTextFieldPrimaryTheme()
        cvvTextField.applyTextFieldPrimaryTheme()
        saveCardButton.applyPrimaryShadow()
        
        var textFieldFrame = nameOnCardTextField.frame
        textFieldFrame.size.height = 90
        textFieldFrame.size.width = 20
        nameOnCardTextField.frame = textFieldFrame
        
        //Adding field to Validate
        fieldValidator.requiredFields = [
            [kValidatorField:nameOnCardTextField,kValidatorFieldKey:"NameOnCard"],
            [kValidatorField:cardNumberTextField,kValidatorFieldKey:"CardNumber"],
            [kValidatorField:expiryDateTextField,kValidatorFieldKey:"ExpiryDate"],
            [kValidatorField:cvvTextField,kValidatorFieldKey:"CVV"]
        ]
        
        //Set formats for text fields
        self.cardNumberTextField.format = "XXXX XXXX XXXX XXXX"
        self.expiryDateTextField.format = "XX/XX"
        self.cvvTextField.format = "XXXX"

    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        fieldValidator.requiredFields = [
            [kValidatorField:nameOnCardTextField,kValidatorFieldKey:"NameOnCard"],
            [kValidatorField:cardNumberTextField,kValidatorFieldKey:"CardNumber"],
            [kValidatorField:expiryDateTextField,kValidatorFieldKey:"ExpiryDate"],
            [kValidatorField:cvvTextField,kValidatorFieldKey:"CVV"]]
    }
    
    
    func showControl(show:Bool) -> Void {
        
        for subView in self.view.subviews {
            subView.hidden = !show
        }
    }
    
    func showCardScanner() -> Void {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC.modalPresentationStyle = .FormSheet
        cardIOVC.hideCardIOLogo = true
        cardIOVC.collectCardholderName = false
        cardIOVC.collectExpiry = false
        cardIOVC.collectCVV = false
        cardIOVC.allowFreelyRotatingCardGuide = false
        cardIOVC.disableManualEntryButtons = true
        self.presentViewController(cardIOVC, animated: true, completion: nil)

     }
    
    
    
    @IBAction func scanCardButtonAction(sender: AnyObject) {
       
        if CardIOUtilities.canReadCardWithCamera() == true {
            self.showCardScanner()
        }
        else {
            /// TO DO
        }

    }
    
    
    @IBAction func whatIsThisButtonAction(sender: AnyObject)
    {
        let image = UIImage(named: "CVV")
        self.view .showImagePreview(image!)
    }
    
    
    @IBAction func saveButtonAction(sender: AnyObject)
    {
        let validator = fieldValidator.validateReuiredFields()
        if (validator == nil) //Save Card
        {
            if cardNumberTextField.text?.characters.count < 17{
               // loginAlertVC.presentAlertWithMessage(kStripeCardNumberErrorMessage, controller: self)
                loginAlertVC.presentAlertWithTitleAndMessage(kStripeCardNumberErrorTitle , message: kStripeCardDetailsErrorMessage, controller: self)

                
                return
            }
            
            if expiryDateTextField.text?.characters.count < 5{
               // loginAlertVC.presentAlertWithMessage(kStripeCardExpirationDateErrorMessage, controller: self)
                loginAlertVC.presentAlertWithTitleAndMessage (kStripeCardExpirationDateErrorTitle, message:kStripeCardExpirationYearErrorMessage, controller: self)
                return
            }

            if cvvTextField.text?.characters.count < 3{
                //loginAlertVC.presentAlertWithMessage(kStripeCardCVVErrorMessage, controller: self)
                
                 loginAlertVC.presentAlertWithTitleAndMessage (kStripeCardCVVErrorTitle, message:kStripeCardCVVMaxMessage, controller: self)
                
                return
            }

            self.stripeValidateCard()
        }
        else
        {
          //  loginAlertVC.presentAlertWithMessage(kStripeCardDetailsErrorMessage, controller: self)
            
              loginAlertVC.presentAlertWithTitleAndMessage (kStripeCardDetailsErrorTitle, message:kStripeCardDetailsErrorMessage, controller: self)
            
            return
        }
        
    }
    
    
    
    //MARK: Stripe integration
    func stripeValidateCard()
    {
        logFlurryEvent("Add Card")
        var requestBody = [String:AnyObject]()
        
        //Card inputs
        let cardParams = STPCardParams()
        
        
        let cardHolderName : NSString = nameOnCardTextField.text!
        let cardNumber : NSString = cardNumberTextField.text!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let cardCvv : NSString = cvvTextField.text!
        let cardExpiry : NSString = expiryDateTextField.text!
        var cardExpiryValues = cardExpiry.componentsSeparatedByString("/")
        
        let cardExpiryMonth: String = cardExpiryValues [0]
        let cardExpiryYear: String = cardExpiryValues [1]
        
        //Card Perameters
        cardParams.name = cardHolderName as String
        cardParams.number =   cardNumber as String
        cardParams.expMonth = UInt(cardExpiryMonth)!
        cardParams.expYear = UInt(cardExpiryYear)!
        cardParams.cvc = cardCvv as String
        debug_print(cardParams)
        
        self.view.initHudView(.Indeterminate, message: "")
        STPAPIClient.sharedClient().createTokenWithCard(cardParams) { (token, error) in
            debug_print("come to loop")
            if error != nil
            {
                // show the error to the user
                 debug_print("============ stripe ERROR = \(error?.description)");
              //  self.loginAlertVC.presentAlertWithMessage((error?.localizedDescription)!, controller: self)
                
                  self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:(error?.localizedDescription)!, controller: self)
                

                self.view.hideHudView()
            }
            else if token != nil
            {
                let card = token?.card
                var country = ""
                if card?.country == nil{
                     country = ""
                }
                else {
                   country = (card?.country!)!
                }
                
                let cardInfo:[String:AnyObject] =  ["id": (card?.cardId)!,"object": "card","country": country,"exp_month": (card?.expMonth)!,"exp_year": (card?.expYear)!,"funding": (card?.funding.rawValue)!,"last4": (card?.last4())!]
                //cardInfoDict Dictionay of Card Token Objects  KEY : VALUE
                //var cardInfoDict: [String:AnyObject]?
                
                /*requestBody =
                 [
                 "id" : token!.tokenId,
                 "object":"token",
                 "livemode" : token!.livemode,
                 // "bankAccount" : token!.bankAccount!,
                 "created": (token?.created)!,
                 "type": "card",
                 "used": false
                 ];
                 
                 */
                debug_print("============ cardInfo = \(cardInfo)");
                
                requestBody["card"] =  token!.tokenId
                
                //let cardInfoDict = requestBody
                let cardsModel = CardsModel.sharedInstance
                
                debug_print("============ tokennnnnnnn id = \(requestBody)");
                
                
                
                //JSON  "card" : "tok_18oUqrAaBojCiiuftl6QgEx4"
                cardsModel.requestForAddNewCardForUser(requestBody,
                                                       
                                                       success:
                    {
                        (result) in
                        debug_print("============ result = \(result)");
                        dispatch_async(dispatch_get_main_queue()) {
                            //self.showAlertActionWithMessage("Your new card has been added.")
                            
                            self.view.hideHudView()

                            
                            let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
                            if (vc is Fuelster_AddNewVehicle)
                            {
                                let addVehicleVC: Fuelster_AddNewVehicle = vc as! Fuelster_AddNewVehicle
                                addVehicleVC.assignedCard = (CardsModel.sharedInstance.allCards?.last)!
                            }
                            self.navigationController?.popViewControllerAnimated(true)
                            
                            
                        }
                    },
                                                       
                                                       failureBlock:
                    {
                        (error) in
                        debug_print("============ result error = \(error)");
                        dispatch_async(dispatch_get_main_queue()) {
                           // self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                            
                               self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
                            
                            self.view.hideHudView()
                        }

                } )
                
            }
        }
        
    }
    
    
    func showAlertActionWithMessage(message : String) -> Void
    {
        let actionsArr:[()->()] = [{
            _ in
            
           let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
            if (vc is Fuelster_AddNewVehicle)
            {
                let addVehicleVC: Fuelster_AddNewVehicle = vc as! Fuelster_AddNewVehicle
                addVehicleVC.assignedCard = (CardsModel.sharedInstance.allCards?.last)!
            }
            self.navigationController?.popViewControllerAnimated(true)
            
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["OK"], controller: self, message: message)
    }
    
    //didReceiveMemoryWarning Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:------ UITextField Delgate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (textField == nameOnCardTextField)
        {
            cardNumberTextField.becomeFirstResponder()
        }
        if (textField == cardNumberTextField)
        {
             expiryDateTextField.becomeFirstResponder()
        }
        if (textField == expiryDateTextField)
        {
            cvvTextField.becomeFirstResponder()
        }
        if (textField == expiryDateTextField)
        {
            textField .resignFirstResponder()
        }
        return true
    }
    
    
    //MARK:--- CARD IO delegate methods
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        self.showControl(true)
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {

            // resultLabel.text = str as String
            if info.cardholderName != nil {
                //nameOnCardTextField.text = info.cardholderName
            }
            if info.cardNumber != nil {
                let number = info.cardNumber as NSString
                let str = number.re_stringWithNumberFormat(cardNumberTextField.format)
                cardNumberTextField.text = str
                cardNumberTextField.formatInput(cardNumberTextField)
            }
            if String(info.expiryMonth) != nil {
                //expiryDateTextField.text = "\(info.expiryMonth)/\(info.expiryYear)"
            }
            if info.cvv != nil {
               // cvvTextField.text = info.cvv
            }
        }
        self.showControl(true)
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
