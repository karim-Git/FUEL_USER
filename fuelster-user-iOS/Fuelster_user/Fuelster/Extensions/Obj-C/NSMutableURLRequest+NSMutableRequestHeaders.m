//
//  NSMutableURLRequest+NSMutableRequestHeaders.m
//  Fuelster
//
//  Created by Sandeep Kumar Rachha on 17/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "NSMutableURLRequest+NSMutableRequestHeaders.h"

@implementation NSMutableURLRequest (NSMutableRequestHeaders)


- (void)setupRequestHeadersAllowSession:(BOOL) allow multiPart:(BOOL)yes
{
    if (!yes) {
        [self setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    else {
        [self setValue:@"multipart/form-data; boundary=---011000010111000001101001" forHTTPHeaderField:@"Content-Type"];
        
    }
    if (allow) {
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        [self setValue:[defs objectForKey:@"authToken"] forHTTPHeaderField:@"x-header-authtoken"];
        [self setValue:[defs objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshToken"];
        //NSLog(@"refresh token %@",[defs objectForKey:@"refreshToken"]);
    }
    [self setValue:@"1.0.0" forHTTPHeaderField:@"X-APP-VERSION"];
    [self setValue:@"user" forHTTPHeaderField:@"role"];
    [self setValue:@"iOS" forHTTPHeaderField:@"os-type"];
}


- (void)setupPostBodyHeader:(id)postBody
{
    if (!postBody) {
        return;
    }
    
    NSError *err;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postBody options:NSJSONWritingPrettyPrinted error:&err];
    
    if (err) {
        
        //NSLog(@" json object error %@",err.description);
    }
    else
    {
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        //if (postLength > 0) {
            [self setHTTPBody:postData];
            [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
        //}
    }
}


@end
