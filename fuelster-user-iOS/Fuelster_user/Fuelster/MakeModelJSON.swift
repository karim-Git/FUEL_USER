//
//  MakeModelJSON.swift
//  Fuelster
//
//  Created by Kareem on 20/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit

class MakeModelJSON: NSObject {
    
    static let  sharedInstance = MakeModelJSON()
    var allFuelTypes: [Fuel]? = []
    var allMakes : [VehicleMake]? = []
   
    func readJSONFile()
    {
        var dict = ReadJSON.getMakeModelData()
        
        // Getting FuelTypes
        let fuelsArray = dict["fuelTypes"]
        
        for var fuelDict in fuelsArray as! [AnyObject]
        {
            var fuelObject = Fuel()
            fuelObject = fuelObject.initWithFuelInfo(fuelDict as! [NSObject : AnyObject])!
            self.allFuelTypes?.append(fuelObject)
        }

        // Getting Make
        
        let makesArray = dict["make"]
      
        let descriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let sortedResults: NSArray = makesArray!.sortedArrayUsingDescriptors([descriptor])
        
        for var makeDict in sortedResults as! [AnyObject]
        {
            var makeObject = VehicleMake()
            makeObject = makeObject.initWithVehicleMakeInfo(makeDict as! [NSObject : AnyObject])!
            self.allMakes?.append(makeObject)
        }
        
    }
    
    func getFuelTypeNumber(name: String) -> String
    {
        
        let predicate = NSPredicate(format:"name = %@",name)
        let filterArr = allFuelTypes?.filter({ predicate.evaluateWithObject($0)})
        if ((filterArr?.count) > 0) {
            return filterArr![0].number!
        }
        return "89"
    }
    
    func getFuelTypeName(number: String) -> String
    {
        if number.characters.count > 0 {
            let predicate = NSPredicate(format:"number = %@",number)
            let filterArr = allFuelTypes?.filter({ predicate.evaluateWithObject($0)})
            if ((filterArr?.count) > 0) {
                return filterArr![0].name!
            }
            return "Regular"
        }
        return ""
        
    }
    
    func getFuelInfoToAPI(displayString: String) -> String!
    {
        if displayString.characters.count > 0 {
            let array = displayString.componentsSeparatedByString(":")
            return array[0]
        }
        return "";
    }
    
    func getFuelDisplayNameWithFuelNumber(number: String) -> String
    {
        if number.characters.count > 0 {
            let predicate = NSPredicate(format:"number = %@",number)
            let filterArr = allFuelTypes?.filter({ predicate.evaluateWithObject($0)})
            if ((filterArr?.count) > 0) {
                var displayString = filterArr![0].number! + ": " + filterArr![0].name!
                return displayString
            }
            return number + ": " + "Regular"
        }
        return "87: Regular"
        
    }
    
}