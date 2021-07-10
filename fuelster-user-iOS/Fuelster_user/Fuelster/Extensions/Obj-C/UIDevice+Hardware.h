//
//  UIDevice+Hardware.h
//  O1NetworkLibrary
//
//  Created by Abhijeet Kumar on 11/1/12.
//  Copyright (c) 2012 O1 Works. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
    #define kCFCoreFoundationVersionNumber_iOS_7_0 1047.22
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
    #define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif

#define O1_PRE_IOS7     (NSFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0)
#define O1_PRE_IOS8     (NSFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0)

@interface UIDevice (Hardware)

- (NSString *) CPUType;
- (NSString *) deviceType;

- (BOOL) versionLessThaniOS7;
- (BOOL) versionGreaterThanEqualiOS7;
- (BOOL) versionLessThan:(NSString *)version;
- (BOOL) versionLessThaniOS8;
- (BOOL) versionGreaterThanEqualiOS8;

+ (BOOL)isIPad;
+ (BOOL)isIPhone;

// 3.5 inch iPhone
+ (BOOL)isIPhone4AndBelow;

// 4 inch iPhone
+ (BOOL)isIPhone5;

// 4.7 inch iPhone
+ (BOOL)isIPhone6;

// 5.5 inch iPhone
+ (BOOL)isIPhone6Plus;

+ (void)logProfile;
+ (NSInteger)iOSVersion;

+ (BOOL)isTouchIDAvailabe;

@end