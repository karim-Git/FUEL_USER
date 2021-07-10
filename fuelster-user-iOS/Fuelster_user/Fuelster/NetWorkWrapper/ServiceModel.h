//
//  ServiceModel.h
//  ESCMS
//
//  Created by srachha on 19/05/14.
//  Copyright (c) 2014 Srachha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NetworkWrapper.h"
#import "Fuelster-Swift.h"

@interface ServiceModel : NSObject

+(void)connectionWithBody:(NSDictionary *)body method:(NSString *)method service:(NSString *)service  successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

+(void)connectionWithMultiformBody:(NSArray *)body withNames:(NSArray *)nameKeys method:(NSString *)method service:(NSString *)service dataType:(NSString *)type successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

+(void)downLoadImageWithURL:(NSURL*)url successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

@end
