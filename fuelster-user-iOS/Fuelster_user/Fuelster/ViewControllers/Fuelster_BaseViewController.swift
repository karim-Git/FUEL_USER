//
//  Fuelster_BaseViewController.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 08/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_BaseViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CustomeCellDelegate,GoogleMapViewDelegate {

    let userModel =  UserModel.sharedInstance
    let loginAlertVC = RBAAlertController()
    let orderModel = OrdersModel.sharedInstance
    let model = Model.sharedInstance
    let vehiclemModel = VehicleModel.sharedInstance
    let cardModel = CardsModel.sharedInstance
    let keychain = RBAKeyChainWrapper.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelOrder(cancelReason:String) -> Void {

    }
    
    func didtappedOnMarker(marker:GMSMarker) -> Void {
        
    }
    
    
    func wipeModels() -> Void {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
