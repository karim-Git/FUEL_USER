//
//  Veh_Model.swift
//  Fuelster
//
//  Created by Kareem on 20/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit
class Veh_Model: NSObject {
    
    var name : String?
    var tanksize : String?
    
    func initWithVeh_ModelInfo(modelInfo:[NSObject:AnyObject]) -> Veh_Model? {
        
        self.name = modelInfo["name"] as? String
        self.tanksize = modelInfo["tanksize"] as? String
        return self
        
    }
}