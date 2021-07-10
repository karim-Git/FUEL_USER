//
//  File.swift
//  DrillLogs
//
//  Created by Sandeep Kumar on 21/06/16.
//  Copyright © 2016 RBA. All rights reserved.
//

import Foundation
import UIKit


extension UITextField:UIPickerViewDelegate,UIPickerViewDataSource
{

    func applyAndroidTheame() -> Void
    {
        
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.whiteColor().CGColor
        self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.layer.shadowOpacity = 1.0

    }
    
    func applyTextFieldPrimaryTheme() -> Void {
        self.layer.cornerRadius = 13.0
        self.backgroundColor = UIColor.getTextFieldPrimaryBackgroundColor()
    }
    
    func addDropDownButton() -> UIButton {
        let button = UIButton.init(frame: self.bounds)
        self.addSubview(button)
        button.setImage(UIImage.init(named: "DownArrow_small"), forState: .Normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -button.frame.size.width + 30)
                return button
    }
    
    func addLeftView(imageName:String) -> Void {
        
        self.leftViewMode = UITextFieldViewMode.Always
        self.leftView = UIImageView.init(image: UIImage(named: imageName))
    }
    
    func addRightView(imageName:String) -> Void {
        
        self.rightViewMode = UITextFieldViewMode.Always
        let imageview = UIImageView.init(image: UIImage(named: imageName))
        imageview.contentMode = .Center
        imageview.userInteractionEnabled = true
        self.rightView = imageview
        
        
    }

    
    func addPickerView() -> Void
    {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        let row = Model.sharedInstance.pickerArr!.indexOf(self.text!)
        if row != nil {
            pickerView.selectRow(row!, inComponent: 0, animated: true)
        }
        self.inputView = pickerView
        self.initToolBar()

    }
    
    func addDatePicker() -> Void{
        
        let dobPicker = UIDatePicker();
        dobPicker.datePickerMode = .Date
        dobPicker .addTarget(self, action: #selector(self.dateSelected(_:)), forControlEvents: .ValueChanged)
        self.inputView = dobPicker;
        self.initToolBar()
        self.text = self .getStringFromSelectedDate(dobPicker.date)
    }
    
    
    func initToolBar() -> Void {
        
         let keyBoardToolBar = UIToolbar()

        keyBoardToolBar.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44);
        keyBoardToolBar .barTintColor = UIColor (red: 55.0/255.0, green: 84.0/255.0, blue: 141.0/255.0, alpha: 1.0)
        let spaceBtn = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem (title: "Done", style: .Plain, target: self, action: #selector(self.doneButtonAction(_:)))
        
        self.inputAccessoryView = keyBoardToolBar
        
        keyBoardToolBar .setItems([spaceBtn,doneBtn], animated: true);
    }
    
    
    func dateSelected(sender:AnyObject?) -> Void
    {
        let dp = sender as! UIDatePicker
        self.text = self .getStringFromSelectedDate(dp.date)
    }
    
    
    func getStringFromSelectedDate(date:NSDate) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        let dateStr = formatter.stringFromDate(date)
        
        return dateStr;
    }

    
    func getDateFromString() -> NSDate?
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
       // formatter.timeZone = NSTimeZone
        let (_,date) = self.text!.getDateFromParseDate()

        //let date = formatter.dateFromString(self.text!)
        debug_print(date)
        return date!
    }
    
    func doneButtonAction(sender:AnyObject?) -> Void
    {
        self.resignFirstResponder()
    }

    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    
    {
        return Model.sharedInstance.pickerArr!.count
    }

    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.text = Model.sharedInstance.pickerArr![row]
    }

     public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     {
        
        return Model.sharedInstance.pickerArr![row]
    }
   
}

extension UIButton
{
    func addUnderLine() -> Void {
        
        let attributes = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let attributedText = NSAttributedString(string: self.currentTitle!, attributes: attributes)
        self.titleLabel?.attributedText = attributedText
    }
}

extension UITextView
{
 
    func initToolBar() -> Void {
        
        let keyBoardToolBar = UIToolbar()
        
        keyBoardToolBar.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44);
        keyBoardToolBar .barTintColor = UIColor (red: 55.0/255.0, green: 84.0/255.0, blue: 141.0/255.0, alpha: 1.0)
        let spaceBtn = UIBarButtonItem (barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem (title: "Done", style: .Plain, target: self, action: #selector(self.doneButtonAction(_:)))
        
        self.inputAccessoryView = keyBoardToolBar
        
        keyBoardToolBar .setItems([spaceBtn,doneBtn], animated: true);
    }
    
    
    func doneButtonAction(sender:AnyObject?) -> Void
    {
        self.resignFirstResponder()
    }


}


extension String
{
    
    static func getLocationAddressWithLatitudeAndLongitude(latitude:Double,longitude:Double,success: (result: AnyObject) -> Void,failureBlock: (error: NSError) -> Void ) -> Void {
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        print(location)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                failureBlock(error: error!)
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                //self = pm.thoroughfare!+pm.locality!+pm.administrativeArea!
                success(result: pm.addressDictionary!)
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func convertIntToString(num:Int?) -> String? {
        
        return num?.description
    }
    
    
    func  getDateFromParseDate() -> (NSDateFormatter,NSDate?)
    {
        let formatter = self.setDateFormatter()
        return (formatter,formatter.dateFromString(self)!)
    }
  
    
    func setDateFormatter() -> NSDateFormatter
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        formatter.timeZone = NSTimeZone.localTimeZone()
        
        return formatter
    }
    
    
    
    func convertDateIntoDaysAgo() -> String?
    {
        
        // The output below is limited by 1 KB.
        // Please Sign Up (Free!) to remove this limitation.
        
        let components = NSCalendar.currentCalendar().components([.Minute, .Hour, .Day, .Month, .Year], fromDate: NSDate())
        let (formatter,sourcDate) = self.getDateFromParseDate()
        let sourceDateComponents = NSCalendar.currentCalendar().components([.Minute, .Hour, .Day, .Month, .Year], fromDate: sourcDate!)
        var timestamp = ""
        let formatSourceDate = NSDateFormatter()
        formatSourceDate.AMSymbol = "AM"
        formatSourceDate.PMSymbol = "PM"
        //same day - time in h:mm am/pm
        if components.day == sourceDateComponents.day {
            formatSourceDate.dateFormat = "h:mm a"
            timestamp = "\(formatSourceDate.stringFromDate(NSDate()))"
            return timestamp
        }
        else if components.day - sourceDateComponents.day == 1 {
            //yesterday
            timestamp = NSLocalizedString("Yesterday", comment: "")
            return timestamp
        }
        
        if components.year == sourceDateComponents.year {
            //september 29, 5:56 pm
            formatSourceDate.dateFormat = "MMMM d"
            timestamp = "\(self.getStringFromParseFullDate())"
            return timestamp
        }
        
        return nil
    }
    
    
    func getStringFromParseDate() -> String?
    {
        let (df,d) = self.getDateFromParseDate()
        df.dateFormat = "dd-MM-yyyy"
        let timeZoneSeconds = NSTimeZone.systemTimeZone().secondsFromGMT
        let dateInLocalTimezone = d?.dateByAddingTimeInterval(Double(timeZoneSeconds))

        return df .stringFromDate(dateInLocalTimezone!)
    }
    
    func getStringFromParseTime() -> String?
    {
        let (df,d) = self.getDateFromParseDate()
        df.dateFormat = "hh:mm"
        let timeZoneSeconds = NSTimeZone.systemTimeZone().secondsFromGMT
        let dateInLocalTimezone = d?.dateByAddingTimeInterval(Double(timeZoneSeconds))

        return df .stringFromDate(dateInLocalTimezone!)
    }
    
    func getStringFromParseAMPM() -> String?
    {
        let (df,d) = self.getDateFromParseDate()
        df.dateFormat = "a"
        let timeZoneSeconds = NSTimeZone.systemTimeZone().secondsFromGMT
        let dateInLocalTimezone = d?.dateByAddingTimeInterval(Double(timeZoneSeconds))

        return df .stringFromDate(dateInLocalTimezone!)
    }
    

    
    func getStringFromParseFullDate() -> String?
    {
        let (df,d) = self.getDateFromParseDate()
        let timeZoneSeconds = NSTimeZone.systemTimeZone().secondsFromGMT
        let dateInLocalTimezone = d?.dateByAddingTimeInterval(Double(timeZoneSeconds))

        df.dateFormat = "dd-MM-yyyy hh:mm a"
        
        return df .stringFromDate(dateInLocalTimezone!)
    }

    
    func getMMMddYYYYString() -> String?
    {
        let (df,d) = self.getDateFromParseDate()
        df.dateFormat = "MMM dd,yyyy"
        let timeZoneSeconds = NSTimeZone.systemTimeZone().secondsFromGMT
        let dateInLocalTimezone = d?.dateByAddingTimeInterval(Double(timeZoneSeconds))

        return df .stringFromDate(dateInLocalTimezone!)

    }
    
    
    func getParseDateFromString() ->  (NSDate?,String?)
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        
        let date = formatter.dateFromString(self)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let parseDateStr = formatter.stringFromDate(date!)
        
        let parseDate = formatter.dateFromString(parseDateStr)
        
        return (parseDate!,parseDateStr)
    }
    
    
    func getFullParseDateFromString() ->  (NSDate?,String?)
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd,yyyy hh:mm a"
        
        let date = formatter.dateFromString(self)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let parseDateStr = formatter.stringFromDate(date!)
        
        let parseDate = formatter.dateFromString(parseDateStr)
        
        return (parseDate!,parseDateStr)
    }
    
    
    func getHHMMParseDateFromString() ->  (NSDate?,String?)
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm"
        
        let date = formatter.dateFromString(self)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let parseDateStr = formatter.stringFromDate(date!)
        
        let parseDate = formatter.dateFromString(parseDateStr)
        
        return (parseDate!,parseDateStr)
    }
    
    func getAMPMMParseDateFromString() ->  (NSDate?,String?)
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "a"
        
        let date = formatter.dateFromString(self)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let parseDateStr = formatter.stringFromDate(date!)
        
        let parseDate = formatter.dateFromString(parseDateStr)
        
        return (parseDate!,parseDateStr)
    }
    
    
    func validateEmail() -> Bool?
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailPredicate = NSPredicate (format:"SELF MATCHES %@",emailRegex)
        
        return emailPredicate.evaluateWithObject(self)
    }
    
    
    func validateCreditCardExpiryDate() -> Bool? {
        
        let emailRegex = "^((0[1-9])|(1[0-2]))\\/((2009)|(20[1-9][0-9]))$"
        let emailPredicate = NSPredicate (format:"SELF MATCHES %@",emailRegex)
        
        return emailPredicate.evaluateWithObject(self)
    }
    
     static func GetUUID() -> String {
        let theUUID: CFUUIDRef = CFUUIDCreate(nil)
        let string: CFString = CFUUIDCreateString(nil, theUUID)
        return String(string)
    }
    
    func encodeStringWithUTF8() -> String
    {
        
        if UIDevice.currentDevice().versionLessThaniOS8() == true {
           return self.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        }
        else
        {
            let urlSet = NSMutableCharacterSet()
            urlSet.formUnionWithCharacterSet(.URLFragmentAllowedCharacterSet())
            urlSet.formUnionWithCharacterSet(.URLHostAllowedCharacterSet())
            urlSet.formUnionWithCharacterSet(.URLPasswordAllowedCharacterSet())
            urlSet.formUnionWithCharacterSet(.URLQueryAllowedCharacterSet())
            urlSet.formUnionWithCharacterSet(.URLUserAllowedCharacterSet())

            return self.stringByAddingPercentEncodingWithAllowedCharacters(urlSet)!
        }
    }
}


extension NSMutableAttributedString
{
    func addGrayColorAttribute(string:String) -> Void
    {
        let str = self.string as NSString
        let firstAttributes = UIColor.getGrayColorFontAttribute()
        self.addAttributes(firstAttributes, range: str.rangeOfString(string))
    }
    
    
    func addBlackColorAttribute(string:String) -> Void
    {
        let str = self.string as NSString
        let firstAttributes = UIColor.getBlackColorFontAttribute()
        self.addAttributes(firstAttributes, range: str.rangeOfString(string))
    }
    
}

extension UIColor
{
    
    
   class func labelPlaceHolderColor() -> UIColor
    {
        
        return UIColor.grayColor()
    }
    
    class func labelBlackColor() -> UIColor
    {
        
        return UIColor.blackColor()
    }

    
    class func appTheamColor() -> UIColor
    {
       return UIColor.init(red: 55.0/255.0, green: 84.0/255.0, blue: 141.0/255.0, alpha: 1.0)
    }
    
    
    class func getGrayColorFontAttribute() -> [String:AnyObject]
    {
        return [NSForegroundColorAttributeName: UIColor.grayColor()]
    }
    
    
    class func getBlackColorFontAttribute() -> [String:AnyObject]
    {
        return [NSForegroundColorAttributeName: UIColor.blackColor()]
    }
    
    class func getTextFieldPrimaryBackgroundColor()->UIColor
    {
        return UIColor.init(red: 248.0/255.0, green: 248.0/255.0, blue: 250/255.0, alpha: 1.0)
    }
    
}

extension NSMutableDictionary
{
    
    func getPointerObject(key:String, className:String, objectId:String) -> Void
    {
        self[key] = NSDictionary.init(objects:["Pointer",className,objectId], forKeys: ["__type","className","objectId"])
    }
    
    func getDateObject(key:String, date:String) ->Void
    {
        self[key] = NSDictionary.init(objects:["Date",date], forKeys: ["__type","iso"])
    }
}
