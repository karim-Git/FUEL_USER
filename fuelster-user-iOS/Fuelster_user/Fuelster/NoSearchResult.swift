//
//  NoSearchResult.swift
//  Fuelster
//
//  Created by Kareem on 22/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit

class NoSearchResult: UIView
{
    @IBOutlet weak var messageLabel: UILabel!
    
 
    func showMessage(message : String) -> Void {
         messageLabel.text = message
    }
}