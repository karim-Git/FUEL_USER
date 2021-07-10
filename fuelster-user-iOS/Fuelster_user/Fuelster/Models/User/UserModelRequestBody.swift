//
//  UserModelRequest.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 25/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation

extension UserModel
{
    
    func requestForLoginBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        
       let loginRequestBody = model.prepareLoginRequestBody(params)
        return loginRequestBody
    }
    
    
    func requestForRegistrationBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        let signupRequestBody = model.prepareRegistrationRequestBody(params)
        return signupRequestBody
    }

    
    func requestForForgotPasswordBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        let forgotPasswordBody = model.prepareForgotRequestBody(params)
        return forgotPasswordBody
    }
    
    
    func requestForResetPasswordBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        let forgotPasswordBody = model.prepareresetPasswordRequestBody(params)
        return forgotPasswordBody
    }


    func requestForProfileUpdateBody(params:[AnyObject]) ->[NSObject:AnyObject] {
        let profileUpdateBody = model.prepareProfileUpdateRequestBody(params)
        return profileUpdateBody
    }

}