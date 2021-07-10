//
//  VehicleModelRequest.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 25/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

extension VehicleModel
{
    
    func requestForVehicleSaveBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        
        let vehicleSaveBody = model.prepareVehicleSaveRequestBody(params)
        return vehicleSaveBody
    }
    
    func requestForVehicleUpdateBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        
        let vehicleSaveBody = model.prepareVehicleUpdateRequestBody(params)
        return vehicleSaveBody
    }
    
    
    func requestForVehicleDeleteBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        let vehicleDeleteBody = model.prepareVehicleDeleteRequestBody(params)
        return vehicleDeleteBody

    }
}