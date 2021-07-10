//
//  Fuelster_AddNewVehicle.swift
//  Fuelster
//
//  Created by Kareem on 2016-08-25.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

let MAKER_TBL = 1
let MODEL_TBL = 2
let FUELTYPE_TBL = 3
let CARD_TBL  = 4

class Fuelster_AddNewVehicle: Fuelster_BaseViewController,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet var titleTF: RBATextField!
    @IBOutlet var licenceTF: REFormattedNumberField!
    @IBOutlet var makeTF: RBATextField!
    @IBOutlet var modelTF: RBATextField!
    @IBOutlet var fuelTypeTF: RBATextField!
    @IBOutlet var creditCardTF : RBATextField!
    @IBOutlet var addButtonView: UIView!
    @IBOutlet var makeButton: UIButton!
    @IBOutlet weak var vehicleImageBtn: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    var popupTblView : UITableView!
    var popup : RBAPopup!
    
    var makeArray : [VehicleMake]? = []
    var modelsArray : [Veh_Model]? = []
    var fuelTypesArray :[Fuel]? = []
    var creditCardsArray = [Card]?()
    
    var selectedPopup  = -1
    let fieldValidator = RAFieldValidator.sharedInsatnce()
    
    var selectedVehicle = Vehicle()
    var editVehicle = false
    
    var assignedCard = Card()
    var vehicleImage : UIImage!
    var prviousImage : UIImage!
    var selectedMake = VehicleMake()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        vehicleImageBtn.imageView?.contentMode = .ScaleAspectFill
        licenceTF.format = "XXXXXXXXXXXX"
        if  editVehicle
        {
            //To fix the Nav title alignment issue on iPhone 6 & 6s
            let selftitle =  UPDATE_VEHICLE_TITLE
            let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
            titleLabel.text = selftitle
            titleLabel.font = UIFont.appRegularFontWithSize18()
            self.navigationItem.titleView = titleLabel
            
        }
        else
        {
            //To fix the Nav title alignment issue on iPhone 6 & 6s
            let selftitle =  ADD_VEHICLE_TITLE
            let titleLabel = UILabel(frame: CGRect(x: 0, y:0 , width: 0 , height: 44))
            titleLabel.text = selftitle
            titleLabel.font = UIFont.appRegularFontWithSize18()
            self.navigationItem.titleView = titleLabel
        }
        
        loadSampleData()
        
        saveButton.applyPrimaryShadow()
        fieldValidator.requiredFields = [[kValidatorField:titleTF,kValidatorFieldKey:kVehicleTitle],[kValidatorField:licenceTF,kValidatorFieldKey:kVehicleNumber],[kValidatorField:makeTF,kValidatorFieldKey:kVehicleMake],[kValidatorField:modelTF,kValidatorFieldKey:kVehicleModel],[kValidatorField:fuelTypeTF,kValidatorFieldKey:kFuelType]]
        loadVehicleDetails()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews()
    {
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.scrollView.frame.origin.y+self.scrollView.frame.size.height+150)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        fieldValidator.requiredFields = [[kValidatorField:titleTF,kValidatorFieldKey:kVehicleTitle],[kValidatorField:licenceTF,kValidatorFieldKey:kVehicleNumber],[kValidatorField:makeTF,kValidatorFieldKey:kVehicleMake],[kValidatorField:modelTF,kValidatorFieldKey:kVehicleModel],[kValidatorField:fuelTypeTF,kValidatorFieldKey:kFuelType]]
        
        self.vehicleImageBtn.layer.cornerRadius = self.vehicleImageBtn.frame.size.width/2.0
        self.vehicleImageBtn.layer.masksToBounds = true
        
        titleTF.applyTextFieldPrimaryTheme()
        licenceTF.applyTextFieldPrimaryTheme()
        makeTF.applyTextFieldPrimaryTheme()
        modelTF.applyTextFieldPrimaryTheme()
        fuelTypeTF.applyTextFieldPrimaryTheme()
        creditCardTF.applyTextFieldPrimaryTheme()
        creditCardTF.addLeftView(assignedCard.cardImageName())
        loadCreditCardDetails()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        addButtonView.layer.cornerRadius = 18.0
        addButtonView.layer.borderWidth = 1.0
        
        if (makeButton == nil)
        {
            let makeBtn = makeTF.addDropDownButton()
            makeBtn.addTarget(self, action: #selector(Fuelster_AddNewVehicle.makeButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            makeButton = makeBtn
            let modelBtn = modelTF.addDropDownButton()
            modelBtn.addTarget(self, action: #selector(Fuelster_AddNewVehicle.modelButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            let fuelTypeBtn = fuelTypeTF.addDropDownButton()
            fuelTypeBtn.addTarget(self, action: #selector(Fuelster_AddNewVehicle.fuelTypeButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            let creditCardBtn = creditCardTF.addDropDownButton()
            creditCardBtn.addTarget(self, action: #selector(Fuelster_AddNewVehicle.creditCardButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Actions
    @IBAction func cameraButtonAction(sender: AnyObject) {
        //  logFlurryEvent("Camera in Adding Or Editing Vehicle")
        let imagPicker = RBAImagePickerManager()
        imagPicker.setParent(self)
        imagPicker.showImagePicker()
    }
    
    
    @IBAction func makeButtonTapped(sender: UIButton) {
        
        if  editVehicle
        {
            return
        }
        
        selectedPopup = MAKER_TBL
        showPopUp(sender)
        
    }
    
    
    @IBAction func modelButtonTapped(sender: UIButton) {
        
        if  editVehicle
        {
            return
        }
        
        if selectedMake.makeId == nil {
            self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:kVehicleAllFields, controller: self)
            return
        }
        selectedPopup = MODEL_TBL
        showPopUp(sender)
        
    }
    
    
    @IBAction func fuelTypeButtonTapped(sender: UIButton) {
        selectedPopup = FUELTYPE_TBL
        showPopUp(sender)
    }
    
    
    @IBAction func creditCardButtonTapped(sender: UIButton) {
        
        if cardModel.allCards?.count > 0 {
            selectedPopup = CARD_TBL
            showPopUp(sender)
        }
    }
    
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        let validator = fieldValidator.validateReuiredFields()
        if (validator == nil)
        {
            if vehicleImageBtn.currentImage != nil
            {
                if editVehicle {
                    updateVehicle()
                }
                else
                {
                    self.logFlurryEvent(kFlurryAddNewVehicle)
                    createVehicle()
                }
            }
        }
        else
        {
            var alertMessage = kSignUpAllDetailsMessage
            print(validator)
            
            if validator[kValidatorField] as? RBATextField == titleTF {
                alertMessage = kVehicleTitleMessage
            }
            else if validator[kValidatorField] as? REFormattedNumberField == licenceTF {
                alertMessage = kVehicleLicensePlateMessage
            }
            else if validator[kValidatorField] as? RBATextField == makeTF {
                alertMessage = kVehicleManufacturerMessage
            }
            else if validator[kValidatorField] as? RBATextField == modelTF {
                alertMessage = kVehicleModelMessage
            }
            else if validator[kValidatorField] as? RBATextField == fuelTypeTF {
                alertMessage = kVehicleFuelTypeMessage
            }
            
            alertMessage = kVehicleAllFields
            
            self.loginAlertVC.presentAlertWithTitleAndMessage ("", message:alertMessage, controller: self)
        }
    }
    
    
    // Updating Vehicle Info with API
    func updateVehicle()
    {
        self.view .initHudView(.Indeterminate, message: kHudWaitingMessage)
        var imageObject : AnyObject
        // checking vehicle image have nill value
        if vehicleImage != nil
        {
            imageObject = UIImageJPEGRepresentation(vehicleImage!, 0.1)!
        }
        else
        {
            imageObject = ""
        }
        var cardId = ""
        
        if assignedCard.cardId != nil
        {
            cardId = assignedCard.cardId!
        }
        
        let  updateVehicle = vehiclemModel.requestForVehicleUpdateBody([titleTF.text!, makeTF.text!,modelTF.text!,licenceTF.text!,getFuelInfoToAPI(fuelTypeTF.text!),cardId,imageObject])
        
        // Updating vehicle
        
        vehiclemModel.requestForUpdateVehicle(updateVehicle,vehicleID: selectedVehicle.vehicleId!, success: { (result) in
            debug_print("Vechile updated ")
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.view.hideHudView()
                  self.navigationController?.popViewControllerAnimated(true)
               // self.showAlertActionWithMessage(kVehicleUpdatedMeggage)
            }
            }, failureBlock: { (error) in
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.view.hideHudView()
                    self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
                }
        })
    }
    
    
    // Adding Vehile via API
    func createVehicle()
    {
        
        for vehcile in vehiclemModel.allVehicles! {
            
            if vehcile.vehicleNumber == licenceTF.text! {
                showAlertActionWithMessage(kVehicleExistMessage)
                return
            }
        }
        
        self.view .initHudView(.Indeterminate, message: kHudWaitingMessage)
        
        var imageObject : AnyObject
        // checking vehicle image have nill value
        if vehicleImage != nil
        {
            imageObject = UIImageJPEGRepresentation(vehicleImage!, 0.1)!
        }
        else
        {
            imageObject = ""
        }
        
        var cardId = ""
        
        if assignedCard.cardId != nil
        {
            cardId = assignedCard.cardId!
        }
        let newVehicle = vehiclemModel.requestForVehicleSaveBody([titleTF.text!, makeTF.text!,modelTF.text!,licenceTF.text!,getFuelInfoToAPI(fuelTypeTF.text!),cardId,imageObject])
        // Creating new vehicle
        vehiclemModel.requestForAddNewVehicleForUser(newVehicle, success: { (result) in
            dispatch_async(dispatch_get_main_queue()) {
                
                self.view.hideHudView()
                self.showAlertActionWithMessage(kVehicleCreatedMessage)
            }
            
            
            }, failureBlock: { (error) in
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.view.hideHudView()
                    self.loginAlertVC.presentAlertWithTitleAndMessage (kErrorTitle, message:error.localizedDescription, controller: self)
                }
        })
    }
    
    
    func showAlertActionWithMessage(message : String) -> Void
    {
        let actionsArr:[()->()] = [{
            _ in
            self.navigationController?.popViewControllerAnimated(true)
            
            }]
        
        self.loginAlertVC.presentAlertWithActions(actionsArr, buttonTitles: [kAlertOK], controller: self, message: message)
    }
    
    
    @IBAction func addNewCardButtonTapped(sender: UIButton) {
        
        //PAYMENTCARDSTORYBOARD ADDNEWCARDVC
        self.pushViewControllerWithIdentifierAndStoryBoard(ADDNEWCARDVC, storyBoard: PAYMENTCARDSTORYBOARD)
    }
    
    
    // MARK:- SHOW UITableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch selectedPopup {
        case MAKER_TBL:
            return (makeArray?.count)!
        case MODEL_TBL:
            return (modelsArray?.count)!;
        case FUELTYPE_TBL:
            return (fuelTypesArray?.count)!;
        case CARD_TBL:
            return (cardModel.allCards?.count)!;
        default:
        
           // return (makeArray?.count)!
            return 0

        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        var isHighlight = false
        switch selectedPopup {
        case MAKER_TBL:
            cell.textLabel?.text = makeArray![indexPath.row].name
            isHighlight = (cell.textLabel?.text == makeTF.text)
            break
        case MODEL_TBL:
            cell.textLabel?.text = modelsArray![indexPath.row].name
            isHighlight = (cell.textLabel?.text == modelTF.text)
            break
        case FUELTYPE_TBL:
            cell.textLabel?.text = MakeModelJSON.sharedInstance.getFuelDisplayNameWithFuelNumber(fuelTypesArray![indexPath.row].number!)
            isHighlight = (cell.textLabel?.text == fuelTypeTF.text)
            break
        case CARD_TBL:
            cell.textLabel?.text = CardsModel.sharedInstance.getFormattedDisplayString(cardModel.allCards![indexPath.row])
            isHighlight = (cell.textLabel?.text == creditCardTF.text)
            break
        default: break
            
        }
        
        cell.textLabel?.font = UIFont.appRegularFontWithSize14()
        cell.textLabel?.textColor = UIColor.appFontColor()
        
        
        if (isHighlight)
        {
            cell.accessoryType = .Checkmark
        }
        else
        {
            cell.accessoryType = .None
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch selectedPopup {
        case MAKER_TBL:
            selectedMake = makeArray![indexPath.row]
            updateModelArray()
            self.makeTF.text = makeArray![indexPath.row].name
        case MODEL_TBL:
            self.modelTF.text = modelsArray![indexPath.row].name
        case FUELTYPE_TBL:
            self.fuelTypeTF.text = MakeModelJSON.sharedInstance.getFuelDisplayNameWithFuelNumber(fuelTypesArray![indexPath.row].number!)
        case CARD_TBL:
            self.creditCardTF.text = CardsModel.sharedInstance.getFormattedDisplayString(cardModel.allCards![indexPath.row])
            self.creditCardTF.addLeftView(cardModel.allCards![indexPath.row].cardImageName())
            assignedCard = cardModel.allCards![indexPath.row]
            logFlurryEvent("Add card to vehicle")
        default: break
            
        }
        popup.dismissAnimated(true)
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 30.0;
    }
    
    
    //MARK: ImagePickerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            vehicleImage = pickedImage
            vehicleImageBtn.setImage(pickedImage, forState: .Normal)
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK:-- UITextField Delegate methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        if (textField == makeTF || textField == modelTF || textField == fuelTypeTF || textField == creditCardTF)
        {
            return false
        }
        return true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if (textField == titleTF)
        {
            licenceTF.becomeFirstResponder()
        }
        if (textField == licenceTF)
        {
            self.makeButtonTapped(makeButton)
        }
        return true
    }
    
    
    // MARK:- SHOW POPUP
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
        popupTblView.sizeToFit()
        popup = RBAPopup.init(customView: popupTblView)
        popup.backgroundColor = UIColor.whiteColor()
        popup.borderColor = UIColor.appUltraLightFontColor()
        popup.borderWidth = 0.5
        popup.cornerRadius = 10;
        popup.presentPointingAtView(view, inView: self.view, animated: true)
    }
    
    
    // MARK:- Load Sample Data
    func  loadSampleData()
    {
        makeArray = MakeModelJSON.sharedInstance.allMakes
        fuelTypesArray = MakeModelJSON.sharedInstance.allFuelTypes
        creditCardsArray = CardsModel.sharedInstance.allCards
    }
    
    
    func updateModelArray()
    {
        self.modelTF.text = ""
        if selectedMake.model != nil {
            modelsArray = selectedMake.model
        }
    }
    
    
    func loadVehicleDetails() {
        
        if editVehicle
        {
            if (selectedVehicle.paymentCard.cardId != nil) {
                assignedCard = selectedVehicle.paymentCard
                creditCardTF.text = cardModel.getFormattedDisplayString(assignedCard)
            }
            
            titleTF.text = selectedVehicle.title
            licenceTF.text = selectedVehicle.vehicleNumber
            makeTF.text = selectedVehicle.make
            modelTF.text = selectedVehicle.model
            fuelTypeTF.text  = MakeModelJSON.sharedInstance.getFuelDisplayNameWithFuelNumber(selectedVehicle.fuel!)
            
            selectedMake = getMakeObjectWithID(makeTF.text!)
            
            if selectedMake.model != nil {
                modelsArray = selectedMake.model
            }
            
            let vehicleURL = selectedVehicle.vehiclePicture
            if vehicleURL != nil {
                
                self.vehicleImageBtn.sd_setImageWithURL(NSURL.init(string: vehicleURL!), forState: UIControlState.Normal, placeholderImage: UIImage.init(named: "Car_Orange"))
            }
            else
            {
                self.vehicleImageBtn.setImage(UIImage.init(named: "Car_Orange"), forState: UIControlState.Normal)
            }
            licenceTF.enabled = false
        }
    }
    
    
    // Display Credit card info
    func loadCreditCardDetails(){
        // Loading first card deails in credit card
        
        if (assignedCard.cardId == nil)
        {
            assignedCard = Card()
            assignedCard.cardholderName = "Please choose your card"
            assignedCard.type = CREDITCARD_EMPTY
            assignedCard.cardId = ""
            creditCardTF.text = CardsModel.sharedInstance.getFormattedDisplayString(assignedCard)
            creditCardTF.addLeftView("")
        }
        else
        {
            creditCardTF.text = cardModel.getFormattedDisplayString(assignedCard)
        }
    }
    
    
    func getMakeObjectWithID(name: String) -> VehicleMake {
        
        let predicate = NSPredicate(format:"name = %@",name)
        let filterArr = makeArray?.filter({ predicate.evaluateWithObject($0)})
        if ((filterArr?.count) != nil) {
            return filterArr![0]
        }
        return selectedMake
    }
    
    
    func getFuelTypeNumber(name: String) -> String
    {
        
        let predicate = NSPredicate(format:"name = %@",name)
        let filterArr = fuelTypesArray?.filter({ predicate.evaluateWithObject($0)})
        if ((filterArr?.count) > 0) {
            return filterArr![0].number!
        }
        return "89"
    }
    
    
    func getFuelTypeName(number: String) -> String
    {
        if number.characters.count > 0 {
            let predicate = NSPredicate(format:"number = %@",number)
            let filterArr = fuelTypesArray?.filter({ predicate.evaluateWithObject($0)})
            if ((filterArr?.count) > 0) {
                return filterArr![0].name!
            }
            return "Regular"
        }
        return ""
    }
    
    
    func getFuelInfoToAPI(displayString: String) -> String!
    {
        if displayString.characters.count > 0 {
            let array = displayString.componentsSeparatedByString(":")
            return array[0]
        }
        return "";
    }
}
