//
//  CustomCellDelegate.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 29/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CustomeCellDelegate {
    
    optional func cellPreviewImageAction(cell:UITableViewCell, subview:UIImageView) -> Void
    optional func cellCreditCardAction(cell:UITableViewCell) -> Void
    optional func cellCreditCardViewButtonAction(cell:UITableViewCell) -> Void
    optional func cellVehicleDeleteButtonAction(cell:UITableViewCell) -> Void
    optional func cellCardDeleteButtonAction(cell:UITableViewCell) -> Void
    optional func cellPushButtonAction(cell:UITableViewCell) -> Void



}


@objc protocol DL_EditCellDelagte {
    
    optional func cellShouldBeginEditing(cell:UITableViewCell, subview:UIView) -> Bool
    optional func cellDidBeginEditing(cell:UITableViewCell, subview:UIView)
    optional func cellShouldEndEditing(cell:UITableViewCell, subview:UIView) -> Bool
    optional func cellDidEndEditing(cell:UITableViewCell, subview:UIView)
}
