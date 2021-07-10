//
//  Fuelster_OrderMapVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 26/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderMapVC: Fuelster_BaseViewController {

    
    @IBOutlet weak var locationLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let mapFrame = CGRectMake(0.0, 65.0, self.view.frame.size.width, self.view.frame.size.height-65)
        GMSServices.provideAPIKey("AIzaSyD1aspFdyfEQ0IeHm4utuCnav4KagybRiE")
        let latitude = orderModel.order?.location![kOrderLatiitude] as? Double
        let longitude = orderModel.order?.location![kOrderLongitude] as? Double

        let position = CLLocationCoordinate2D.init(latitude:latitude! , longitude:longitude! )
        
        let camera = GMSCameraPosition.cameraWithLatitude(position.latitude, longitude: position.longitude, zoom: 13)
        let mapview =  GMSMapView.mapWithFrame(mapFrame, camera: camera)
         mapview.settings.myLocationButton = true;
        
        
        let orderMarker = GMSMarker(position: position)
        orderMarker.icon = UIImage(named: "LocationMarker")
        orderMarker.map = mapview

        self.view .addSubview(mapview)
        
        String.getLocationAddressWithLatitudeAndLongitude(position.latitude, longitude: position.longitude, success: {
            (result) in
            print(result)
            dispatch_async(dispatch_get_main_queue())
            {
                let addressDictionary = result as? [NSObject:AnyObject]
                self.locationLbl.text = (addressDictionary!["Name"] as? String)! + ", " + (addressDictionary!["City"] as? String)! + ", " + (addressDictionary!["CountryCode"] as? String)!
            }
            }, failureBlock: { (error) in
                dispatch_async(dispatch_get_main_queue())
                {
                    self.locationLbl.text = "Location Not found"
                }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
