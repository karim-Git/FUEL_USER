//
//  UIColor+Color.h
//  JointEffortV2
//
//  Created by Prasad on 7/17/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Color)


+(UIColor *)appFontColor;

+(UIColor *)appLightFontColor;

+(UIColor *)appUltraLightFontColor;



+(UIColor *)  textFieldPrimaryBackgroundColor;

+(UIColor *)appGreenTextColor;

+(UIColor *)appBlueTextColor;



+ (UIColor*) gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

+ (UIColor *)lighterColorForColor:(UIColor *)c withAlpha:(float)alpha;




@end
