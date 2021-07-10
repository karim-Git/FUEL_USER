//
//  Fuelster_AboutUsVC.swift
//  Fuelster
//
//  Created by Kareem on 27/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_AboutUsVC: UIViewController {

    
    override func viewDidLoad() {
        
       
    }
    override func viewWillAppear(animated: Bool) {
        
        let textView: DisplayTextView = DisplayTextView.init(frame: CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 20))
        textView.text = kFuelsterAboutUsMessage
        textView.editable = false
        textView.font = UIFont.appRegularFontWithSize18()
        textView.textColor = UIColor.appLightFontColor()
        self.view.addSubview(textView)
        
 
    }
}
