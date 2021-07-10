//
//  Fuel.swift
//  Fuelster
//
//  Created by Kareem on 20/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit

class Fuel: NSObject {
    
    var number : String?
    var name : String?
    
    func initWithFuelInfo(fuelType:[NSObject:AnyObject]) -> Fuel? {
        
        self.number = fuelType["number"] as? String
        self.name = fuelType["name"] as? String
        return self
        
    }
}
