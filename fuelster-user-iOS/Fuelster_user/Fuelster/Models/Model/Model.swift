//
//  Model.swift
//  DrillLogs
//
//  Created by Sandeep Kumar Rachha on 24/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit


class Model: NSObject {
    
    static let  sharedInstance = Model()
    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
     let menuArr = [[MenuTitle:MENU_HOME,MenuIcon:MENU_HOME_IMAGE], [MenuTitle:MENU_PROFILE,MenuIcon:MENU_PROFILE_IMAGE], [MenuTitle:MENU_ORDER_HISTORY,MenuIcon:MENU_ORDER_HISTORY_IMAGE], [MenuTitle:MENU_HELP,MenuIcon:MENU_HELP_IMAGE], [MenuTitle:MENU_ABOUT,MenuIcon:MENU_ABOUT_IMAGE],[MenuTitle:MENU_SIGNOUT,MenuIcon:MENU_SIGNOUT_IMAGE]]
    
    let cancelledReasonArr = ["The Delivery time is too late","I gave the wrong information","I need to move my vehicle","Payment issues","Other"]
    var pickerArr = [String]?()
    
    //MARK: login User profile array
    let loginParamsArr = [kUserEmail,kUserPassword,kUserRole,kDeviceToken]
    let registartionParamsArr = [kUserFirstName,kUserLastName,kUserEmail,kUserPhone,kUserPassword,kUserProfilePicture]
    let forgotPasswordParamsArr = [kUserEmail]
    let resetPasswordParamsArr = [kUserOldPassword,kUserNewPassword]
    let profileUpdateParamsArr = [kUserFirstName,kUserLastName,kUserEmail,kUserPhone,kUserProfilePicture]

    
    //MARK: Vehicle Array Keys
    let vehicleSaveParamArr = [kVehicleTitle,kVehicleMake,kVehicleModel,kVehicleNumber,kVehicleFuel,kVehicleCard,kVehiclePicture]
   //  let vehicleSaveParamArr = [kVehicleTitle,kVehicleMake,kVehicleModel,kVehicleNumber,kVehicleFuel,kVehicleCard]

    //MARK: Card Array keys
    let cardSaveParamArr = [kCardholderName ,kCardNumber,kCardCvv,kCardHolderName,kCardExpiry,kCardZipcode]
    
    
    //MARK: Order Array keys
    let orderLocationParamArr = [kOrderLatiitude,kOrderLongitude]
    let orderCreateParamArr = ["estimatedTimeStart","estimatedTimeEnd",kFuelType,kOrderQuantity,kFuelPrice,"truck","pricePerGallon","estimatedTime"]
    let orderUserParamArr = [kUserId,kUserFirstName,kUserLastName]
    let orderVehicleParamArr = [kVehicleId,kVehicleCard]

    //MARK: login User Profile request Body

    func prepareLoginRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let loginRequestBody = self.prepareRequestBody(params, keys: loginParamsArr)
        
        return loginRequestBody
    }
    
    
    func prepareRegistrationRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: registartionParamsArr)
        let loginRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)
        return loginRequestBody
//        
//        let loginRequestBody = self.prepareRequestBody(params, keys: registartionParamsArr)
//        
//        return loginRequestBody
    }
    

    func prepareForgotRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let loginRequestBody = self.prepareRequestBody(params, keys: forgotPasswordParamsArr)
        
        return loginRequestBody
    }

    
    func prepareresetPasswordRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let loginRequestBody = self.prepareRequestBody(params, keys: resetPasswordParamsArr)
        
        return loginRequestBody
    }
    
    
    func prepareProfileUpdateRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: profileUpdateParamsArr)
        let loginRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)

        return loginRequestBody
    }

    
    //MARK: Vehicles request Body
    func prepareVehicleSaveRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
       
        let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: vehicleSaveParamArr)
        let vehicleSaveRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)
        return vehicleSaveRequestBody
    }
    
    func updateParamsAndKeys(params:[AnyObject],keys:[AnyObject]) -> ([AnyObject],[AnyObject])
    {
        var updateParams  = [AnyObject] ()
        var updateKeys   = [AnyObject] ()
        for  (index,value) in params.enumerate()
        {
            if ((value as? String) != nil)
            {
                let valueString:String = value as! String
                if (valueString.characters.count > 0) {
                    updateParams.append(value)
                    updateKeys.append(keys[index])
                }
            }
            if ((value as? NSData) != nil)
            {
                updateParams.append(value)
                updateKeys.append(keys[index])
            }
        }
        return(updateParams,updateKeys)
    }
    
    func prepareVehicleUpdateRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
         let (updatedParams, updateKeys) = self.updateParamsAndKeys(params, keys: vehicleSaveParamArr)
        var vehicleUpdateRequestBody = self.prepareRequestBody(updatedParams, keys: updateKeys)
        //Add vehcile ID at last position
        vehicleUpdateRequestBody[""] = ""
        return vehicleUpdateRequestBody
    }
    

    func prepareVehicleDeleteRequestBody(params:[AnyObject]) -> [NSObject:AnyObject] {
     
        let vehicleDeleteRequestBody = self.prepareRequestBody(params, keys: vehicleSaveParamArr)
        return vehicleDeleteRequestBody

    }
    
    
    //MARK: Cards request Body
    func prepareCardSaveRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let cardSaveRequestBody = self.prepareRequestBody(params, keys: cardSaveParamArr)
        return cardSaveRequestBody
    }
    
    
    func prepareCardUpdateRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        var cardUpdateRequestBody = self.prepareRequestBody(params, keys: cardSaveParamArr)
        //Add Card ID at last position
        cardUpdateRequestBody[""] = ""
        return cardUpdateRequestBody
    }
    
    
    func prepareCardDeleteRequestBody(params:[AnyObject]) -> [NSObject:AnyObject] {
        
        let cardDeleteRequestBody = self.prepareRequestBody(params, keys: cardSaveParamArr)
        return cardDeleteRequestBody
        
    }
    
    
    //MARK: Orders request Body

    func prepareCreateOrderRequestBody(params:[AnyObject],location:[AnyObject],user:[AnyObject],vehicle:[AnyObject]) ->[NSObject:AnyObject] {
        
        var orderSaveRequestBody = self.prepareRequestBody(params, keys: orderCreateParamArr)
        orderSaveRequestBody[kOrderLocation] = self.prepareRequestBody(location, keys: orderLocationParamArr)
        orderSaveRequestBody[kOrderUser] = self.prepareRequestBody(user, keys: orderUserParamArr)
        orderSaveRequestBody[kOrderVehicle] = self.prepareRequestBody(vehicle, keys: orderVehicleParamArr)

        return orderSaveRequestBody
    }
    
    
    func prepareEstimatedDeliveryTimeRequestBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
        let cardUpdateRequestBody = self.prepareRequestBody(params, keys: vehicleSaveParamArr)
        return cardUpdateRequestBody
    }


    func prepareRequestBody(params:[AnyObject],keys:[AnyObject]) -> [NSObject:AnyObject] {
        var requestBody = [String:AnyObject]()
        
        for (idx,key) in keys.enumerate()
        {
            requestBody[key as! String] = params[idx] 
        }
        return requestBody
    }

}
