//
//  Fuelster_HelpVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_HelpVC: Fuelster_BaseViewController {
    
         var scrollView: UIScrollView!
        @IBOutlet weak var webView: UIWebView!
        var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       
    }
    
    override func viewDidLayoutSubviews()
    {
        //self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.frame.origin.y+self.scrollView.frame.size.height+4050)
        
        // addButtonView.applyPrimaryTheme()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        scrollView = UIScrollView.init(frame: self.view.bounds)
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(scrollView)
        imageView = UIImageView.init(image: UIImage.init(named: HELP_IMAGE))
        imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, imageView.frame.size.height)
        imageView.contentMode = .ScaleAspectFill
        scrollView.addSubview(imageView)
        
        let image =  UIImage.init(named: HELP_IMAGE)
        let size: CGSize = (image?.size)!
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, size.height + 50)
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        var sliderVC : UIViewController!
        sliderVC = self.slideMenuController()
        sliderVC.navigationItem.titleView = nil
        sliderVC.navigationItem.rightBarButtonItem = nil

        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle = HELP_TITLE
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
