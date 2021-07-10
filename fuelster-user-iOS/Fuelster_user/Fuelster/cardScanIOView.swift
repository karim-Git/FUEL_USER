//
//  cardIOView.swift
//  CardIOSample
//
//  Created by Sandeep Kumar Rachha on 04/10/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit


@objc protocol CardScanIOViewDelegate {

    func userDidCancelCardScanView(cardScanView:CardScanIOView)
    func cardIOView(cardScanView: CardScanIOView!, didScanCard cardInfo: CardIOCreditCardInfo!)

}


class CardScanIOView: UIView, CardIOViewDelegate {
    
    weak var scanDelegate:CardScanIOViewDelegate?
    
    @IBOutlet weak var cardIOView: CardIOView!
    @IBOutlet weak var cancelButton: UIButton!
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        self.showCardSCanner()
    }
    
    
    func showCardSCanner() -> Void {
       
        CardIOUtilities.preload()
        self.cardIOView.delegate = self
        cardIOView.hideCardIOLogo = true
        
    }
    
    
    @IBAction func cancelCardScanAction(sender: AnyObject) {
        
        self.scanDelegate?.userDidCancelCardScanView(self)
        
    }

    
    func cardIOView(cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n", info.cardNumber, info.expiryMonth, info.expiryYear)
            print(str)
            self.scanDelegate?.cardIOView(self, didScanCard: info)
        }
    }
}
