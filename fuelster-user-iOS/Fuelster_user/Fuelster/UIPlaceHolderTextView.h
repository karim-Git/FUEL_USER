//
//  UIPlaceHolderTextView.h
//  Fuelster
//
//  Created by Kareem on 23/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@end