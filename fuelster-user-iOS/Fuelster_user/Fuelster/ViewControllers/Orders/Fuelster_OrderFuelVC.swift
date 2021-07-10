//
//  Fuelster_OrderFuelVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 30/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderFuelVC: Fuelster_BaseViewController,UITableViewDelegate,UITableViewDataSource
{

    //Main view subviews
    @IBOutlet weak var fuelSlider: UISlider!
    @IBOutlet weak var processingView: UIView!
    @IBOutlet weak var orderDeclinedView: UIView!
    @IBOutlet weak var orderConfirmationView: UIView!
    @IBOutlet weak var estimatedPriceLbl: UILabel!
    @IBOutlet weak var estimatedDeliveryLbl: UILabel!
    @IBOutlet weak var helpTextView: UITextView!
    @IBOutlet weak var fuelTypeBtn: UIButton!
    @IBOutlet weak var pricePerGallonLbl: UILabel!
    
    @IBOutlet weak var sliderValuesView: UIView!
    @IBOutlet weak var fillMyTankCheckmarkButton: UIButton!


    //Order DeclinedView subviews
    @IBOutlet weak var fuelQuantityLbl: UILabel!
    @IBOutlet weak var confirmOrderBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var processingImg: UIImageView!
    
    //Order COnfirmation View subviews
    @IBOutlet weak var orderConfirmationLbl: UILabel!
    @IBOutlet weak var orderEstimatedLbl: UILabel!
    @IBOutlet weak var orderVehicleLbl: UILabel!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var trackOrderBtn: UIButton!
    
    @IBOutlet weak var makeAnotherOrderBtn: UIButton!
    
    @IBOutlet weak var orderDeclinedLbl: UILabel!
    var fuelTypeStr = ""
    var fuelQuantity:Int = 0
    var fuelPrice:Float = 10.0
    var fuelTypesArray : NSMutableArray!
    var popupTblView : UITableView!
    var popup : RBAPopup!
    let locManager = O1LocationManager.sharedInstance()
    var truckId = ""
    var pricePerGallon = 0
    
    var finalFuelQty = "0.0"
    var finalPrice = ""
    var isFillTank = false
    var estimatedStartTime = ""
    var estimatedEndTime = ""

    @IBOutlet weak var orderMaxLimitLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add Slider values
        addSliderValues()
        
        // Do any additional setup after loading the view.
        locManager.start()
        fuelSlider.setThumbImage(UIImage(named: "SliderHandle")!, forState: .Normal)
        self.fuelQuantity = Int(fuelSlider.value)
        self.finalFuelQty = String(self.fuelQuantity)
        
        fuelTypeBtn.backgroundColor = UIColor.getTextFieldPrimaryBackgroundColor()
        fuelTypeBtn.layer.cornerRadius = 5;
        fuelTypeBtn.layer.masksToBounds = true

      /*  let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedText = NSAttributedString(string: makeAnotherOrderBtn.currentTitle!, attributes: attributes)
        makeAnotherOrderBtn.titleLabel?.attributedText = attributedText*/
        makeAnotherOrderBtn.addUnderLine()
        
        
        let latitude = String(orderModel.orderLatitude)
        let longitude = String(orderModel.orderLongitude)

        self.view.initHudView(.Indeterminate, message: "Getting nearest truck details...")
        let locationInfo: [NSObject:AnyObject] = [kLocation:[kLocationLattitude:latitude,kLocationLongitude:longitude],kFuelType:(vehiclemModel.vehicle?.fuel)!]
        orderModel.requestForOrderEstimatedTime(locationInfo, success: { (result) in
            
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.hideHudView()
                    let result = (result["result"] as? [NSObject:AnyObject])
                    self.fuelPrice = Float((result!["pricePerGallon"] as? String)!)!
                    self.pricePerGallonLbl.text = "Price/Gallon: $\(self.fuelPrice)"
                    self.finalPrice = NSString.localizedStringWithFormat("%.2f",self.fuelPrice*Float(self.fuelQuantity)) as String

                    self.pricePerGallonLbl.attributedText = self.pricePerGallonLbl.text!.getBoldAttributeStringWithBoldFont(UIFont.appBoldFontWithSize12(),normalFont: UIFont.appRegularFontWithSize12())

                    self.estimatedPriceLbl.text = "$\(self.fuelPrice*Float(self.fuelQuantity))"
                    
                     self.estimatedStartTime = (result!["estimatedTimeStart"]! as? String )!
                     self.estimatedEndTime = (result!["estimatedTimeEnd"]! as? String )!

                    let startTime  = self.estimatedStartTime.getStringFromParseTime()
                    let startAM = self.estimatedEndTime.getStringFromParseAMPM()
                    let endTime = (result!["estimatedTimeEnd"]! as? String )!.getStringFromParseTime()
                    let endAM = (result!["estimatedTimeEnd"]! as? String )!.getStringFromParseAMPM()
                    
                    let estimatedStart = startTime! + " " + startAM!
                    let estimatedEnd = endTime! + " " + endAM!
                    
                    let timeString: NSString = estimatedStart + " - " + estimatedEnd
                    self.estimatedDeliveryLbl.attributedText = timeString.getBoldAttributeStringWithBoldFont(UIFont.appBoldFontWithSize13(),normalFont: UIFont.appRegularFontWithSize8())

                    //self.estimatedDeliveryLbl.text = result!["estimatedTime"]! as? String
                   // self.estimatedDeliveryLbl.attributedText = self.estimatedDeliveryLbl.text!.getBoldAttributeStringWithBoldFont(UIFont.appBoldFontWithSize13(),normalFont: UIFont.appRegularFontWithSize10())
                    self.truckId = result!["truck"]! as! String
            }
            
            }) { (error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.hideHudView()
                    self.loginAlertVC.presentAlertWithActions([{
                        _ in
                        self.navigationController?.popViewControllerAnimated(true)}], buttonTitles: ["Ok"], controller: self, message: error.localizedDescription)
                }
        }
        
        fuelSlider.createSliderGradient()
        fuelSlider.setMinimumTrackImage(fuelSlider.createSliderGradient(), forState: .Normal)
        confirmOrderBtn.applyPrimaryShadow()
        trackOrderBtn.applyPrimaryShadow()
        retryBtn.applyPrimaryShadow()
        cancelOrderBtn.applyPlainStyle()
        
        fuelTypesArray = NSMutableArray()
        fuelTypesArray.addObject("80C")
        fuelTypesArray.addObject("80S")
        fuelTypesArray.addObject("80T")
        
        self.fuelTypeBtn .setTitle(MakeModelJSON.sharedInstance.getFuelDisplayNameWithFuelNumber((vehiclemModel.vehicle?.fuel!)!), forState: .Normal)
        
        fillMyTankCheckmarkButton.backgroundColor = UIColor.whiteColor()
        fillMyTankCheckmarkButton.layer.cornerRadius = fillMyTankCheckmarkButton.frame.size.width/2
        fillMyTankCheckmarkButton.layer.borderColor = UIColor.appGreenTextColor().CGColor
        fillMyTankCheckmarkButton.layer.borderWidth = 3
        fillMyTankCheckmarkButton.layer.masksToBounds = true
        
    }

    override func viewDidAppear(animated: Bool) {
         updateSliderFrames()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
    }
    
    
    func showPopUp(view:UIView) -> Void
    {
        if popupTblView == nil
        {
            let frame = CGRectMake(0, 0, view.frame.size.width, 150)
            popupTblView = UITableView.init(frame: frame)
            popupTblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            popupTblView.delegate = self
            popupTblView.dataSource = self
        }
        
        let frame = CGRectMake(0, 0, view.frame.size.width, 150)
        popupTblView.frame = frame
        self.view.endEditing(true)
        popupTblView.reloadData()
        popup = RBAPopup.init(customView: popupTblView)
        popup.presentPointingAtView(view, inView: self.view, animated: true)
    }

    @IBAction func closeButtonAction(sender: AnyObject) {
        let superView = (sender as! UIButton).superview
        
        self.showOrderStatusView(superView!,show: false)
        superView!.sendSubviewToBack(self.view)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func infoButtonAction(sender: AnyObject)
    {
        
    }
    
    @IBAction func fillMyTankCheckmarkButton(sender: AnyObject)
    {
        if (isFillTank)
        {
            isFillTank = false
            sender.setBackgroundImage(UIImage.init(named: "unselect"), forState: UIControlState.Normal)
        }
        else
        {
            isFillTank = true
            sender.setBackgroundImage(UIImage.init(named: "Confirm"), forState: UIControlState.Normal)
        }
        updateUIRegadingFullTank()

    }


    @IBAction func sliderValueChangedAction(sender: AnyObject) {
        
//        var myMinValue: CGFloat = 10.0
//        // should be a global variable
//        if slider.value < myMinValue {
//            slider.value = myMinValue
//        }

        
         self.setMaxLimitToFuel()
    }

    
    @IBAction func fuelTypeButtonAction(sender: AnyObject)
    {
        showPopUp(sender as! UIView)
    }
    
    //MARK: ----- FILL MY TANK
    @IBAction func fillFullTankTapped(sender: UIButton)
    {
        if (isFillTank)
        {
            isFillTank = false
            sender.setImage(UIImage.init(named: "unselect"), forState: UIControlState.Normal)
        }
        else
        {
            isFillTank = true
            sender.setImage(UIImage.init(named: "select"), forState: UIControlState.Normal)
        }
        updateUIRegadingFullTank()
    }
    
    func updateUIRegadingFullTank()
    {
        if (isFillTank)
        {
            fuelSlider.enabled = false
            fuelSlider.value = 5.0
            self.estimatedPriceLbl.text = "$100.00"
            self.orderMaxLimitLbl.hidden = false
            let maxFuelQuantity = NSString.localizedStringWithFormat("%.2f",100.0/self.fuelPrice)//
            
            self.orderMaxLimitLbl.text = NSString.localizedStringWithFormat("Order has reached to max $ 100 (%@ gallons)",maxFuelQuantity) as String
            self.fuelQuantity =  Int( 100.0/self.fuelPrice)
            self.finalFuelQty = maxFuelQuantity as String
            self.finalPrice = "100"
            
            self.fuelQuantityLbl.text = "\(fuelQuantity)"
            
        }
        else
        {
            fuelSlider.enabled = true
            self.orderMaxLimitLbl.hidden = true
            
            fuelQuantity = Int(fuelSlider.value)
            finalFuelQty = String(self.fuelQuantity)//NSString.localizedStringWithFormat("%.2f",self.fuelQuantity) as String
            self.fuelQuantityLbl.text = String(fuelQuantity)
            debug_print(fuelQuantity)
            self.estimatedPriceLbl.text = "$\(fuelPrice*Float(fuelQuantity))"
            self.finalPrice = NSString.localizedStringWithFormat("%.2f",fuelPrice*Float(fuelQuantity)) as String
        }
    }
    
    func setMaxLimitToFuel()
    {
        debug_print(finalFuelQty)
        
            self.orderMaxLimitLbl.hidden = true

            fuelQuantity = Int(fuelSlider.value)
            finalFuelQty = String(self.fuelQuantity)//NSString.localizedStringWithFormat("%.2f",self.fuelQuantity) as String
            self.fuelQuantityLbl.text = String(fuelQuantity)
            debug_print(fuelQuantity)
            self.estimatedPriceLbl.text = "$\(fuelPrice*Float(fuelQuantity))"
            self.finalPrice = NSString.localizedStringWithFormat("%.2f",fuelPrice*Float(fuelQuantity)) as String

        if(  self.fuelPrice*Float(self.fuelQuantity) >= 100 ) //Price label
        {
            self.estimatedPriceLbl.text = "$100.00"
            self.orderMaxLimitLbl.hidden = false
            let maxFuelQuantity = NSString.localizedStringWithFormat("%.2f",100.0/self.fuelPrice)//
            
            self.orderMaxLimitLbl.text = NSString.localizedStringWithFormat("Order has reached to max $ 100 (%@ gallons)",maxFuelQuantity) as String
            self.fuelQuantity =  Int( 100.0/self.fuelPrice)
            self.finalFuelQty = maxFuelQuantity as String
             self.finalPrice = "100"

            self.fuelQuantityLbl.text = "\(fuelQuantity)"
        }
    }
    
    
    @IBAction func confirmOrderButtonAction(sender: AnyObject) {
        
        //self.setMaxLimitToFuel()
        helpTextView.resignFirstResponder()
        if self.truckId.characters.count==0
        {
         //   self.loginAlertVC.presentAlertWithMessage("There is no service info for this location.Please try agian later.", controller: self)
            
                 self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:"There is no service info for this location.Please try agian later.", controller: self)
            
            return
        }
        logFlurryEvent("Confirm order")
        self.createOrder()
    }
    
    
    func createOrder() -> Void
    {
        
        print(self.finalFuelQty)
        
        debug_print("Order Confimred")
        debug_print(self.finalPrice)
        
        
         // self.truckId = "57f4e8659d3a91246c8e7565"
       // self.estimatedStartTime = (result!["estimatedTimeStart"]! as? String )!
        //self.estimatedEndTime = (result!["estimatedTimeEnd"]! as? String )!

        let latitude = String(orderModel.orderLatitude)
        let longitude = String(orderModel.orderLongitude)
        
        let newOrder =  self.orderModel.requestForCreateOrderBody([self.estimatedStartTime,self.estimatedEndTime,(self.vehiclemModel.vehicle?.fuel)!,self.finalFuelQty,self.finalPrice,self.truckId,String(self.fuelPrice),self.estimatedDeliveryLbl.text!], location: [latitude,longitude], user: [self.userModel.userInfo![kUserId]!,self.userModel.userInfo![kUserFirstName]!,self.userModel.userInfo![kUserLastName]!], vehicle: [(self.vehiclemModel.vehicle?.vehicleId)!,(self.vehiclemModel.vehicle?.paymentCard.cardId)!])
        self.showOrderStatusView(self.processingView,show: true)
        self.view.bringSubviewToFront(self.processingView)
        self.startAnimation()
        self.orderModel.requestForNewOrderForUser(newOrder, success: { (result) in
            dispatch_async(dispatch_get_main_queue()) {
                self.stopAnimation()
                self.showOrderStatusView(self.processingView,show: false)
                self.processingView.sendSubviewToBack(self.view)
                self.showOrderStatusView(self.orderConfirmationView,show: true)
                let vehicleTitle = (self.vehiclemModel.vehicle?.title!)
                let vehicleMake = (self.vehiclemModel.vehicle?.make!)
                let vehicleModel = (self.vehiclemModel.vehicle?.model!)
                
                self.orderConfirmationLbl.text = "Your order for \(vehicleTitle!) is on the way!Click on Track Order for more information"
                self.orderVehicleLbl.text = "\(vehicleTitle!) - \(vehicleMake!) \(vehicleModel!)"
                self.orderEstimatedLbl.text = "Estimated Price - \(self.estimatedPriceLbl.text!)"
                self.orderEstimatedLbl.attributedText = self.orderEstimatedLbl.text!.getBoldAttributeString()
                print(result)
                self.view.bringSubviewToFront(self.orderConfirmationView)
            }
            
        }) { (error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.stopAnimation()
                self.showOrderStatusView(self.processingView,show: false)
                self.processingView.sendSubviewToBack(self.view)
                self.orderDeclinedLbl.text = error.localizedDescription
                self.showOrderStatusView(self.orderDeclinedView,show: true)
                self.view.bringSubviewToFront(self.orderDeclinedView)
            }
        }
        
    }
    
    func startAnimation() -> Void {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Int(M_PI * 2.0 * 1)
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
        self.processingImg.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
    }
    
    func stopAnimation() -> Void {
        self.processingImg.layer.removeAllAnimations()
    }
    
    
    func showOrderStatusView(statusView:UIView,show:Bool) -> Void {
        
        statusView.hidden = !show
        self.navigationController?.navigationBarHidden = show
    }
    
    
    @IBAction func makeAnotherOrderButtonAction(sender: AnyObject) {
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func orderRetryButtonAction(sender: AnyObject) {
        
        self.showOrderStatusView(self.orderDeclinedView,show: false)
        self.orderDeclinedView.sendSubviewToBack(self.view)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    @IBAction func TrackOrderButtonAction(sender: AnyObject) {
        self.showOrderStatusView(self.orderConfirmationView,show: false)
        self.orderConfirmationView.sendSubviewToBack(self.view)
        self.navigationController?.navigationBarHidden = false
        self.pushViewControllerWithIdentifier(ORDER_DETAILVC)

    }
    
    
    @IBAction func cancelOrderButtonAction(sender: AnyObject) {
        
        let actionsArr:[()->()] = [{
            _ in
            if let cancelView = NSBundle.mainBundle().loadNibNamed("OrderCancellationView", owner: self, options: nil).first as? OrderCancellationView
            {
                cancelView.parentVC = self
                cancelView.frame = self.view.frame
                self.orderConfirmationView.addSubview(cancelView)
                self.orderConfirmationView.bringSubviewToFront(cancelView)
            }

            },{
            _ in
                
            }]
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles:["Cancel","No"], controller: self, message: "Are you sure you want to cancel the order?")
    }
    
    
    override func cancelOrder(cancelReason:String) -> Void {
        
        self.view.initHudView(.Indeterminate, message: "Cancelling Order...")

        orderModel.requestForUpdateOrder(["status":OrderStatusCancelled,"_id":(self.orderModel.order?.orderId)!,"cancelReason":cancelReason], success: { (result) in
            debug_print(result)
            dispatch_async(dispatch_get_main_queue()) {
                self.view.hideHudView()
                self.showOrderStatusView(self.orderConfirmationView,show: false)
                self.orderConfirmationView.sendSubviewToBack(self.view)
                self.loginAlertVC.presentAlertWithActions([{
                    _ in
                    self.navigationController?.popViewControllerAnimated(true)}], buttonTitles: ["Ok"], controller: self, message: "Order cancelled successfully.")
            }

            }) { (error) in
                debug_print(error)
                dispatch_async(dispatch_get_main_queue()) {
                    self.view.hideHudView()
                    //self.loginAlertVC.presentAlertWithMessage(error.localizedDescription, controller: self)
                    
                    self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)

                    return
                }

        }
    }
    
    //MARK: UITableView Delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return fuelTypesArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.textColor = UIColor.appFontColor()
        cell.textLabel?.font = UIFont.appRegularFontWithSize14()
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        fuelTypeBtn.setTitle(fuelTypesArray[indexPath.row] as? String, forState: .Normal)
    }
    
    
    func emptyViewToHideUnNecessaryRows() -> UIView?
    {
        //Return this clear color view for footer
        let view = UIView(frame: CGRectMake(0, 0, 320, 100))
        view.backgroundColor = UIColor.clearColor()
        return view
    }

    
    func addSliderValues()
    {
        let view: UIView = sliderValuesView
        
        let data1: [Float] = [5, 10, 15 , 20, 25]
        
        var x : CGFloat = 0
        let y : CGFloat = 0
        let width : CGFloat = view.frame.size.width/4.0
        let height : CGFloat = view.frame.size.height
        for data in data1 {
            let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
            label.text = "\(Int(data))"
            label.font = UIFont.appRegularFontWithSize12()
            label.textColor = UIColor.appFontColor()
            label.textAlignment = .Left
            view.addSubview(label)
            x = x + width
        }
        
    }
    
    func updateSliderFrames()  {
       
        let view: UIView = sliderValuesView
        
        var x : CGFloat = 0
        let y : CGFloat = 0
        
        let width : CGFloat = view.frame.size.width/4.0
        let height : CGFloat = view.frame.size.height
        
        for subview in view.subviews {
            
            let label = subview as! UILabel
            label.frame = CGRect(x: x, y: y, width: width, height: height)
            x = x + width
        }
    }
    
    deinit {
        
    }

}
