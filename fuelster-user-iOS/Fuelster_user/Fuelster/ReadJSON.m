//
//  ReadJSON.m
//  ReadJSON
//
//  Created by Kareem on 20/09/16.
//  Copyright © 2016 rba. All rights reserved.
//

#import "ReadJSON.h"

@implementation ReadJSON

+(NSDictionary *)getMakeModelData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MakenModelsnFuelTypes" ofType:@"json"];
    
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:nil];
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:content options:kNilOptions error:&error];
    return json;
}

@end
