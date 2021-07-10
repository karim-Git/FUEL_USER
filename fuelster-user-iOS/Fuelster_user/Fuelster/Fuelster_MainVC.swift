//
//  Fuelster_MainVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 19/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_MainVC: Fuelster_BaseViewController {
    var sliderVC : UIViewController!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var locationTF: UITextField!
    var mapView :GoogleMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.applyNavigationBarUI()
        self.addImageOnNavBar()
        
        self.gettingAllVehcilesAndCards()

        sliderVC = self.slideMenuController()
        sliderVC.title = VEHICLE_LIST_TITLE
        let titleView = UIImageView.init(frame:CGRectMake(self.view.center.x-37.5,0.0,40,40))
        titleView.image =  UIImage.init(named: FUELSTER_SMALL_LOGO)
        titleView.contentMode = .ScaleAspectFit
        sliderVC.navigationItem.titleView = titleView
        sliderVC.navigationItem.rightBarButtonItem = nil

        self.mapView = GoogleMapView.sharedInsatnceWithMapViewDelegate(self)
       // let googleMap = self.mapView.googleMapView()

        mapView.addObserver(self, forKeyPath: MYLOCATIONKEYPATH,
                        options: NSKeyValueObservingOptions.New, context:nil)

        let yOrigin = locationTF.frame.origin.y+20
        let mapFrame = CGRectMake(0.0, yOrigin, self.view.frame.size.width, self.view.frame.size.height-100)
        mapView .addMapViewWithFrame(mapFrame, superView: self.view)
        mapView.mapView .settings.myLocationButton = true;

        locationTF.text = mapView.myLocationAddress
        locationTF.addLeftView(CAR_GRAY_IMAGE)
        self.view.bringSubviewToFront(self.nextButton)
        nextButton.applyPrimaryShadow()

    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.addImageOnNavBar()
        self.gettingAllVehcilesAndCards()
    }
    
    func addImageOnNavBar()
    {
        sliderVC = self.slideMenuController()
        sliderVC.title = VEHICLE_LIST_TITLE
        let titleView = UIImageView.init(frame:CGRectMake(self.view.center.x-37.5,0.0,40,40))
        titleView.image =  UIImage.init(named: FUELSTER_SMALL_LOGO)
        titleView.contentMode = .ScaleAspectFit
        sliderVC.navigationItem.titleView = titleView
    }
    
    //Navigation Bars UI
    func applyNavigationBarUI()
    {
        //White navigation bar
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        let navigationBar = navigationController!.navigationBar
        navigationBar.tintColor = UIColor.appFontColor()
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.backgroundColor = UIColor.whiteColor()
        
        //White Status bar
        navigationBar.clipsToBounds = false
        let statusBarLabel = UILabel(frame: CGRect(x: 0, y: -20, width: self.view.frame.size.width , height: 20))
        statusBarLabel.backgroundColor = UIColor.whiteColor()
        navigationBar.addSubview(statusBarLabel)
        
        //Seperater color
        let seperaterLabel = UILabel(frame: CGRect(x: 0, y:navigationBar.frame.size.height-0.2 , width: self.view.frame.size.width , height: 0.2))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
        navigationBar.addSubview(seperaterLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gettingAllVehcilesAndCards()  {
        
        
        //Getting All orders
         orderModel.requestForUserOrderListWithStatus(nil, success: {
            (result) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.removeAllMarkers()
                    self.showPendingOrders()
                }
            }) {
                (error) in
                
        }
        // Getting All vechiles
        vehiclemModel.requestForUserVehicles({ (result) in
            //  debug_print("vehicle main --->" + (result as! String))
        }) { (error) in
            debug_print(error)
        }
        
        // Getting All Cards
        cardModel.requestForUserCards({ (result) in
            
            // debug_print("card main --->" + (result as! String))
            
        }) { (error) in
            debug_print(error)
        }
    }
    
    
    func showPendingOrders() -> Void {
        
        
        for order: Order in self.orderModel.pendingOrders! {
            let marker = GMSMarker()
            let orderlatitude = Double((order.location![kLocationLattitude] as? NSNumber)!)
            let orderlongitude = Double((order.location![kLocationLongitude] as? NSNumber)!)
            let orderLocation = CLLocationCoordinate2D.init(latitude:orderlatitude , longitude: orderlongitude)
            marker.userData = order
            marker.position = orderLocation
            marker.map = self.mapView.googleMapView()
            marker.draggable = false
            marker.tracksInfoWindowChanges = true
            marker.icon = UIImage(named: CAR_ORANGE_DOUBLE)
            marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
            self.mapView.allMarkers .addObject(marker)
          //  GoogleMapView.sharedInsatnce().fullAddress(for: marker.position, with: marker)
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarkerOrder marker: GMSMarker) -> Bool {
        self.orderModel.order = marker.userData as? Order
        sliderVC.pushViewControllerWithIdentifier(ORDER_DETAILVC)
        return true
    }

    
    @IBAction func nextButtonAction(sender: AnyObject) {
        
         if self.mapView.locManager.currentLocation == nil {
            let actionsArr:[()->()] = [{
                _ in
                self.mapView.locManager.start()
                }]
            self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: [kAlertRefresh], controller: self, message: kLocationNotFoundMessage)
            return
        }
        orderModel.orderLatitude = self.mapView.myLocationMarker.position.latitude
        orderModel.orderLongitude = self.mapView.myLocationMarker.position.longitude

        let latitude: String? = String(orderModel.orderLatitude)
        let longitude :String? = String(orderModel.orderLongitude)
        if latitude == nil && longitude == nil {
            
            let actionsArr:[()->()] = [{
                _ in
                    self.mapView.locManager.start()
                }]
            self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: [kAlertRefresh], controller: self, message: kLocationNotFoundMessage)
            return
        }
        
       let vehcilVC =  self.getViewControllerWithIdentifierAndStoryBoard(VEHICLEVC, storyBoard: VEHICLE_STORYBOARD) as! Fuelster_VehiclesListVC
        vehcilVC.isFromMenu = true
        self.navigationController?.pushViewController(vehcilVC, animated: true)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == MYLOCATIONKEYPATH {
            locationTF.text = change![KVONEWVALUEKEY] as? String
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
     deinit {
            self.mapView.removeObserver(self, forKeyPath:MYLOCATIONKEYPATH)
    }

}
