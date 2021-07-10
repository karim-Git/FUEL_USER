//
//  NSString+FSString.h
//  Fuelster
//
//  Created by Kareem on 24/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIFont+Font.h"
@interface NSString (FSString)

-(NSMutableAttributedString *)getBoldAttributeString;
-(NSMutableAttributedString *)getBoldAttributeStringWithBoldFont:(UIFont *)boldFont normalFont:(UIFont *)normalFont;
@end
