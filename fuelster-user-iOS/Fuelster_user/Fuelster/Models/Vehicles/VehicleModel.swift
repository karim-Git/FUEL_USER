//
//  VehicleModel.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class VehicleModel: NSObject {

    static let  sharedInstance = VehicleModel()
    var allVehicles: [Vehicle]? = []
    var filterVehicles : [Vehicle]? = []
    var vehicle = Vehicle?()
    let model = Model.sharedInstance
    
    
    func addNewVehicle(vehicleInfo:[NSObject:AnyObject])  {
        
        let newVehicle = Vehicle().initWithVehicleInfo(vehicleInfo)
        if newVehicle != nil {
            self.allVehicles?.append(newVehicle!)
        }
    }

    
    func getVehicleAtIndex(index:NSInteger) -> Vehicle? {
        
        self.vehicle = self.allVehicles![index]
        
        return self.vehicle

    }
    
    
    func validateVehicle(vehicleInfo:[NSObject:AnyObject]) -> Bool {
        
        for (idx,vhcle) in (self.allVehicles?.enumerate())!
        {
            if vhcle.vehicleId == vehicleInfo["vehicleId"] as? String
            {
                
                return true
            }
        }
        return false
    }
    
    
    
    func updatedFilterListBasedOnSearchText(searchText : String)
    {
        if (NSString(string: searchText).length   >= 3)
        {
            filterVehicles = allVehicles!.filter({ (vehicle) -> Bool in
                let tmp: NSString = vehicle.vehicleNumber!
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }
        else
        {
            filterVehicles = NSArray.init(array: allVehicles!) as? [Vehicle]
        }
    }
    

    //MARK:API Request methods
    
    func requestForUserVehicles(success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: kGetVehicles, successBlock: { (response) in
            debug_print(response)
           //======= self.convertResponseIntoAllVehicles(response as! NSArray)
            self.convertResponseIntoAllVehicles(response["result"] as! NSArray)
            success(result: response)
            
        }) { (error) in
            //self.convertResponseIntoAllVehicles(parentVC)
            failureBlock(error:error)
        }
    }
    
    
    
    func requestForVehicleDetails(vehcileInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
        
        ServiceModel.connectionWithBody(nil, method: GETMETHOD, service: "\(kGetVehicleInfo)\(vehcileInfo[kVehicleId])", successBlock: { (response) in
           
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
            debug_print(error.localizedDescription)
        }
    }
    
    
    func requestForAddNewVehicleForUser(vehcileInfo:[NSObject:AnyObject],success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void  {
        
        /*
         let keys = Array(user.keys)
         let body = Array(user.values)
         
         ServiceModel.connectionWithMultiformBody(body, withNames: keys, method: PUTMETHOD, service: kGetUserUpdate, dataType: "png", successBlock: { (response) in
         
         debug_print(response)
         self.userInfo = response["result"] as? [NSObject:AnyObject]
         
         success(result: response)
         
         }) { (error) in
         failureBlock(error: error)
         
         }

 */
        
        let keys = Array(vehcileInfo.keys)
        let body = Array(vehcileInfo.values)
        ServiceModel.connectionWithMultiformBody(body, withNames: keys, method: POSTMETHOD, service: kVehicleSave, dataType: "png", successBlock: { (response) in
            
            debug_print(response)
            
            success(result: response)
            
        }) { (error) in
            failureBlock(error: error)
            
        }
        
  /*   ServiceModel.connectionWithBody(vehcileInfo, method: POSTMETHOD, service: kVehicleSave, successBlock: { (response) in
           
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }
*/
    }
    
    
    func requestForUpdateVehicle(vehcileInfo:[NSObject:AnyObject], vehicleID: String,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
       
        let serviceString = kVehicleSave + "/" + vehicleID
        let keys = Array(vehcileInfo.keys)
        let body = Array(vehcileInfo.values)
        
        ServiceModel.connectionWithMultiformBody(body, withNames: keys, method: PUTMETHOD, service: serviceString, dataType: "png", successBlock: { (response) in
            
            debug_print(response)
          //  self.userInfo = response["result"] as? [NSObject:AnyObject]
            
            success(result: response)
            
        }) { (error) in
            failureBlock(error: error)
            
        } 

   /*     let serviceString = kVehicleSave + "/" + vehicleID
        ServiceModel.connectionWithBody(vehcileInfo, method: PUTMETHOD, service: serviceString, successBlock: { (response) in
          
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }
*/
    }
    
    
    func requestForDeleteVehcile(vehcileInfo:Vehicle,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void) -> Void {
       
        //"\(kGetVehicleInfo)/\(vehcileInfo.vehicleId)"
        let serviceString = kVehicleSave + "/" + vehcileInfo.vehicleId!
        ServiceModel.connectionWithBody(nil, method: DELETEMETHOD, service: serviceString, successBlock: { (response) in
          
            success(result: response)
            debug_print(response)
        }) { (error) in
            
            failureBlock(error:error)
        }

    }
    
    
    func convertResponseIntoAllVehicles(response:NSArray,parentVC:Fuelster_VehiclesListVC) -> Void {
       
        self.convertResponseIntoAllVehicles(response)
        parentVC.loadVechilesList()
    }
    
     func convertResponseIntoAllVehicles(response:NSArray) -> Void
     {
        allVehicles?.removeAll()
        
        for var dict  in response
        {
            debug_print(dict)
            var v1 : Vehicle = Vehicle()
            v1   = v1.initWithVehicleInfo(dict as! [NSObject : AnyObject])!
            allVehicles?.append(v1)
        }
        
        filterVehicles = allVehicles
    }
}
