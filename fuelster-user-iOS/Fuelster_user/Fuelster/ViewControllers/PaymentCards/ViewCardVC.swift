//
//  ViewCardVC.swift
//  Fuelster
//
//  Created by Prasad on 8/29/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class ViewCardVC: Fuelster_BaseViewController,UITableViewDelegate,UITableViewDataSource
{
    
    //Outlets on CreditCard
    @IBOutlet weak var creditCardImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var nameOnCardLabel: UILabel!
    
    //If No Card is available
    @IBOutlet weak var noCardMsgLabel: UILabel!
 
    //Outlets on view
    @IBOutlet weak var changeCardLabel: UILabel!
    @IBOutlet weak var changeCardContainerView: UIView!
    @IBOutlet weak var changeCardTypeImageView: UIImageView!
    @IBOutlet weak var dropdownImageView: UIImageView!
    @IBOutlet weak var changeCardButton: UIButton!
    @IBOutlet weak var addNewCardView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var creditCardTF : RBATextField!
    
    var selectedCard : Card!
    var selectedVehcile : Vehicle!
    
    var popupTblView : UITableView!
    var popup : RBAPopup!
    var creditCardBtn : UIButton!
    
    //View did load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle =  "Add Payment Method"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel
      
        creditCardTF.applyTextFieldPrimaryTheme()
        creditCardImageView.applyPrimaryShadow()
        
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        // addNewCardView.applyPrimaryTheme()
        addNewCardView.layer.cornerRadius = 18.0
        addNewCardView.layer.borderWidth = 1.0
        loadCardDetails()
    }
    
    override func viewDidAppear(animated: Bool) {
       
        if creditCardBtn == nil  {
            let credtBtn = creditCardTF.addDropDownButton()
            credtBtn.addTarget(self, action: #selector(Fuelster_AddNewVehicle.creditCardButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            creditCardBtn = credtBtn
        }
       
    }
    
    //Memory
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    

    func loadCardDetails()
    {
        if selectedCard.cardId != nil {
            self.cardNumberLabel.text = "XXXX XXXX XXXX " + selectedCard.cardNumber!
            self.expiryDateLabel.text = selectedCard.expiry
            self.nameOnCardLabel.text = selectedCard.cardholderName
            
            creditCardTF.addLeftView(selectedCard.cardImageName())
            creditCardTF.text = CardsModel.sharedInstance.getFormattedDisplayString(selectedCard)
            
            self.creditCardImageView.hidden = false
            self.creditCardImageView.image = UIImage(named:  selectedCard.cardTemplateImageName())
            self.cardNumberLabel.hidden = false
            self.expiryDateLabel.hidden = false
            self.nameOnCardLabel.hidden = false
            
            self.noCardMsgLabel.hidden = true
            self.changeCardLabel.hidden = false
        }
        else
        {
            self.creditCardImageView.hidden = true
            self.cardNumberLabel.hidden = true
            self.expiryDateLabel.hidden = true
            self.nameOnCardLabel.hidden = true
            
            self.noCardMsgLabel.hidden = false
            
            self.noCardMsgLabel.text = " \n\n\nYou have no cards associated with this Vehicle. \n\nPlease add or select a card to proceed with placing the fuel order.";
           
            self.creditCardTF.placeholder = "Please select Credit Card"
            self.changeCardLabel.hidden = true
        }
        
    }

    // MARK:----- Button Actions
    @IBAction func creditCardButtonTapped(sender: UIButton) {
       
        if cardModel.allCards?.count > 0 {
            showPopUp(sender)
            //self.logFlurryEvent("Credit card list Button Tapped")
        }
        
    }
    
    @IBAction func addNewCardTapped(sender: UIButton) {
        debug_print("addNewCardTapped")
        self.logFlurryEvent("Add new credit card Tapped")
        self.pushViewControllerWithIdentifierAndStoryBoard(ADDNEWCARDVC, storyBoard: PAYMENTCARDSTORYBOARD)
        
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
      
        debug_print("nextButtonTapped")
        
      //  self.logFlurryEvent("Vehicle update with Crdit card")
        
        if selectedCard.cardId != nil
        {
            if  (selectedVehcile.paymentCard.cardId != nil)
            {
                if  (selectedCard.cardId == selectedVehcile.paymentCard.cardId)
                {
                    // Nothing to change
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else
                {
                    //Update Vehicle
                    updateVehicle()
                }
            }
            else
            {
                // Adding First time credit card to vehicle
                //Update Vehicle
                updateVehicle()
            }
        }
        else
        {
            // Display Select Card Alert
          //  self.loginAlertVC.presentAlertWithMessage(kPleaseSelectValidCreditCard, controller: self)
            
              self.loginAlertVC.presentAlertWithTitleAndMessage (kPleaseSelectValidCreditCardTitle, message:kPleaseSelectValidCreditCard, controller: self)
        }
        
        
    }
    
    /*!
     Vehicle updating with Credi Card
 */
    func updateVehicle()
    {
        self.view .initHudView(.Indeterminate, message: kHudWaitingMessage)
        
        
        let  updateVehicle = vehiclemModel.requestForVehicleUpdateBody(["","","","","",selectedCard.cardId!,""])
        
        // Updating vehicle
        
        vehiclemModel.requestForUpdateVehicle(updateVehicle,vehicleID: selectedVehcile.vehicleId!, success: { (result) in
            debug_print("Vechile updated ")
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.view.hideHudView()
                self.showAlertActionWithMessage(kVehicleUpdatedMeggage)
            }
            }, failureBlock: { (error) in
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.view.hideHudView()
                     self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
                }
                
        })
    }
    
    func showAlertActionWithMessage(message : String) -> Void
    {
        let actionsArr:[()->()] = [{
            _ in
            self.navigationController?.popViewControllerAnimated(true)
            
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["OK"], controller: self, message: message)
    }
    
    // MARK:- SHOW POPUP
    func showPopUp(view:UIView) -> Void
    {
        if popupTblView == nil
        {
            let frame = CGRectMake(0, 0, view.frame.size.width, 150)
            popupTblView = UITableView.init(frame: frame)
            popupTblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            popupTblView.delegate = self
            popupTblView.dataSource = self
        }
        
        let frame = CGRectMake(0, 0, view.frame.size.width, 150)
        popupTblView.frame = frame
        self.view.endEditing(true)
        popupTblView.reloadData()
        popupTblView.sizeToFit()
        popup = RBAPopup.init(customView: popupTblView)
        popup.presentPointingAtView(view, inView: self.view, animated: true)
    }

    
    // MARK:- SHOW UITableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return (cardModel.allCards?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.textColor = UIColor.appFontColor()
        cell.textLabel?.font = UIFont.appRegularFontWithSize14()

        
        var isHighlight = false
        
            cell.textLabel?.text = CardsModel.sharedInstance.getFormattedDisplayString(cardModel.allCards![indexPath.row])
            isHighlight = (cell.textLabel?.text == creditCardTF.text)
        
        if (isHighlight)
        {
            cell.accessoryType = .Checkmark
        }
        else
        {
            cell.accessoryType = .None
        }
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        self.creditCardTF.text = CardsModel.sharedInstance.getFormattedDisplayString(cardModel.allCards![indexPath.row])
        self.creditCardTF.addLeftView(cardModel.allCards![indexPath.row].cardImageName())
        selectedCard = cardModel.allCards![indexPath.row]
        loadCardDetails()
        popup.dismissAnimated(true)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 30.0;
    }
    
}
