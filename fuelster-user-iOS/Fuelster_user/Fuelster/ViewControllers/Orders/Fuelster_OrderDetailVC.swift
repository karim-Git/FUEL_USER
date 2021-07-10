//
//  Fuelster_OrderDetailVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 06/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderDetailVC: Fuelster_BaseViewController {

    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet weak var orderDetailView: UIView!
    @IBOutlet weak var orderDriverView: UIView!
    
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var orderBottomView: UIView!
    @IBOutlet weak var operatorViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orderplacedTimeLbl: DateTimeLabel!
    @IBOutlet weak var orderPlacedStatusLbl: UILabel!
    @IBOutlet weak var orderPlacedLine: UIView!
    @IBOutlet weak var orderPlacedStatusView: UIImageView!
    
    @IBOutlet weak var orderConfimedTimeLbl: DateTimeLabel!
    @IBOutlet weak var orderConfimedStatusLbl: UILabel!
    @IBOutlet weak var orderConfimedLine: UIView!
    @IBOutlet weak var orderConfimedStatusView: UIImageView!

    @IBOutlet weak var orderCancellationReason: UILabel!
    @IBOutlet weak var orderEnrouteStatusLbl: UILabel!
    @IBOutlet weak var orderEnrouteLine: UIView!
    @IBOutlet weak var orderEnrouteStatusView: UIImageView!

    @IBOutlet weak var orderDeliveredTimeLbl: DateTimeLabel!
    @IBOutlet weak var orderDeliveredStatusLbl: UILabel!
    @IBOutlet weak var orderDeliveredLine: UIView!
    @IBOutlet weak var orderDeliveredStatusView: UIImageView!

    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var driverVehicleLbl: UILabel!
    @IBOutlet weak var driverNameLbl: UILabel!

    @IBOutlet weak var waitingLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    var cancelView : OrderCancellationView!
    
    @IBOutlet var refreshBtn: UIBarButtonItem!
    
    func notificationMethod()
    {
        self.refreshOrder(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationMethod), name:ORDER_REFRESH_NOTIFICATION, object: nil)
        self.navigationItem.rightBarButtonItem = refreshBtn
        self.orderBottomView.bringSubviewToFront(self.callBtn)
        
        // Setting Left button item
        //MARK:---- Navigation back
        
            let backItem = UIBarButtonItem.init(image: UIImage.init(named: NAVIGATION_BACK_IMAGE), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backToPopView))
            self.navigationItem.leftBarButtonItem = backItem
       
        
      
        if let statusView = NSBundle.mainBundle().loadNibNamed("Fuelster_OrderStatusView", owner: self, options: nil).first as? Fuelster_OrderStatusView
        {
            statusView.frame = self.orderStatusView.bounds//CGRectMake(0.0, 0.0, self.orderStatusView.frame.size.width, self.orderStatusView.frame.size.height)
            statusView.setupOrderStatus(self.orderModel.order!)
            self.orderStatusView.addSubview(statusView)
        }
        
        if let detailView = NSBundle.mainBundle().loadNibNamed("Fuelster_OrderDetailView", owner: self, options: nil).first as? Fuelster_OrderDetailView
        {
            detailView.frame = self.orderDetailView.bounds
            detailView.parentVC = self
            detailView.setupOrderDetails(orderModel.order!)
            self.orderDetailView.addSubview(detailView)

            self.orderDetailView.layer.cornerRadius = 15.0
            detailView.layer.cornerRadius = 15.0
        }
        
        if let driverView = NSBundle.mainBundle().loadNibNamed("Fuelster_DriverView", owner: self, options: nil).first as? Fuelster_DriverView
        {
            driverView.frame = self.orderDriverView.bounds
            self.orderDriverView.addSubview(driverView)
            self.orderDriverView.layer.cornerRadius = 15.0
            driverView.layer.cornerRadius = 15.0
            self.orderDriverView.sendSubviewToBack(driverView)
        }
        self.orderPlacedLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
       
       
        displayOrderPlaceTimeText()
        self.orderConfimedTimeLbl.updateFrames()
       
        let orderNumber = orderModel.order?.orderNumber!
        self.orderPlacedStatusLbl.text = "Order placed: \(orderNumber!)"

        self.orderPlacedStatusView.image = UIImage.init(named: "Order_Status_Blue")
        self.cancelOrderBtn.applyPlainStyle()
      
        self.setupDriverInfo()
        //Setup for Order Tracking
        if orderModel.order?.status == OrderStatusCompleted {
            self.updateOrderDeliveredStatus(true)
        }
        else
        {
            self.updateOrderDeliveredStatus(false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshOrder(_:nil)
    }

    
    deinit {
        
        NSNotificationCenter.removeObserver(self, forKeyPath: ORDER_REFRESH_NOTIFICATION)
    }
    
    
    override func backToPopView()  {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapGestureAction(sender:UIButton) -> Void {
        
        let mapVC = self.getViewControllerWithIdentifier("OrderMapVC")
        self.presentViewController(mapVC, animated: true, completion: nil)
    }
    
    
    func displayOrderPlaceTimeText() {
        let text = ((orderModel.order?.statusHistory![0])![kOrderUpdatedAt] as? String)?.getStringFromParseFullDate()
        self.orderplacedTimeLbl.updateFrames()
        self.orderplacedTimeLbl.setTimeText(text)
    }
    
    func displayOrderConfirmTimeText()
    {
        self.orderConfimedTimeLbl.hidden = false
        let text = ((orderModel.order?.statusHistory![2])![kOrderUpdatedAt] as? String)?.getStringFromParseFullDate()
         self.orderConfimedTimeLbl.initilizeSubView()
        self.orderConfimedTimeLbl.updateFrames()
        self.orderConfimedTimeLbl.setTimeText(text)
    }
    
    func displayOrderDeleveryTimeText()
    {
        self.orderDeliveredTimeLbl.hidden = false
        let text = ((orderModel.order?.statusHistory![3])![kOrderUpdatedAt] as? String)?.getStringFromParseFullDate()
        self.orderDeliveredTimeLbl.initilizeSubView()
        self.orderDeliveredTimeLbl.updateFrames()
        self.orderDeliveredTimeLbl.setTimeText(text)
    }
    
    func setupDriverInfo() ->  Void{
        
        self.driverImageView.image = UIImage.init(named: PROFILRPIC_PLACEHOLDER_IMAGE)

        self.driverNameLbl.text = (orderModel.order?.truck![kDriver] as? [NSObject:AnyObject])![kDriverFirstName] as? String
        let truckNumber = orderModel.order?.truck![kTruckNumber]! as? String
        self.driverVehicleLbl.text = "License Plate:\(truckNumber!)"
    }
    
    override func viewDidAppear(animated: Bool) {
      
        displayOrderPlaceTimeText()
    }
    func updateOrderConfirmedStatus(enable:Bool) -> Void {
        
         // if enable true order completed or confirmed
        self.updateOrderEnrouteStatus(enable)

        if enable == true {
            self.orderConfimedLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            displayOrderConfirmTimeText()
//            self.orderConfimedTimeLbl.hidden = false
//             self.orderConfimedTimeLbl.text = ((orderModel.order?.statusHistory![1])![kOrderUpdatedAt] as? String)?.getStringFromParseFullDate()
            
            if orderModel.order?.status == OrderStatusAccepted {
                self.operatorViewTopConstraint.constant = 127.0
            }

             self.orderConfimedStatusLbl.text = "Order confirmed"
             self.orderConfimedStatusView.image = UIImage.init(named: "Order_Status_Blue")
             self.waitingLbl.hidden = true
        }
        else {
            // Order can be Accpeted,Cancelled,New
            self.orderConfimedLine.backgroundColor = UIColor.lightGrayColor()
            self.orderConfimedTimeLbl.hidden = true
            self.orderConfimedStatusLbl.text = "Order yet to be confirmed"
            if orderModel.order?.status == OrderStatusNew {
                self.orderConfimedStatusView.image = UIImage.init(named: "Order_Status_Gray")
                self.operatorViewTopConstraint.constant = 84.0
            }
            else {
                //Order can be Accpeted,Cancelled
                self.orderCancellationReason.hidden = false

                self.orderBottomView.hidden = true
                var flaggedBy = orderModel.order?.flaggedBy!
                
                if flaggedBy == "Customer"  {
                    flaggedBy = "Me"
                }
                if flaggedBy == "System"  {
                    flaggedBy = "Fuelster"
                }
                if flaggedBy == "Card"  {
                    flaggedBy = "Auto cancelled. Credit/Debit card declined"
                }

                if flaggedBy == nil  {
                    flaggedBy = "Auto cancelled. Credit/Debit card declined"
                }
                self.orderCancellationReason.text = "Reason:\(orderModel.order?.cancelReason!)"
                self.orderConfimedStatusLbl.text = "Order Cancelled by \(flaggedBy!)"
                self.orderConfimedLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
                self.orderConfimedStatusView.image = UIImage.init(named: "Order_Status_Declined")
            }

            self.waitingLbl.hidden = false

        }
    }
    
    
    @IBAction func refreshOrder(sender: AnyObject?) {
        
        self.view.initHudView(.Indeterminate, message: "Refreshing...")
        orderModel.requestForOrderDetails(orderModel.order!, success: {
            (result) in
            
                dispatch_async(dispatch_get_main_queue()) {
                    self.orderModel.order?.initWithOrderInfo(result as! [NSObject : AnyObject])
                    self.view.hideHudView()
                    
                    let statusView = self.orderStatusView.subviews[0] as? Fuelster_OrderStatusView
                    statusView!.setupOrderStatus(self.orderModel.order!)

                    let detailView = self.orderDetailView.subviews[0] as? Fuelster_OrderDetailView
                    detailView!.setupOrderDetails(self.orderModel.order!)
                    self.setupDriverInfo()
                    //Setup for Order Tracking
                    if self.orderModel.order?.status == OrderStatusCompleted {
                        self.updateOrderDeliveredStatus(true)
                    }
                    else
                    {
                        self.updateOrderDeliveredStatus(false)
                    }
                   
                }
            }) { (error) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.hideHudView()

                }
        }
    }
    
    func updateOrderEnrouteStatus(enable:Bool) -> Void {
        
        // if enable true order completed, confirmed
 
        if enable == true {
            self.orderEnrouteLine.hidden = false
            self.orderEnrouteStatusLbl.hidden = false
            self.orderEnrouteStatusView.hidden = false
            self.orderEnrouteLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            self.orderEnrouteStatusLbl.text = "Fuel Enroute"
            self.orderEnrouteStatusView.image = UIImage.init(named: "Order_Status_Blue")
            self.operatorViewTopConstraint.constant = self.operatorViewTopConstraint.constant

        }
        else {
            // else order New, Cancelled
            self.orderEnrouteLine.hidden = true
            self.orderEnrouteStatusLbl.hidden = true
            self.orderEnrouteStatusView.hidden = true
            self.orderEnrouteLine.backgroundColor = UIColor.lightGrayColor()
            self.orderEnrouteStatusLbl.text = ""
            self.orderEnrouteStatusView.image = UIImage.init(named: "Order_Status_Gray")
            self.operatorViewTopConstraint.constant = 127.0//self.operatorViewTopConstraint.constant-43
        }
        if orderModel.order?.status != OrderStatusAccepted {
            self.callBtn.hidden = true
        }
        else {
            self.callBtn.hidden = false
        }
        self.orderDriverView.hidden = !enable
        self.cancelOrderBtn.hidden = enable
        
    }

    
    func updateOrderDeliveredStatus(enable:Bool) -> Void {
        
        if enable == true {
             self.orderDeliveredLine.hidden = false
             self.orderDeliveredStatusLbl.hidden = false
             self.orderDeliveredStatusView.hidden = false
             self.orderDeliveredLine.backgroundColor = UIColor.init(red: 24.0/255.0, green: 184.0/255.0, blue: 215.0/255.0, alpha: 1.0)
            // self.orderDeliveredTimeLbl.hidden = false
                displayOrderDeleveryTimeText()
             self.orderDeliveredStatusLbl.text = "Order Delivered"
             self.orderDeliveredStatusView.image = UIImage.init(named: "Order_Status_Blue")
             self.operatorViewTopConstraint.constant = 170
             self.updateOrderConfirmedStatus(true)
        }
        else {
            self.orderDeliveredLine.hidden = true
            self.orderDeliveredStatusLbl.hidden = true
            self.orderDeliveredStatusView.hidden = true

            self.orderDeliveredLine.backgroundColor = UIColor.lightGrayColor()
            self.orderDeliveredTimeLbl.hidden = true
            self.orderDeliveredStatusLbl.text = "Order yet to be confirmed"
            self.orderDeliveredStatusView.image = UIImage.init(named: "Order_Status_Gray")
            //Need to send true or false based order accepted or not
            if orderModel.order?.status == OrderStatusAccepted {
                self.updateOrderConfirmedStatus(true)
            }
            else
            {
                self.updateOrderConfirmedStatus(false)
            }

        }
        
    }

    
    @IBAction func cancelOrderButtonAction(sender: AnyObject) {
        
        
        let actionsArr:[()->()] = [{
            _ in
            if let cancelView = NSBundle.mainBundle().loadNibNamed("OrderCancellationView", owner: self, options: nil).first as? OrderCancellationView
            {
                self.cancelView = cancelView
                self.cancelView.parentVC = self
                self.cancelView.frame = self.view.frame
                self.view.addSubview(self.cancelView)
                self.view.bringSubviewToFront(self.cancelView)
                self.logFlurryEvent("Cancel Order")
            }
            
            },{
                _ in
                
            }]
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:["Cancel","No"], controller: self, message: "Are you sure you want to cancel the order?")
    }
    
    
    override func cancelOrder(cancelReason:String) -> Void {
        
        orderModel.requestForUpdateOrder(["status":OrderStatusCancelled,"_id":(self.orderModel.order?.orderId!)!,"cancelReason":cancelReason], success: { (result) in
            debug_print(result)
            dispatch_async(dispatch_get_main_queue()) {
                self.cancelView.hidden = true
                self.navigationController?.navigationBarHidden = false
                self.view.sendSubviewToBack(self.view)
                self.loginAlertVC.presentAlertWithActions([{
                    _ in
                    self.navigationController?.popViewControllerAnimated(true)}], buttonTitles: ["Ok"], controller: self, message: "Order cancelled successfully.")
            }
            
        }) { (error) in
            debug_print(error)
            dispatch_async(dispatch_get_main_queue()) {
               // self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                
                     self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
                
                return
            }
            
        }
    }


    @IBAction func callButtonAction(sender: AnyObject) {
        self.view.callContactPerson(((orderModel.order?.truck![kDriver] as? [NSObject:AnyObject])![kDriverPhone] as? String)!)
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
