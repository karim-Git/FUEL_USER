//
//  Vehicle.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Vehicle: NSObject {

    var vehicleId : String?
    var title : String?
    var make : String?
    var model : String?

    var vehicleNumber : String?
    var fuel : String?
    var vehiclePicture : String?
    var isDeleted : Bool?
    var user : String?
    var card : String?

    var paymentCard =  Card()
    func initWithVehicleInfo(vehicleInfo:[NSObject:AnyObject]) -> Vehicle? {
        
        if self.vehicleId == nil {
            self.vehicleId = vehicleInfo["_id"] as? String
        }
        
        self.title = vehicleInfo["title"] as? String
        self.make = vehicleInfo["make"] as? String
        self.model = vehicleInfo["model"] as? String
        self.vehicleNumber = vehicleInfo["vehicleNumber"] as? String
        self.fuel = vehicleInfo["fuel"] as? String
        self.vehiclePicture = vehicleInfo["vehiclePicture"] as? String
        self.isDeleted = vehicleInfo["isDeleted"] as? Bool
        self.user = vehicleInfo["user"] as? String
        //self.card = vehicleInfo["card"] as? String
        if vehicleInfo["card"] != nil {
              self.paymentCard.initWithCardInfo(vehicleInfo["card"] as! [NSObject:AnyObject])
        }
     

       return self
        
    }
}
