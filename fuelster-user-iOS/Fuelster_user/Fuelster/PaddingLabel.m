//
//  PaddingLabel.m
//  Fuelster
//
//  Created by Kareem on 23/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

- (void)drawTextInRect:(CGRect)rect {
   
    UIEdgeInsets insets = {0, 15, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
