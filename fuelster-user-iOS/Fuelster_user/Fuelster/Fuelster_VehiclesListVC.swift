//
//  Fuelster_VehiclesListVC.swift
//  Fuelster
//
//  Created by Kareem on 2016-08-22.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit
import CoreGraphics

class Fuelster_VehiclesListVC: Fuelster_BaseViewController {
    
    @IBOutlet var vehiclesTableView: UITableView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var addNewButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var noVehiclesMessageView: UIView!
    var noSearchResultsView: NoSearchResult!
    var selectedRow = -1 //Indicates selected Vechile index in array
    var searchActive = false
    var isFromMenu = false
    var deleteVehicle : Vehicle!
    @IBOutlet var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet var newVehicleButton: UIBarButtonItem!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.setBackBarButtonToView()
        if  (isFromMenu == false)
        {
        //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle =  MYVEHICLE_LIST_TITLE
            let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
            titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize18()
            self.navigationItem.titleView = titleLabel
            self.tableViewBottomConstraint.constant  = 0.0
        }
        else
        {
            //To fix the Nav title alignment issue on iPhone 6 & 6s
        let selftitle =  VEHICLE_LIST_TITLE
            let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
            titleLabel.text = selftitle
        titleLabel.font = UIFont.appRegularFontWithSize14()
            self.navigationItem.titleView = titleLabel
            self.tableViewBottomConstraint.constant  = 80.0
        }
        
        let nib = UINib(nibName: VEHICLE_LIST_CELL_NIB, bundle: nil)
        self.vehiclesTableView.registerNib(nib, forCellReuseIdentifier: VEHICLE_LIST_CELL)
         vehiclesTableView.tableFooterView = self.emptyViewToHideUnNecessaryRows()
        
        self.nextButton.hidden = !isFromMenu
        self.nextButton.backgroundColor = UIColor.clearColor()
        self.nextButton.enabled = false

        self.noVehiclesMessageView.hidden = true
        self.navigationItem.rightBarButtonItems = [newVehicleButton,searchButton]
        self.nextButton.addTarget(self, action: #selector(nextButtonaction(_:)), forControlEvents: .TouchUpInside)
        topConstraint.constant = -44
        
        self.addNewButton.applyPrimaryTheme()
        noSearchResultsView = self.addNoDataMessageView(kNoSearchResults)
        self.addTableFooterView()
        
        self.vehiclesTableView.separatorColor = UIColor.clearColor()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.logFlurryEvent(kFlurryVehiclesList)
        self.addTableFooterView()
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedRow = -1
        self.nextButton.hidden = !isFromMenu
        self.nextButton.enabled = false

        self.view .initHudView(.Indeterminate, message: kHudLoadingMessage)
        vehiclemModel.requestForUserVehicles({ (result) in
            debug_print(result)
            dispatch_async(dispatch_get_main_queue()) {
                
                self.view.hideHudView()
                self.loadVechilesList()
            }
            }) { (error) in
                debug_print(error)
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.loadVechilesList()
                    self.view.hideHudView()
                }
        }
    }
    
    
    func loadVechilesList()
    {
        self.vehiclesTableView.reloadData()
      
        if self.vehiclemModel.filterVehicles?.count == 0
        {
            self.noVehiclesMessageView.hidden = false
            self.vehiclesTableView.hidden = true
            self.nextButton.hidden = true
           self.navigationItem.rightBarButtonItems = nil
        }
        else
        {
            self.noVehiclesMessageView.hidden = true
            self.vehiclesTableView.hidden = false
            self.navigationItem.rightBarButtonItems = [newVehicleButton,searchButton]
            self.nextButton.hidden = !isFromMenu
        }
    }
    
    
    func addTableFooterView()
    {
        if  isFromMenu
        {
            let myCustomView: UIImageView = UIImageView()
            let myImage: UIImage = UIImage(named: ILLUSTRATION_IMAGE)!
            myCustomView.image = myImage
            myCustomView.contentMode = .ScaleAspectFit
            myCustomView.backgroundColor = UIColor.whiteColor()
            myCustomView.frame = CGRectMake(0, 0, self.view.frame.size.width, 80)
            vehiclesTableView.tableHeaderView = myCustomView
        }
      
    }
    
    
    func nextButtonaction(sender: AnyObject) -> Void {
        
       if (checkSelectedVehicleContainsCreditCardOrNot() == true)
       {
        self.pushViewControllerWithIdentifierAndStoryBoard(ORDER_FUELVC, storyBoard: MAIN_STORYBOARD)
        }
    }
    
    
    @IBAction func searchButtonAction(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = true
        self.searchBar.hidden = false
        topConstraint.constant = 5
        self.searchBar.text = ""
        self.searchBar.becomeFirstResponder()
    }
    
   
    func checkSelectedVehicleContainsCreditCardOrNot() -> Bool {
        
        if vehiclemModel.vehicle!.paymentCard.cardId == nil {
             self.loginAlertVC.presentAlertWithTitleAndMessage (kCardTitle, message:kCardAssignMessage, controller: self)
            
            return false
        }
        
        return true;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (vehiclemModel.filterVehicles?.count)!;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:Fuelster_VehicleListCell = tableView.dequeueReusableCellWithIdentifier(VEHICLE_LIST_CELL)! as! Fuelster_VehicleListCell
        let vehicle = vehiclemModel.filterVehicles![indexPath.row]
        cell.configureCell(vehicle,delegate:self)
        cell.tag = indexPath.row
        
        cell.textLabel?.textColor = UIColor.appFontColor()
        cell.textLabel?.font = UIFont.appRegularFontWithSize14()

        if  (selectedRow == indexPath.row)
        {
            cell.creditCardView.hidden = false
            cell.editButton.hidden = false
            cell.deleteButton.hidden = false
            cell.shadowView.hidden = true
            
            cell.editButton.hidden = isFromMenu
            cell.deleteButton.hidden = isFromMenu
             cell.seperaterLabel.frame = CGRect(x:5 , y:129 , width: tableView.frame.size.width-10 , height: 0.3)
           
            cell.gradient.frame = CGRectMake(0, 0, tableView.frame.size.width, 130)
            cell.gradient.hidden = false
            cell.applyPrimaryShadow()
        }
        else
        {
            cell.creditCardView.hidden = true
            cell.editButton.hidden = true
            cell.deleteButton.hidden = true
            cell.shadowView.hidden = true
             cell.seperaterLabel.frame = CGRect(x:5 , y:89 , width: tableView.frame.size.width-10 , height: 0.3)
           
            cell.gradient.frame = CGRectMake(0, 0, tableView.frame.size.width, 90)
            cell.gradient.hidden = true
            cell.resetPrimaryShadow()
        }

        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if   (selectedRow == indexPath.row)
        {
            selectedRow = -1
        }
        else
        {
            selectedRow = indexPath.row
        }
    
        tableView.reloadData()
        self.changeNextButtonStatus()
        vehiclemModel.vehicle = vehiclemModel.allVehicles![indexPath.row]
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if  (selectedRow == indexPath.row)
        {
            return 130.0;
        }
        
        return 90.0;
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myCustomView: UIImageView = UIImageView()
        let myImage: UIImage = UIImage(named: ILLUSTRATION_IMAGE)!
        myCustomView.image = myImage
        myCustomView.contentMode = .ScaleAspectFit
        myCustomView.backgroundColor = UIColor.whiteColor()
        return myCustomView
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func emptyViewToHideUnNecessaryRows() -> UIView?
    {
        let view = UIView(frame: CGRectMake(0, 0, 320, 100))
        view.backgroundColor = UIColor.clearColor()
        return view
    }

    
    //MARK: SearchBar  methods
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
      
        selectedRow = -1
        searchActive = true;
        self.changeNextButtonStatus()
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false;
        selectedRow = -1
        self.changeNextButtonStatus()
        self.navigationController?.navigationBarHidden = false
        self.searchBar.hidden = true
        searchBar.showsCancelButton = false
        topConstraint.constant = -44
        vehiclemModel.updatedFilterListBasedOnSearchText("")
        self.vehiclesTableView.reloadData()
         noSearchResultsView.hidden = true
            vehiclesTableView.hidden = false
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        vehiclemModel.updatedFilterListBasedOnSearchText(searchText)
        self.vehiclesTableView.reloadData()
        
        if ((vehiclemModel.filterVehicles?.count)! == 0)
        {
            noSearchResultsView.hidden = false
            vehiclesTableView.hidden = true
        }
        else
        {
            noSearchResultsView.hidden = true
            vehiclesTableView.hidden = false
        }
    }
    
    
    func changeNextButtonStatus()
    {

        if  (selectedRow == -1)
        {
            self.nextButton.enabled = false
        }
        else
        {
            self.nextButton.enabled = true
        }
    }
    
    //MARK: Button actions
    @IBAction func addNewVehicleButtonTapped(sender: UIButton) {
        self.pushViewControllerWithIdentifierAndStoryBoard(VEHICLE_ADDVC, storyBoard: VEHICLE_STORYBOARD)
    }
    
    
    //MARK: Custom Cell Delegate methods
   func cellPreviewImageAction(cell:UITableViewCell, subview:UIImageView) -> Void
   {
    vehiclemModel.vehicle = vehiclemModel.filterVehicles![cell.tag]
    if vehiclemModel.vehicle?.vehiclePicture != nil {
        self.view.showImagePreviewWithURL(NSURL.init(string: (vehiclemModel.vehicle?.vehiclePicture)!)!,infoText:  "License Plate: " + vehiclemModel.vehicle!.vehicleNumber!)
    }
    else
    {
        let cvvImage = UIImage(named: "Car_Orange")!
         self.view .showImagePreview(cvvImage,infoText: "License Plate: " + vehiclemModel.vehicle!.vehicleNumber!)
    }
    

   }
    
    
    func cellCreditCardAction(cell:UITableViewCell) -> Void
    {
        vehiclemModel.vehicle = vehiclemModel.filterVehicles![cell.tag]
        let vc : Fuelster_AddNewVehicle = (self.getViewControllerWithIdentifierAndStoryBoard(VEHICLE_ADDVC, storyBoard: VEHICLE_STORYBOARD) as? Fuelster_AddNewVehicle)!
        vc.selectedVehicle = vehiclemModel.vehicle!
        vc.editVehicle = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func cellCreditCardViewButtonAction(cell:UITableViewCell) -> Void
    {
        vehiclemModel.vehicle = vehiclemModel.filterVehicles![cell.tag]
        let vc : ViewCardVC = (self.getViewControllerWithIdentifierAndStoryBoard(VIEWCARDVC, storyBoard: PAYMENTCARDSTORYBOARD) as? ViewCardVC)!
        vc.selectedVehcile = vehiclemModel.vehicle
        vc.selectedCard = vehiclemModel.vehicle?.paymentCard
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
    func cellVehicleDeleteButtonAction(cell: UITableViewCell)
    {
        self.logFlurryEvent(kFlurryDeleteVehicle)
        self.deleteVehicle = vehiclemModel.filterVehicles![cell.tag]
        debug_print(self.deleteVehicle.title)
        showConfirmDeleteAction()
    }
    
    
    func deleteVehicleAPI(vehicleToDelete: Vehicle)
    {
        logFlurryEvent(kFlurryDeleteVehicle)
        vehiclemModel.requestForDeleteVehcile(vehicleToDelete, success: { (result) in
          
            debug_print(result)
            dispatch_async(dispatch_get_main_queue()) {
                
                self.showAlertActionWithMessage(kVehicleDeleteMessage)
                self.viewWillAppear(true)
            }
            
        }) { (error) in
            debug_print(error)
            dispatch_async(dispatch_get_main_queue()) {
                 self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
            }
        }
    }
    
    
    func showAlertActionWithMessage(message : String) -> Void
    {
         self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:message, controller: self)
    }
    
    
    func showConfirmDeleteAction()  {
        let actionsArr:[()->()] = [{
            _ in
            
            },{
                self.deleteVehicleAPI(self.deleteVehicle)
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: [kAlertCancel,kAlertDelete], controller: self, message: kDeleteSureMessage)
    }
}
