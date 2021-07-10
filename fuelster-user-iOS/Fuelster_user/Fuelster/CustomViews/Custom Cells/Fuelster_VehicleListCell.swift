//
//  Fuelster_VehicleListCell.swift
//  Fuelster
//
//  Created by Kareem on 2016-08-23.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class Fuelster_VehicleListCell: UITableViewCell {

    @IBOutlet weak var vehicleNameLbl: UILabel!
    @IBOutlet weak var vehicleNumberLbl: UILabel!
     @IBOutlet weak var vehicleModelLbl: UILabel!
     @IBOutlet weak var vehicleIconView: UIImageView!
     var vehicleIconButton: UIButton!
    @IBOutlet weak var paymentButton: UIButton!
   // @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shadowView : UIView!
    @IBOutlet weak var creditCardTextField : RBATextField!
    @IBOutlet weak var clickToAddCardBtn : UIButton!
    
    var   seperaterLabel: UILabel!
    weak var delegate:CustomeCellDelegate?
    var gradient: CAGradientLayer!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    //    let tapGesture = UITapGestureRecognizer (target: self, action:#selector(tapGestureAction(_:)))
    //    self.vehicleIconView.addGestureRecognizer(tapGesture)
             // self.cardTypeImageView.backgroundColor = UIColor.clearColor()
       
       // shadowView.applyPrimaryShadow()
       
        vehicleIconButton = UIButton.init(frame: self.vehicleIconView.bounds)
        
        vehicleIconButton.layer.cornerRadius = self.vehicleIconView.frame.size.width/2.0
        vehicleIconButton.layer.masksToBounds = true
        vehicleIconButton.clipsToBounds = true
        vehicleIconButton.layer.borderWidth = 1.0
        creditCardView.bringSubviewToFront(paymentButton)
       // clickToAddCardBtn.applyPrimaryTheme()
       self.vehicleIconView.addSubview(vehicleIconButton)
         vehicleIconButton.addTarget(self, action: #selector(tapGestureAction), forControlEvents: UIControlEvents.TouchUpInside)
      
        seperaterLabel = UILabel(frame: CGRect(x:5 , y:self.contentView.frame.size.height , width: self.contentView.frame.size.width-10 , height: 0.3))
        seperaterLabel.backgroundColor = UIColor.appUltraLightFontColor()
          self.contentView.addSubview(seperaterLabel)
       gradient = self.contentView.applyScecondaryBackGroundGradient()
        self.resetPrimaryShadow()
    }

    
    func configureCell(vehicle:Vehicle, delegate:Fuelster_BaseViewController) -> Void
    {
       
        vehicleIconButton.frame = self.vehicleIconView.bounds
        vehicleIconButton.layer.cornerRadius = self.vehicleIconView.frame.size.width/2.0
        vehicleIconButton.layer.masksToBounds = true
        vehicleIconButton.clipsToBounds = true
       // vehicleIconButton.layer.borderWidth = 1.0
        
        self.vehicleNameLbl.text = vehicle.title
        self.vehicleNumberLbl.text = NSString.localizedStringWithFormat("Licence Plate: %@",vehicle.vehicleNumber!) as String
        self.vehicleModelLbl.text = vehicle.make! + " " + vehicle.model!
        if vehicle.paymentCard.cardId == nil {
             clickToAddCardBtn.hidden = false
                self.creditCardTextField.addLeftView("")
        }
        else{

            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
            let underlineAttributedString = NSMutableAttributedString(string: CardsModel.sharedInstance.getFormattedDisplayString(vehicle.paymentCard), attributes: underlineAttribute)
            
          
            
            
            let fullString = CardsModel.sharedInstance.getFormattedDisplayString(vehicle.paymentCard)
            let subString = CardsModel.sharedInstance.getFormattedDisplayString(vehicle.paymentCard)
            
          //  debug_print("full string " + fullString!)
            
            let range = ((fullString as NSString)).rangeOfString(subString)
            let attributedString = NSMutableAttributedString(string:fullString)
           
            underlineAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.appFontColor(), range: NSRange(location: 0, length: fullString.characters.count))
          
            underlineAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.appFontColor(), range: range)
            
                    
            //underlineAttributedString.addAttribute(NSFontAttributeName, value: UIFont. , range: NSRange(location: 0, length: fullString!.characters.count))
            //underlineAttributedString.addAttribute(NSFontAttributeName, value: UIFont.appRegularFontWithSize22(), range: range)

            
            
                self.creditCardTextField.attributedText = underlineAttributedString
              self.creditCardTextField.addLeftView(vehicle.paymentCard.cardImageName())
            clickToAddCardBtn.hidden = true
        }
        
        let vehicleURL = vehicle.vehiclePicture
       
        if vehicleURL != nil {
//             self.vehicleIconView.sd_setImageWithURL(NSURL.init(string: vehicle.vehiclePicture!), placeholderImage: UIImage.init(named: "Car_Orange"))
             vehicleIconButton.sd_setImageWithURL(NSURL.init(string: vehicle.vehiclePicture!), forState: UIControlState.Normal, placeholderImage: UIImage.init(named: "Car_Orange"))
        }
        else
        {
           // self.vehicleIconView.image = UIImage.init(named: "Car_Orange")
            vehicleIconButton.setImage(UIImage.init(named: "Car_Orange"), forState: .Normal)
        }
       
        vehicleIconView.contentMode = .ScaleAspectFit
        self.delegate = delegate
        
      //  self.seperaterLabel.applyScecondaryBackGroundGradient()
       // self.seperaterLabel.applyPrimaryShadow()
        
      
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func tapGestureAction(sender:AnyObject) -> Void {
        
       self.delegate?.cellPreviewImageAction!(self, subview:self.vehicleIconView)
        //self.delegate?.cellPreviewImageAction!(self, subview:self.vehicleIconButton)
    }
    
    //MARK: BUTTON Actions
    
    @IBAction func creditCardButtonTapped(sender: UIButton) {
        
        self.delegate?.cellCreditCardViewButtonAction!(self)
    }
    
    @IBAction func editButtonTapped(sender: UIButton) {
        
        self.delegate?.cellCreditCardAction!(self)
    }
   
    @IBAction func deleteButtonTapped(sender: UIButton) {
         self.delegate?.cellVehicleDeleteButtonAction!(self)
        
    }
  
    
}
