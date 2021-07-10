//
//  Fuelster_OrderDetailView.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 02/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderDetailView: UIView {

    @IBOutlet weak var orderLocationImg: UIImageView!
    
    @IBOutlet weak var orderVehicleModelLbl: UILabel!
    @IBOutlet weak var orderVehicleLbl: UILabel!
    
    @IBOutlet weak var orderVehicleFuelLbl: UILabel!
    
    @IBOutlet weak var orderCardImg: UIImageView!
    @IBOutlet weak var orderCardNumberLbl: UILabel!
    var parentVC = Fuelster_OrderDetailVC()
    private var gradient : CAGradientLayer = CAGradientLayer()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)

        self.gradient = self.applyScecondaryBackGroundGradient()
    }
 
    @IBAction func mapButtonAction(sender: AnyObject) {
        
        let mapVC = self.parentVC.getViewControllerWithIdentifier("OrderMapVC")
        self.parentVC.presentViewController(mapVC, animated: true, completion: nil)

    }
    
    func tapGestureAction(sender:UITapGestureRecognizer) -> Void {
        
        let mapVC = self.parentVC.getViewControllerWithIdentifier("OrderMapVC")
        self.parentVC.presentViewController(mapVC, animated: true, completion: nil)
    }
    
    func setupOrderDetails(order:Order) -> Void
    {
        self.orderLocationImg.sd_setImageWithURL(NSURL.init(string:order.mapthumbnail!), placeholderImage: nil)
        let vehicleName = order.vehicle![kVehicleTitle]! as? String
        self.orderVehicleLbl.text = "Vehicle: \(vehicleName!)"
        
        let vehicleMake =  (order.vehicle!["make"] as? String)
           let vehicleModel =  (order.vehicle!["model"] as? String)
        
        self.orderVehicleModelLbl.text = "Make and Model: "+vehicleMake!+vehicleModel!

        let fuelName = MakeModelJSON.sharedInstance.getFuelDisplayNameWithFuelNumber(order.fuelType!)
        debug_print( order.fuelType!)
        //self.orderVehicleFuelLbl.text = "Fuel Type:\(fuelName) \(order.fuelType!)"
       // self.orderVehicleFuelLbl.text = "Fuel Type: \(order.fuelType!)"
        self.orderVehicleFuelLbl.text = "Fuel Type: \(fuelName)"

        
        let cardInfo = order.vehicle![kVehicleCard] as! [NSObject: AnyObject]
        
        debug_print(cardInfo[kCardNumber] )
        self.orderCardNumberLbl.text  = cardInfo[kCardNumber] as? String
        
        if cardInfo[kCardType] as? String == "MasterCard" {
            self.orderCardImg.image = UIImage.init(named: "Master_small")
        }
        else  if cardInfo[kCardType] as? String == "Visa"
        {
            self.orderCardImg.image = UIImage.init(named: "Visa_small2")
        }

    }
    
    
    func getFuelTypeNumber(name: String) -> String
    {
        let predicate = NSPredicate(format:"name = %@",name)
        let filterArr = MakeModelJSON.sharedInstance.allFuelTypes?.filter({ predicate.evaluateWithObject($0)})
        if ((filterArr?.count) > 0) {
            return filterArr![0].number!
        }
        return "89"
    }
    
    func getFuelTypeName(number: String) -> String
    {
        if number.characters.count > 0 {
            let predicate = NSPredicate(format:"number = %@",number)
            let filterArr = MakeModelJSON.sharedInstance.allFuelTypes?.filter({ predicate.evaluateWithObject($0)})
            if ((filterArr?.count) > 0) {
                return filterArr![0].name!
            }
            return "Regular"
        }
        return ""
        
    }

    
    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)
        self.gradient.frame = self.bounds
    }

}
