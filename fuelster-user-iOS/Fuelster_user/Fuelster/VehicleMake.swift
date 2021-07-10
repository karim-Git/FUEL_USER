//
//  VehicleMake.swift
//  Fuelster
//
//  Created by Kareem on 20/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit

class VehicleMake: NSObject {
    
    var makeId : String?
    var name : String?
    var model : [Veh_Model]? = []
    
    func initWithVehicleMakeInfo(makeInfo:[NSObject:AnyObject]) -> VehicleMake? {
        
        if self.makeId == nil {
            self.makeId = makeInfo["id"] as? String
        }
        
        self.name = makeInfo["name"] as? String
       
        //self.model = [Veh_Model]
        var modelArray = makeInfo["model"]
        
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortedResults: NSArray = modelArray!.sortedArrayUsingDescriptors([descriptor])
        
        for var modelDict in sortedResults as! [AnyObject]
        {
            var modelV  = Veh_Model()
            modelV =  modelV.initWithVeh_ModelInfo(modelDict as! [NSObject : AnyObject])!
            self.model?.append(modelV)
        }
        
        return self
        
    }
}
