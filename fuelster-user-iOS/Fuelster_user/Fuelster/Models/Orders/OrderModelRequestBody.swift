//
//  OrderModelRequestBody.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 25/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

extension OrdersModel
{
    func requestForCreateOrderBody(params:[AnyObject],location:[AnyObject],user:[AnyObject],vehicle:[AnyObject]) -> [NSObject:AnyObject] {
        
        let cardSaveBody = model.prepareCreateOrderRequestBody(params,location: location,user: user,vehicle: vehicle)
        
        
        
        return cardSaveBody
    }
    
    
    func prepareEstimatedDeliveryTimeRequestBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        
        let cardSaveBody = model.prepareCardSaveRequestBody(params)
        return cardSaveBody
    }


}
