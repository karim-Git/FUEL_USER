//
//  AppDelegate.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 08/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import Stripe
import Flurry_iOS_SDK
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let sliderVC = SlideMenuController()
    

    //sandeep commit
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        
        //est Secret key :  sk_test_EdDvN1PFhxHP1CEY7573OhF9
        // test Publishable key : pk_test_HWexv0EcvwROn2aNo8r9a58U
        
       // APPSTORE Publishable key: pk_live_wtBvjfuMgYmTUSsDVJ3hZZAh
        
        //Stripe key 
        let defs = NSUserDefaults.standardUserDefaults()
        if defs.objectForKey(kUserAuthToken) as? String == nil {
            let keychain = RBAKeyChainWrapper.sharedInstance
            keychain.wipeKeychainData()
        }
        STPPaymentConfiguration.sharedConfiguration().publishableKey = kStripeKey


        setFlurry()
        setFabrics()
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        
        //Push notification
        registerForPushNotifications(application)
        MakeModelJSON.sharedInstance.readJSONFile()
        customappearance()

        return true
    }

    func customappearance() -> Void
    {
        let image = UIImage.init(named: NAVIGATION_BACK_IMAGE)
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-400.0, 0), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        let topvc = self.topViewController()
        print(topvc?.classForCoder)
        
        if(Fuelster_UserProfileVC.classForCoder() == topvc?.classForCoder )
        {
            print("xxxxxx")
        }
    }
    
    
    

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optioTenally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func setFlurry()  {
        Flurry.startSession(FLURRY_SESSIONID)
    }
    
    
    func  setFabrics()  {
        Fabric.with([STPAPIClient.self, Crashlytics.self])
    }
    
    
    
    /*
     
     Crete shcema.
     
     Change configs in info
     
     Crete user defined settings
     
     */

    //MARK: ---- PNS
    func registerForPushNotifications(application: UIApplication)
    {
      //  let notificationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        let notificationSettings = UIUserNotificationSettings(forTypes: [ .Sound, .Alert], categories: nil)
  
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings)
    {
        if notificationSettings.types != .None
        {
            application.registerForRemoteNotifications()
        }
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var deviceTokenString = ""
        
        for i in 0..<deviceToken.length
        {
            deviceTokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        debug_print("Device Token========== :, deviceTokenString")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(deviceTokenString, forKey: kDeviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        debug_print("Failed to register:", error)
    }
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

       // self.showNotifiyView()
        debug_print("=== === ==== userInfo \(userInfo)")
        let message = (userInfo[kNotificationBody] as? [NSObject:AnyObject])![kNotificationMessage] as? String

        let notifiAlert = UIAlertView()
        notifiAlert.title = kappName
        notifiAlert.message = message
        notifiAlert.addButtonWithTitle("OK")
        notifiAlert.show()
        notifiAlert.delegate = self
        
        
        if let aps = userInfo[kNotificationAPS] as? NSDictionary {
            if let alert = aps[kNotificationAlert] as? NSDictionary {
                if let message = alert[kNotificationMessage] as? NSString {
                    //Do stuff
                }
            } else if let alert = aps[kNotificationAlert] as? NSString {
                //Do stuff
            }
        }
        
        
    }
    
    
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        let topvc = self.topViewController()
        print(topvc?.classForCoder)
        
        if(Fuelster_OrderDetailVC.classForCoder() == topvc?.classForCoder )
        {
            let orderDetailsVC = topvc as! Fuelster_OrderDetailVC
            orderDetailsVC.refreshOrder(_:nil)
        }
          NSNotificationCenter.defaultCenter().postNotificationName(ORDER_REFRESH_NOTIFICATION, object: nil)
    }

    
    
    //To get the top /current view contorller
    func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let slideVc = base as? SlideMenuController {
            return topViewController(slideVc.mainViewController)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
    
        return base
    }

    
}








