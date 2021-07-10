//
//  Fuelster_OrderHistoryVC.swift
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 23/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_OrderHistoryVC: UITableViewController,CustomeCellDelegate {

    let orderModel = OrdersModel.sharedInstance
    var orderPageCount =  1
    var noOrdersFoundView: NoSearchResult!
    
    var sliderVC : UIViewController!
    @IBOutlet var refreshButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noOrdersFoundView = self.addNoDataMessageView("No orders found.")
        self.tableView.tableFooterView = self.emptyViewToHideUnNecessaryRows()

        sliderVC = self.slideMenuController()
        let nib = UINib(nibName: ORDERHISTORYCELL, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: ORDERHISTORYCELL)
        let nib1 = UINib(nibName: LOADINGCELL, bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: LOADINGCELL)
        sliderVC.navigationItem.rightBarButtonItem = refreshButton
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,65,0)
       
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.orderPageCount = 1
        self.getOrderList()
        
        //var sliderVC : UIViewController!
        sliderVC.navigationItem.titleView = nil
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle =  "Order History"
        let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
        titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
        self.navigationItem.titleView = titleLabel

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func getOrderList()->Void
   {
    self.tableView.initHudView(.Indeterminate, message: kHudLoadingMessage)
        orderModel.requestForUserOrderList(orderPageCount,success: { (result) in
            dispatch_async(dispatch_get_main_queue()) {
                 self.tableView.hideHudView()
                self.tableView.reloadData()
            }
        
        }) { (error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.hideHudView()
            }
        }

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (orderModel.allOrders?.count)! == 0{
            noOrdersFoundView.hidden = false
            return 0
        }
         noOrdersFoundView.hidden = true
        return (orderModel.allOrders?.count)!
    }

    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == (orderModel.allOrders?.count)! && orderModel.isNextPage == true{
            self.orderPageCount += 1
            self.getOrderList()
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:OrderHistoryCell = tableView.dequeueReusableCellWithIdentifier(ORDERHISTORYCELL, forIndexPath: indexPath) as! OrderHistoryCell

        let order = orderModel.allOrders![indexPath.row]
        cell.configureCell(order,_delegate:self)
        cell.tag = indexPath.row

       // cell.contentView.applyScecondaryBackGroundGradient()
        
        //cell.contentView.backgroundColor = UIColor.gradientFromColor(UIColor.whiteColor(), toColor:UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0), withHeight: 210)
        
        if order.status == OrderStatusNew {
            cell.orderStatusLbl.text = "New"
            cell.orderStatusLbl.font = UIFont.appRegularFontWithSize14()
            cell.orderStatusLbl.textColor = UIColor.blackColor()
            cell.orderStatusImgView.image = UIImage.init(named: "Order_Cancel")
            cell.orderStatusImgView.hidden = true
        }
        else if order.status == OrderStatusAccepted
        {
            cell.orderStatusLbl.font = UIFont.appRegularFontWithSize14()
            cell.orderStatusLbl.textColor = UIColor.init(red: 126.0/255.0, green: 211.0/255.0, blue: 33.0/255.0, alpha: 1)
            cell.orderStatusImgView.image = UIImage.init(named: "Confirm_Small")
            cell.orderStatusImgView.hidden = false
        }
        else if order.status == OrderStatusCancelled
        {
            cell.orderStatusLbl.font = UIFont.appRegularFontWithSize14()
            cell.orderStatusLbl.textColor = UIColor.redColor()
            cell.orderStatusImgView.image = UIImage.init(named: "Order_Cancel")
            cell.orderStatusImgView.hidden = false
        }
            
        else if order.status == OrderStatusCompleted
        {
            let price = String(order.chargedPrice!)
            cell.orderStatusLbl.text = "$\(price)"
            cell.orderStatusLbl.font = UIFont.appRegularFontWithSize18()
            cell.orderStatusLbl.textColor = UIColor.blackColor()
            cell.orderStatusImgView.image = UIImage.init(named: "Confirm_Small")
            cell.orderStatusImgView.hidden = true
        }

        return cell
    }
 
    
   override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == orderModel.allOrders?.count {
            return 40
        }
        return 230
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        self.orderModel.order = self.orderModel.allOrders![indexPath.row]
        
        //self.pushViewControllerWithIdentifier(ORDER_DETAILVC)
    }

    
    @IBAction func refreshOrderList(sender: AnyObject)
    {
        self.getOrderList()
    }
    
    
    func emptyViewToHideUnNecessaryRows() -> UIView?
    {
        //Return this clear color view for footer
        let view = UIView(frame: CGRectMake(0, 0, 320, 100))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    //MARK: CUstomCellDelegate methods
    
    func cellPushButtonAction(cell:UITableViewCell) -> Void
    {
        logFlurryEvent("Track Order")
        orderModel.order = orderModel.allOrders![cell.tag]
        self.pushViewControllerWithIdentifier(ORDER_DETAILVC)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
