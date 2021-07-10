//
//  LoadingCell.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 15/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
