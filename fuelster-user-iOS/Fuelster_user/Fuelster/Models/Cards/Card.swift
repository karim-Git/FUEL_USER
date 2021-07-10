//
//  Card.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Card: NSObject {

    //static let  sharedInstance = Card()

    var cardholderName: String?
    var cardNumber: String?
    var cvv: String?
    var cardId : String?
    var createdAt : String?
    var expiry : String?
    var isDeleted : Bool?
    var stripeCardId : String?
    var type : String?
    
    func initWithCardInfo(cardInfo:[NSObject:AnyObject]) -> Card? {
        
        if self.cardId == nil {
             self.cardId = cardInfo["_id"] as? String
        }
        self.cardholderName = cardInfo["cardHolderName"] as? String
        self.cardNumber = cardInfo["cardNumber"] as? String
        self.cvv = cardInfo["cvv"] as? String
        self.createdAt = cardInfo["createdAt"] as? String
        self.expiry = cardInfo["expiry"] as? String
        self.isDeleted = cardInfo["isDeleted"] as? Bool
        self.stripeCardId = cardInfo["stripeCardId"] as? String
        self.type = cardInfo["type"] as? String
        /*
         {
         "__v" = 0;
         "_id" = 57ce71c152475ea8ed220d9b;
         cardHolderName = "V DURGA PRASAD";
         cardNumber = 4444;
         createdAt = "2016-09-02T13:03:20.261Z";
         expiry = "5/2019";
         isDeleted = 0;
         stripeCardId = "card_18qe6mAaBojCiiufJ1zWVlGb";
         type = MasterCard;
         }
 */
        return self
    }

    func updateCardWithInfo(cardInfo:[NSObject:AnyObject]) -> Void {
        
        self.initWithCardInfo(cardInfo)
    }
    func cardImageName() -> String {
        
        if type == CREDITCARD_EMPTY {
            return ""
        }
        if type == "MasterCard" {
             return "Master_small"
        }
        else  if type == "Visa"
        {
            return "Visa_small2"
        }
        else  if type == "Discover"
        {
            return "Other_small"
        }
        else  if type == "JCB"
        {
            return "Other_small"
        }
        else  if type == "Diners Club"
        {
            return "Other_small"
        }
        else  if type == "American Express"
        {
            return "AmericanExpress"
        }
        return "Other_small"
    }
    
    func cardTemplateImageName() -> String {
        
        if type == CREDITCARD_EMPTY {
            return ""
        }
        if type == "MasterCard" {
            return "Master_Template"
        }
        else  if type == "Visa"
        {
            return "Visa_Template"
        }
        else  if type == "Discover"
        {
            return "Other_Template"
        }
        else  if type == "JCB"
        {
            return "Other_Template"
        }
        else  if type == "Diners Club"
        {
            return "Other_Template"
        }
        else  if type == "American Express"
        {
            return "AE_Tempalte"
        }

        return "Other_Template"
    }


}


