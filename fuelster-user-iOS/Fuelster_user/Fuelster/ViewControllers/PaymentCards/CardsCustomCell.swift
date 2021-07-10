//
//  CardsCustomCell.swift
//  Fuelster
//
//  Created by Prasad on 8/23/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import UIKit

class CardsCustomCell: UITableViewCell
{
    //Card Header
    @IBOutlet weak var cardNumberView: UIView!
    @IBOutlet weak var cardTypeImageview: UIImageView!
    @IBOutlet weak var cardNumberLabe: UILabel!
    @IBOutlet weak var cardDeleteButton: UIButton!
    //Card Details
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet weak var cardNuberDetailLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!
    @IBOutlet weak var nameOnCardLabel: UILabel!
    
    @IBOutlet weak var cardTemplateImg: UIImageView!
    weak var delegate:CustomeCellDelegate?

    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    //To papulate data on cell labels
    func configureCell(paymentCard:Card) -> Void
    {
        debug_print(paymentCard);
        
        let  cardNum = paymentCard.cardNumber!
         let  name = paymentCard.cardholderName!
        
        self.cardNumberLabe.text  = name + " - " + cardNum
        
      //  self.cardNumberLabe.text =   paymentCard.cardholderName! +" - " +
        self.cardNuberDetailLabel.text = "XXXX XXXX XXXX " + paymentCard.cardNumber!
        self.expiryDateLabel.text = paymentCard.expiry
        self.nameOnCardLabel.text = paymentCard.cardholderName
        self.cardTypeImageview.image = UIImage(named:  paymentCard.cardImageName())
        self.cardTemplateImg.image = UIImage(named:  paymentCard.cardTemplateImageName())
        
        cardTemplateImg.applyPrimaryShadow()

         debug_print( "======   paymentCard.cardId \(paymentCard.cardId) "   )
    }
    
    
    //Delete buttion Action
    @IBAction func cardDeleteButtonAction(sender: UIButton)
    {
        debug_print("Card delete button action")
         self.delegate?.cellCardDeleteButtonAction!(self)
    }
    
    
}
