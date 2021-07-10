//
//  PaymentCardsVC.swift
//  Fuelster
//
//  Created by Prasad on 8/22/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import Stripe

class PaymentCardsVC: Fuelster_BaseViewController
{
    
    @IBOutlet var cardsTableView: UITableView!
    @IBOutlet var noCardsMessageView: UIView!

    
    var selectedRow = -1 //Indicates selected Vechile index in array
    var items: [String] = ["We", "Heart", "Swift"]
    
    var selectedCard : Card!


    

    //View did Load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.title = "My Cards"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addNewCardButtonAction))
        
        let nib = UINib(nibName: "CardsCustomCell", bundle: nil)
        self.cardsTableView.registerNib(nib, forCellReuseIdentifier: "CardsCustomCell")
        
        cardsTableView.tableFooterView = self.emptyViewToHideUnNecessaryRows()
        
        self.noCardsMessageView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.hideUnHideNoCardsMessage()
        
        self.view .initHudView(.Indeterminate, message: kHudLoadingMessage)
        cardModel.requestForUserCards({ (result) in
            
            debug_print(result)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.hideHudView()
                self.cardsTableView.reloadData()
            }
            
        }) { (error) in
            debug_print(error)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.hideHudView()
            }
            
        }
        
        
    }

    
    //Navigate to AddNewCardVC to add a new card
    func addNewCardButtonAction()
    {
        self.pushViewControllerWithIdentifierAndStoryBoard(ADDNEWCARDVC, storyBoard: PAYMENTCARDSTORYBOARD)
        
     //   self.pushViewControllerWithIdentifierAndStoryBoard(VIEWCARDVC, storyBoard: PAYMENTCARDSTORYBOARD)

    }
    
    
    //MARK : Table view methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cardModel.allCards!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:CardsCustomCell = tableView.dequeueReusableCellWithIdentifier("CardsCustomCell")! as! CardsCustomCell
        let paymentCard = cardModel.allCards![indexPath.row]
        
        cell.textLabel?.textColor = UIColor.appFontColor()
        cell.textLabel?.font = UIFont.appRegularFontWithSize14()
        
        // cell.textLabel?.text = self.items[indexPath.row]
        cell.configureCell(paymentCard)
        cell.delegate = self
         cell.tag = indexPath.row
        
        
        if   (selectedRow == indexPath.row)
        {
            cell.cardDetailsView.hidden = false
        }
        else
        {
            cell.cardDetailsView.hidden = true
        }
        
          self.hideUnHideNoCardsMessage()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if   (selectedRow == indexPath.row)
        {
            selectedRow = -1
            
        }
        else
        {
            selectedRow = indexPath.row
        }

        tableView.reloadData()
        //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if  (selectedRow == indexPath.row)
        {
            return 220.0;
        }
        
        return 60.0;
        
    }
    
    
    func emptyViewToHideUnNecessaryRows() -> UIView?
    {
        //Return this clear color view for footer
        let view = UIView(frame: CGRectMake(0, 0, 320, 100))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    
    
    //MARK: Card delte methods
    
    func cellCardDeleteButtonAction(cell: UITableViewCell)
    {
        self.selectedCard = cardModel.allCards![cell.tag]
        debug_print(self.selectedCard.cardNumber)
        showConfirmDeleteAction()
    }
    
    
    func showConfirmDeleteAction()
    {
        let actionsArr:[()->()] = [{
            _ in
            
            
            },{
                self.deleteCardAPI(self.selectedCard)
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: ["Cancel","OK"], controller: self, message: kDeleteCardMessage)
    }
    
    
    func deleteCardAPI(vehicleToDelete: Card)
    {
        logFlurryEvent("Delete Card")
        self.view.initHudView(.Indeterminate, message: kHudWaitingMessage)
        cardModel.requestForDeleteCard(selectedCard, success:
            {(result) in
                debug_print("Card Deleted \(result)");
                dispatch_async(dispatch_get_main_queue())
                {
                    self.view.hideHudView()
                   // self.loginAlertVC.presentAlertWithMessage("Card Deleted.", controller: self)
                    self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:"Card Deleted.", controller: self)

                    
                    self.cardsTableView.reloadData()
                    self.hideUnHideNoCardsMessage()
                }

            })
        { (error) in
            
           
          
            debug_print("Card Deleted failed \(error)");
            dispatch_async(dispatch_get_main_queue())
            {
                self.view.hideHudView()
                self.cardsTableView.reloadData()
                
                
                let statusCode = error.userInfo[krequestStatusCode]
                if(statusCode != nil)
                {
                    if  (statusCode!.integerValue == kRequestError400)
                    {
                         self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:"Unable to delete card due to pending orders. Wait until your orders get fulfilled.", controller: self)
                    }
                    else
                    {
                         self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:"Your request is not performed. Please try again after sometime.", controller: self)
                    }
                }
                else
                {
                     self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:"Your request is not performed. Please try again after sometime.", controller: self)
                }
                
            }

        }
        
    }
    
    func hideUnHideNoCardsMessage()
    {
        if self.cardModel.allCards?.count == 0
        {
            self.noCardsMessageView.hidden = false
            self.cardsTableView.hidden = true
            
        }
        else
        {
            self.noCardsMessageView.hidden = true
            self.cardsTableView.hidden = false
        }
    }
    
}

