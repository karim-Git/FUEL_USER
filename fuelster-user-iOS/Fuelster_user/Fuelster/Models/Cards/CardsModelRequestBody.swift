//
//  CardsModelRequestBody.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 25/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

extension CardsModel
{
    
    func requestForCardSaveBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        
        let cardSaveBody = model.prepareCardSaveRequestBody(params)
        return cardSaveBody
    }
    
    func requestForCardUpdateBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        
        let cardUpdtaeBody = model.prepareCardUpdateRequestBody(params)
        return cardUpdtaeBody
    }
    
    
    func requestForCardDeleteBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        let cardDeleteBody = model.prepareCardDeleteRequestBody(params)
        return cardDeleteBody
        
    }

}