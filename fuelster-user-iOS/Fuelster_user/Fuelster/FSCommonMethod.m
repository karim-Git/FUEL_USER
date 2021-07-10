//
//  FSCommonMethod.m
//  Fuelster
//
//  Created by Kareem on 24/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "FSCommonMethod.h"
#import "UIFont+Font.h"
@implementation FSCommonMethod
+(NSMutableAttributedString *)getTimeAttributeString:(NSString *)string
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSArray * boldCharacters = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@":", nil];
    
    
    
    for (int i = 0; i < string.length; i++) {
        
        NSString * charStr = [NSString stringWithFormat:@"%c",[string characterAtIndex:i]];
        
        if ([boldCharacters containsObject:charStr])
        {
            UIFont * boldFont = [UIFont appBoldFontWithSize12];
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:12] forKey:NSFontAttributeName];
            
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:charStr attributes:attributes];
            [attrString appendAttributedString:subString];
            // [attrString addAttribute:NSFontAttributeName value:[UIFont appBoldFontWithSize12] range:NSMakeRange(i, 1)];
        }
        else
        {
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
            
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:charStr attributes:attributes];
            [attrString appendAttributedString:subString];
            //  [attrString addAttribute:NSFontAttributeName value:[UIFont appThinFontWithSize12] range:NSMakeRange(i, 1)];
        }
        
    }
    return attrString;
}


@end
