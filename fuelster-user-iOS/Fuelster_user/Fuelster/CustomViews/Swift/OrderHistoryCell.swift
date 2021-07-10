//
//  OrderHistoryCell.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import QuartzCore

class OrderHistoryCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var vehicleLbl: UILabel!
    @IBOutlet weak var vehicleModelLbl: UILabel!
    @IBOutlet weak var fuelTypeLbl: UILabel!
    @IBOutlet weak var estimatedPriceLbl: UILabel!
    @IBOutlet weak var vehicleImgView: UIImageView!
    @IBOutlet weak var orderStatusImgView: UIImageView!
    @IBOutlet weak var repeatOrderbtn: UIButton!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    
    @IBOutlet weak var vehicleNameLbl: UILabel!
    weak var delegate:CustomeCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vehicleImgView.layer.cornerRadius = self.vehicleImgView.frame.size.width/2
        self.vehicleImgView.layer.masksToBounds = true
        
        self.contentView.applyPrimaryShadow()
        self.contentView .sendSubviewToBack(bgView)
    }

    
    func configureCell(order:Order, _delegate:Fuelster_OrderHistoryVC) -> Void {
      
        self.contentView.applyScecondaryBackGroundGradient()
        viewDetailsBtn.applyPlainStyle()

        delegate = _delegate
        let placeHolderImg = UIImage.init(named: "CarImage")
        if order.vehicle![kVehiclePicture] == nil{
            vehicleImgView.image = placeHolderImg
        }
        else {
            self.vehicleImgView.sd_setImageWithURL(NSURL.init(string:order.vehicle![kVehiclePicture]! as! String), placeholderImage: placeHolderImg)
        }
        
        self.orderDateLbl.text = order.updatedAt!.getStringFromParseFullDate()
        self.orderStatusLbl.text = order.status
        self.orderStatusImgView.hidden = true
        
        self.vehicleLbl.text = order.orderNumber

        self.vehicleNameLbl.text = order.vehicle![kVehicleTitle] as? String
        if order.vehicle![kVehicleMake] != nil  && order.vehicle![kVehicleModel] != nil{
            self.vehicleModelLbl.text = "\(order.vehicle![kVehicleMake]!) \(order.vehicle![kVehicleModel]!)"
        }
        
        if order.fuelType != nil  && order.quantity != nil{
           // self.fuelTypeLbl.text = "\(order.fuelType!)-\(order.quantity!)"
            self.fuelTypeLbl.text = "Fuel type: "+MakeModelJSON.sharedInstance.getFuelDisplayNameWithFuelNumber(order.fuelType!)
         //   self.fuelTypeLbl.text = order.fuelType!

        }
        
        if order.price != nil  {
            self.estimatedPriceLbl.text = "Estimated Price: $\(order.price!)"
        }


    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func vewDetailsButtonAction(sender: AnyObject) {
        
        self.delegate?.cellPushButtonAction!(self)
    }
    
    
    @IBAction func repeatOrderButtonAction(sender: AnyObject) {
        
        
    }
}
