//
//  Fuelster_MainNavigationVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_MainNavigationVC: UINavigationController,SlideMenuControllerDelegate {

    var sliderVC = SlideMenuController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.interactivePopGestureRecognizer?.enabled = false
         let mainVC = self.getViewControllerWithIdentifier(MAINVC)
         let leftVC = self.getViewControllerWithIdentifier(MENUVC)
         sliderVC = SlideMenuController.init(mainViewController: mainVC, leftMenuViewController: leftVC)
         sliderVC.delegate = self
         sliderVC.addLeftBarButtonWithImage(UIImage(named: MENU_SMALL_IMAGE)!)
         leftVC.view.layer.cornerRadius = 0.5
         self.setViewControllers([sliderVC], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Slider Deleagte methods
     func rightWillOpen()
    {
        self.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 121/255, green: 121/255, blue: 119/255, alpha: 1.0)
    }
     func rightDidOpen()
    {
        
    }
     func rightWillClose()
    {
    }
     func rightDidClose()
    {
        self.navigationBar.barTintColor = UIColor.whiteColor()
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
