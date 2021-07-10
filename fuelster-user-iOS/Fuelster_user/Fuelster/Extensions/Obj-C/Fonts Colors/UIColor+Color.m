//
//  UIColor+Color.m
//  JointEffortV2
//
//  Created by Prasad on 7/17/15.
//  Copyright (c) 2015 rapidBizApps. All rights reserved.
//

#import "UIColor+Color.h"

@implementation UIColor (Color)

+(UIColor *)appFontColor
{
    return [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
}

+(UIColor *)appLightFontColor
{
    return [UIColor colorWithRed:137/255.0f green:137/255.0f blue:137/255.0f alpha:1];
}

+(UIColor *)appUltraLightFontColor
{
    return [UIColor colorWithRed:180/255.0f green:180/255.0f blue:185/255.0f alpha:1];
}

+(UIColor *)  textFieldPrimaryBackgroundColor
{
    return [UIColor colorWithRed:248/255.0f green:248/255.0f blue:250/255.0f alpha:1];
}

+(UIColor *)appGreenTextColor
{
    return [UIColor colorWithRed:126/255.0f green:211/255.0f blue:33/255.0f alpha:1];
}

+(UIColor *)appBlueTextColor
{
    return [UIColor colorWithRed:55/255.0f green:92/255.0f blue:168/255.0f alpha:1];
}


+ (UIColor*) gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height
{
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)lighterColorForColor:(UIColor *)c withAlpha:(float)alpha
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:alpha];
    return nil;
}

@end
