//
//  NSString+FSString.m
//  Fuelster
//
//  Created by Kareem on 24/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "NSString+FSString.h"


@implementation NSString (FSString)

-(NSMutableAttributedString *)getBoldAttributeString
{
    return [self getBoldAttributeStringWithBoldFont:[UIFont appBoldFontWithSize15] normalFont:[UIFont appRegularFontWithSize12]];
/*    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSArray * boldCharacters = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@":",@"$", nil];
    
    
    
    for (int i = 0; i < self.length; i++) {
    
        NSString * charStr = [NSString stringWithFormat:@"%c",[self characterAtIndex:i]];
        
        if ([boldCharacters containsObject:charStr])
        {
                       NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont appBoldFontWithSize15] forKey:NSFontAttributeName];

            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:charStr attributes:attributes];
            [attrString appendAttributedString:subString];
       
        }
        else
        {
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:[UIFont appRegularFontWithSize12] forKey:NSFontAttributeName];
            
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:charStr attributes:attributes];
            [attrString appendAttributedString:subString];
           //  [attrString addAttribute:NSFontAttributeName value:[UIFont appThinFontWithSize12] range:NSMakeRange(i, 1)];
        }
        
    }
    return attrString;*/
}

-(NSMutableAttributedString *)getBoldAttributeStringWithBoldFont:(UIFont *)boldFont normalFont:(UIFont *)normalFont
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSArray * boldCharacters = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@":",@"$", nil];
    
    
    
    for (int i = 0; i < self.length; i++) {
        
        NSString * charStr = [NSString stringWithFormat:@"%c",[self characterAtIndex:i]];
        
        if ([boldCharacters containsObject:charStr])
        {
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:boldFont forKey:NSFontAttributeName];
            
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:charStr attributes:attributes];
            [attrString appendAttributedString:subString];
            
        }
        else
        {
            NSDictionary * attributes = [NSDictionary dictionaryWithObject:normalFont forKey:NSFontAttributeName];
            
            NSAttributedString * subString = [[NSAttributedString alloc] initWithString:charStr attributes:attributes];
            [attrString appendAttributedString:subString];
          
        }
        
    }
    return attrString;
}
@end
