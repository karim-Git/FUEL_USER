//
//  ServiceModel.m
//  ESCMS
//
//  Created by srachha on 19/05/14.
//  Copyright (c) 2014 Srachha. All rights reserved.
//

#import "ServiceModel.h"


@implementation ServiceModel



+(void)connectionWithBody:(NSDictionary *)body method:(NSString *)method service:(NSString *)service  successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock;

{
    
    NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
    {
        dispatch_queue_t processing_queue = dispatch_queue_create("com.Rand.Brand.processing", NULL);
        
        dispatch_async(processing_queue, ^{
            wrapperSuccessBlock (data);
        });
    };
    
    NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
    {
        wrapperFailedBlock (error);
    };
    
    [NetworkWrapper connectWithURLString:body method:method service:service successBlock:userSuccessBlock failureBlock:userFailureBlock];
}


+(void)connectionWithMultiformBody:(NSArray *)body withNames:(NSArray *)nameKeys method:(NSString *)method service:(NSString *)service  dataType:(NSString *)type successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock {
	 
	 NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
 {
	 dispatch_queue_t processing_queue = dispatch_queue_create("com.Rand.Brand.processing", NULL);
	 
	 dispatch_async(processing_queue, ^{
		  wrapperSuccessBlock (data);
	 });
 };
	 
	 NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
 {
	 wrapperFailedBlock (error);
 };

		  //[NetworkWrapper connectWithURLString:body method:method service:service successBlock:userSuccessBlock failureBlock:userFailureBlock];
	 [NetworkWrapper connectWithMultiformBody:body withNames:nameKeys method:method service:service dataType:type successBlock:userSuccessBlock failureBlock:userFailureBlock];
 
	 
}


+(void)downLoadImageWithURL:(NSURL*)url successBlock:(void (^)(id responseData))wrapperSuccessBlock failureBlock:(void (^)(NSError *error))wrapperFailedBlock {
	 
	 NetworkConnectionSuccessful userSuccessBlock = ^(NSURLResponse *response, NSData *data)
 {
	 dispatch_queue_t processing_queue = dispatch_queue_create("com.Rand.Brand.processing", NULL);
	 
	 dispatch_async(processing_queue, ^{
		  wrapperSuccessBlock (data);
	 });
 };
	 
	 NetworkConnectionFailure userFailureBlock = ^(NSURLResponse *response, NSError *error)
 {
	 wrapperFailedBlock (error);
 };
	 [NetworkWrapper downLoadImageWithURL:url successBlock:userSuccessBlock failureBlock:userFailureBlock];
	 
}


@end
