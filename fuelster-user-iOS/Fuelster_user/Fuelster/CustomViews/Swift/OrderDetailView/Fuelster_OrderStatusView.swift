//
//  Fuelster_OrderStatusView.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 06/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderStatusView: UIView {

    
    @IBOutlet weak var orderEstimatedPriceLbl: UILabel!
    @IBOutlet weak var orderDeliveryLbl: UILabel!
    @IBOutlet weak var orderQunatityLbl: UILabel!
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.orderDeliveryLbl.adjustsFontSizeToFitWidth = true
        self.applyHorizantalPrimaryBackGroundGradient()
    }
    
    func setupOrderStatus(order:Order) -> Void {

        //let timeString: NSString =   NSString.localizedStringWithFormat("%@",order.estimatedTime! )
        
         let startTime = order.estimatedTimeStart!.getStringFromParseTime()
         let startAM = order.estimatedTimeStart!.getStringFromParseAMPM()
         let endTime = order.estimatedTimeEnd!.getStringFromParseTime()
         let endAM = order.estimatedTimeEnd!.getStringFromParseAMPM()

         let estimatedStart = startTime! + " " + startAM!
         let estimatedEnd = endTime! + " " + endAM!

        let timeString: NSString = estimatedStart + " - " + estimatedEnd
        self.orderDeliveryLbl.attributedText = timeString.getBoldAttributeString()

         let qtyString: NSString =   NSString.localizedStringWithFormat("%@ gal",order.quantity!)
         self.orderQunatityLbl.attributedText = qtyString.getBoldAttributeString()
        self.orderQunatityLbl.adjustsFontSizeToFitWidth = true
        if order.price != nil
        {
            print(order.price!)
            let priceString: NSString =   NSString.localizedStringWithFormat("$ %.2f",order.price!)
            print(priceString)
            self.orderEstimatedPriceLbl.attributedText = priceString.getBoldAttributeString()
            
            print("priceString ==== \(priceString)")
        }
    }


}
