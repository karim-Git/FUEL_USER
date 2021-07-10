//
//  CardsModel.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class CardsModel: NSObject {

    static let  sharedInstance = CardsModel()
    var allCards: [Card]? = []
    var filterCards : [Card]? = []
    var  creditCard = Card?()
    let model = Model.sharedInstance

    
    func addCard(cardInfo:[NSObject:AnyObject])
    {
        let newCard = Card().initWithCardInfo(cardInfo)
        if newCard != nil {
            self.allCards?.append(newCard!)
        }
    }
    
    
    func getCardAtIndex(index:NSInteger) -> Card? {
        
        self.creditCard = self.allCards![index]
        
        return self.creditCard
    }
    
    
    func validateCard(cardInfo:[NSObject:AnyObject]) -> Bool {
        
        for (idx,card) in (self.allCards?.enumerate())!
        {
            if card.cardId == cardInfo["cardInfo"] as! String
            {
                
                return true
            }
        }
        return false
    }
    
    func getFormattedDisplayString(card:Card) -> String {
        
        if  (card.type == CREDITCARD_EMPTY)
        {
            return card.cardholderName!
        }
        let fmtString = card.cardholderName! + " " + String(card.cardNumber!.characters.suffix(4))
        return fmtString
        
    }
    
    //MARK:API Request methods
   
    
    func requestForUserCards(success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: kGetCards, successBlock: { (response) in
            debug_print(response)
         
            self.convertResponseIntoAllCards(response.objectForKey("result") as! NSArray)
               success(result: response)
        }) { (error) in
            
            failureBlock(error:error)
        }
    }
    
    
    func requestForCardDetails(cardInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
       
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kGetCardInfo)\(cardInfo[kCardId])", successBlock: { (response) in
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForAddNewCardForUser(cardInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void  {
        
        ServiceModel.connectionWithBody(cardInfo, method: POSTMETHOD, service: kCardSave, successBlock: { (response) in
            var v1 : Card = Card()
            v1   = v1.initWithCardInfo(response["result"]!!["card"] as! [NSObject : AnyObject])!
            self.allCards?.append(v1)
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func requestForUpdateCard(cardInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: PUTMETHOD, service: kGetCardInfo, successBlock: { (response) in
          
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }


    }
    
    
    func requestForDeleteCard(cardInfo:Card,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
         let serviceString = kGetCardInfo+cardInfo.cardId!
        ServiceModel.connectionWithBody(nil, method: DELETEMETHOD, service: serviceString, successBlock: { (response) in
         //  allCards.remove
            for (index,card) in (self.allCards?.enumerate())!
            {
                if cardInfo.cardId == card.cardId
                {
                    self.allCards?.removeAtIndex(index)
                }
            }
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    func convertResponseIntoAllCards(response:NSArray) -> Void {
        
        allCards?.removeAll()
        
        for dict  in response
        {
            debug_print(dict)
            var v1 : Card = Card()
            v1   = v1.initWithCardInfo(dict as! [NSObject : AnyObject])!
            allCards?.append(v1)
        }

    }
    
    func getCardObjectWithID(objectID: String) -> Card {
        
        let predicate = NSPredicate(format:"cardId = %@",objectID)
        let filterArr = self.allCards?.filter({ predicate.evaluateWithObject($0)})
        if ((filterArr?.count) != nil) {
            return filterArr![0]
        }
        else
        {
            let card = Card()
            card.cardId = objectID
            card.cardholderName = "No Data"
            card.cardNumber = "1234 5678 9012 3456"
            return card
        }
     
    }
    
   

}

