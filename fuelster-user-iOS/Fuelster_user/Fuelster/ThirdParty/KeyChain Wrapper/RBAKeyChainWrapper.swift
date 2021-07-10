//
//  RBAKeyChainWrapper.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 16/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class RBAKeyChainWrapper: NSObject {
    
    
    static let sharedInstance = RBAKeyChainWrapper()
    private override init() {
        
    }
    
    var _isUserLoggedIn : Bool!
    
    func saveCredentialsInKeychain(userName:String, password:String) -> Bool {
        let _isUserNameSaved: Bool = KeychainWrapper.standardKeychainAccess().setString(userName, forKey: kUserFirstName)
        let _isPasswordSaved: Bool = KeychainWrapper.standardKeychainAccess().setString(password, forKey: kUserPassword)
        
        print("\(_isUserNameSaved) \(_isPasswordSaved)")
        let isSucess = _isUserNameSaved && _isPasswordSaved
        
        self.setUserStatus(isSucess)
        return isSucess
    }
    
    class func getCredentialsFromKeychain() -> (String,String) {
        
        let userName = KeychainWrapper.standardKeychainAccess().stringForKey(kUserFirstName)
        let password = KeychainWrapper.standardKeychainAccess().stringForKey(kUserPassword)
        if (userName != nil && password != nil)
        {
        return (userName!, password!)
        }
        
        return("","")
    }
    
    class func userPassword()->String
    {
        let password = KeychainWrapper.standardKeychainAccess().stringForKey(kUserPassword)
        return password!
    }
    
    
    class func setPassword(password:String)
    {
       KeychainWrapper.standardKeychainAccess().setString(password, forKey: kUserPassword)
    }
    
    
    func saveTokensInKeychain(authToken:String, refreshToken:String) -> Bool {
        let _isUserNameSaved: Bool = KeychainWrapper.standardKeychainAccess().setString(authToken, forKey: kUserAuthToken)
        let _isPasswordSaved: Bool = KeychainWrapper.standardKeychainAccess().setString(refreshToken, forKey: kUserRefreshToken)
        let defs = NSUserDefaults.standardUserDefaults()
        defs.setObject(authToken, forKey: kUserAuthToken)
        defs.setObject(refreshToken, forKey: kUserRefreshToken)

        print("\(_isUserNameSaved) \(_isPasswordSaved)")
        let isSucess = _isUserNameSaved && _isPasswordSaved
        
        return isSucess
    }

    
    class func getTokenFromKeychain() -> (String,String) {
        
        let authToken = KeychainWrapper.standardKeychainAccess().stringForKey(kUserAuthToken)
        let refreshToken = KeychainWrapper.standardKeychainAccess().stringForKey(kUserRefreshToken)
        
        return (authToken!, refreshToken!)
    }
    
    class func getAuthTokenFromKeychain() -> (String) {
        
        let authToken = KeychainWrapper.standardKeychainAccess().stringForKey(kUserAuthToken)
        return authToken!
    }

    class func getRefreshTokenFromKeychain() -> (String) {
        let refreshToken = KeychainWrapper.standardKeychainAccess().stringForKey(kUserRefreshToken)
        
        return refreshToken!
    }

    
    func setUserStatus(sucess:Bool) {
       /* if KeychainWrapper.standardKeychainAccess().setBool(sucess, forKey:kisLoggedIn) {
            _isUserLoggedIn = true
        }
        else {
            _isUserLoggedIn = false
        }*/
        
    }
    
    func getUserStatus() -> Bool! {
      //  _isUserLoggedIn = KeychainWrapper.standardKeychainAccess().boolForKey(kisLoggedIn)
        
        return _isUserLoggedIn
    }
    
    func wipeKeychainData()  {
        KeychainWrapper.wipeKeychain()
      
        let defs = NSUserDefaults.standardUserDefaults()
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        defs.removePersistentDomainForName(appDomain)
        NSUserDefaults.resetStandardUserDefaults()
        defs.synchronize()
    }
    //MARK:----- USER PROFILE
    func saveUserProfilePicInKeychain(image:UIImage) {
      //  KeychainWrapper.standardKeychainAccess().setData(UIImagePNGRepresentation(image)!, forKey: kUserProfilePicture)
        KeychainWrapper.standardKeychainAccess().setData(UIImageJPEGRepresentation(image, 0.1)!, forKey: kUserProfilePicture)

          }
  
    func  getProfilePic() -> UIImage!
    {
        var data: NSData? = nil
        data = KeychainWrapper.standardKeychainAccess().get(kUserProfilePicture)
     //   data  = NSUserDefaults.standardUserDefaults().objectForKey("userPic") as? NSData
        
        if (data != nil)
        {
            let image = UIImage.init(data: data!)
            return image
        }
        return nil
    }
    
   
}
