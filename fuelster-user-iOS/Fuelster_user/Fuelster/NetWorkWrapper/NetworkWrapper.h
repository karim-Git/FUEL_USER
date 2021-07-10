//
//  NetworkWrapper.h
//  ESCMS
//
//  Created by srachha on 19/05/14.
//  Copyright (c) 2014 Srachha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Fuelster-Swift.h"

typedef enum{
    Trac_Login,
    Trac_Logout,
	 Trac_Register
	 
} Trac;

// Block that defines a successful HTTPS download
typedef void (^NetworkConnectionSuccessful)(NSURLResponse *response,id result);

// Block that defines an unsucessful HTTPS download
typedef void (^NetworkConnectionFailure)(NSURLResponse *response,NSError *error);



@interface NetworkWrapper : NSObject

@property (nonatomic,assign)Trac serviceType;

+(void)connectWithURLString:(NSDictionary *)body method:(NSString *)method service:(NSString *)service_Type successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock;

+(void)connectWithMultiformBody:(NSArray *)body withNames:(NSArray *)nameKeys method:(NSString *)method service:(NSString *)service dataType:(NSString *)type successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock;

+(void)downLoadImageWithURL:(NSURL*)url successBlock:(NetworkConnectionSuccessful)successBlock failureBlock:(NetworkConnectionFailure)failureBlock;

@end
