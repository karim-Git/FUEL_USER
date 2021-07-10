//
//  UIDevice+Hardware.m
//
//  Created by Sandeep Kumar on 11/1/12.
//  Copyright (c) 2012 O1 Works. All rights reserved.
//

@import LocalAuthentication;

@import Darwin;

#import "UIDevice+Hardware.h"

/*
 * Borrowed from http://theiphonewiki.com/wiki/Models
 */
#define DEVICE_TYPE_SIMULATOR_I386       @"Simulator i386"
#define DEVICE_TYPE_SIMULATOR_X86_64     @"Simulator x86_64"
#define DEVICE_TYPE_IPOD_TOUCH_3         @"iPod Touch 3"
#define DEVICE_TYPE_IPOD_TOUCH_4         @"iPod Touch 4"
#define DEVICE_TYPE_IPOD_TOUCH_5         @"iPod Touch 5"
#define DEVICE_TYPE_IPAD                 @"iPad"
#define DEVICE_TYPE_IPAD_2_WIFI          @"iPad 2, WiFi"
#define DEVICE_TYPE_IPAD_2_WIFI_REV_A    @"iPad 2, WiFi Rev A"
#define DEVICE_TYPE_IPAD_2_GSM           @"iPad 2, GSM"
#define DEVICE_TYPE_IPAD_2_CDMA          @"iPad 2, CDMA"
#define DEVICE_TYPE_IPAD_MINI_WIFI       @"iPad Mini, WiFi"
#define DEVICE_TYPE_IPAD_MINI_GSM        @"iPad Mini, GSM"
#define DEVICE_TYPE_IPAD_MINI_CDMA       @"iPad Mini, CDMA"
#define DEVICE_TYPE_IPAD_3_WIFI          @"iPad 3, WiFi"
#define DEVICE_TYPE_IPAD_3_GSM           @"iPad 3, GSM"
#define DEVICE_TYPE_IPAD_3_CDMA          @"iPad 3, CDMA"
#define DEVICE_TYPE_IPAD_4_WIFI          @"iPad 4, WiFi"
#define DEVICE_TYPE_IPAD_4_GSM           @"iPad 4, GSM"
#define DEVICE_TYPE_IPAD_4_CDMA          @"iPad 4, CDMA"
#define DEVICE_TYPE_IPAD_AIR_WIFI        @"iPad Air, WiFi"
#define DEVICE_TYPE_IPAD_AIR_GSM_CDMA    @"iPad Air, GSM CDMA"
#define DEVICE_TYPE_IPAD_AIR_TD_LTE      @"iPad Air, TD-LTE"
#define DEVICE_TYPE_IPAD_MINI_2_WIFI     @"iPad Mini Retina, WiFi"
#define DEVICE_TYPE_IPAD_MINI_2_CELL     @"iPad Mini Retina, Cellular"
#define DEVICE_TYPE_IPAD_MINI_2_CELL_CN  @"iPad Mini Retina, Cellular CN"
#define DEVICE_TYPE_IPAD_MINI_4_WIFI     @"iPad Mini 4, WiFi"
#define DEVICE_TYPE_IPAD_MINI_4_CELL     @"iPad Mini 4, Cellular"
#define DEVICE_TYPE_IPAD_AIR_2_WIFI      @"iPad Air 2, WiFi"
#define DEVICE_TYPE_IPAD_AIR_2_CELL      @"iPad Air 2, Cellular"
#define DEVICE_TYPE_IPHONE_4_GSM         @"iPhone 4, GSM"
#define DEVICE_TYPE_IPHONE_4_GSM_REV_A   @"iPhone 4, GSM Rev A"
#define DEVICE_TYPE_IPHONE_4_CDMA        @"iPhone 4, CDMA"
#define DEVICE_TYPE_IPHONE_4S_GSM_CDMA   @"iPhone 4S, GSM CDMA"
#define DEVICE_TYPE_IPHONE_5_GSM         @"iPhone 5, GSM"
#define DEVICE_TYPE_IPHONE_5_GSM_CDMA    @"iPhone 5, GSM CDMA"
#define DEVICE_TYPE_IPHONE_5C_GSM        @"iPhone 5C, GSM"
#define DEVICE_TYPE_IPHONE_5C_GSM_CDMA   @"iPhone 5C, GSM CDMA"
#define DEVICE_TYPE_IPHONE_5S_GSM        @"iPhone 5S, GSM"
#define DEVICE_TYPE_IPHONE_5S_GSM_CDMA   @"iPhone 5S, GSM CDMA"
#define DEVICE_TYPE_IPHONE_6             @"iPhone 6"
#define DEVICE_TYPE_IPHONE_6_PLUS        @"iPhone 6 Plus"
#define DEVICE_TYPE_IPHONE_6S            @"iPhone 6S"
#define DEVICE_TYPE_IPHONE_6S_PLUS       @"iPhone 6S Plus"

#define DEVICE_TYPE_UNKNOWN              @"Unknown"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

@implementation UIDevice (Hardware)

- (NSString *)CPUType
{
    return [[self class] CPUType];
}


+ (NSString *)CPUType
{
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86"];
        // We really don't care
        
    }
    else if (type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"ARM"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"V7"];
                break;
            case CPU_SUBTYPE_ARM_V7F:
                [cpu appendString:@"V7[Cortex A9]"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"V7S"];
                break;
            case CPU_SUBTYPE_ARM_V8:
                [cpu appendString:@"V8"];
                break;
            default:
                [cpu appendFormat:@"(%zd)", subtype];
                break;
        }
    }
    else if (type == CPU_TYPE_ARM64)
    {
        [cpu appendString:@"ARM64"];
    }
    
    return cpu;
}

- (NSString *) deviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * type = [NSString stringWithCString:systemInfo.machine
                                         encoding:NSUTF8StringEncoding];
    
    NSDictionary * typeDict = @{
                                @"i386" : DEVICE_TYPE_SIMULATOR_I386,
                                @"x86_64" : DEVICE_TYPE_SIMULATOR_X86_64,
                                @"iPod3,1" : DEVICE_TYPE_IPOD_TOUCH_3,
                                @"iPod4,1" : DEVICE_TYPE_IPOD_TOUCH_4,
                                @"iPod5,1" : DEVICE_TYPE_IPOD_TOUCH_5,
                                @"iPad1,1" : DEVICE_TYPE_IPAD,
                                @"iPad2,1" : DEVICE_TYPE_IPAD_2_WIFI,
                                @"iPad2,2" : DEVICE_TYPE_IPAD_2_GSM,
                                @"iPad2,3" : DEVICE_TYPE_IPAD_2_CDMA,
                                @"iPad2,4" : DEVICE_TYPE_IPAD_2_WIFI_REV_A,
                                @"iPad2,5" : DEVICE_TYPE_IPAD_MINI_WIFI,
                                @"iPad2,6" : DEVICE_TYPE_IPAD_MINI_GSM,
                                @"iPad2,7" : DEVICE_TYPE_IPAD_MINI_CDMA,
                                @"iPad3,1" : DEVICE_TYPE_IPAD_3_WIFI,
                                @"iPad3,2" : DEVICE_TYPE_IPAD_3_CDMA,
                                @"iPad3,3" : DEVICE_TYPE_IPAD_3_GSM,
                                @"iPad3,4" : DEVICE_TYPE_IPAD_4_WIFI,
                                @"iPad3,5" : DEVICE_TYPE_IPAD_4_GSM,
                                @"iPad3,6" : DEVICE_TYPE_IPAD_4_CDMA,
                                @"iPad4,1" : DEVICE_TYPE_IPAD_AIR_WIFI,
                                @"iPad4,2" : DEVICE_TYPE_IPAD_AIR_GSM_CDMA,
                                @"iPad4,3" : DEVICE_TYPE_IPAD_AIR_TD_LTE,
                                @"iPad4,4" : DEVICE_TYPE_IPAD_MINI_2_WIFI,
                                @"iPad4,5" : DEVICE_TYPE_IPAD_MINI_2_CELL,
                                @"iPad4,6" : DEVICE_TYPE_IPAD_MINI_2_CELL_CN,
                                @"iPad5,1" : DEVICE_TYPE_IPAD_MINI_4_WIFI,
                                @"iPad5,2" : DEVICE_TYPE_IPAD_MINI_4_CELL,
                                @"iPad5,3" : DEVICE_TYPE_IPAD_AIR_2_WIFI,
                                @"iPad5,4" : DEVICE_TYPE_IPAD_AIR_2_CELL,
                                @"iPhone3,1" : DEVICE_TYPE_IPHONE_4_GSM,
                                @"iPhone3,2" : DEVICE_TYPE_IPHONE_4_GSM_REV_A,
                                @"iPhone3,3" : DEVICE_TYPE_IPHONE_4_CDMA,
                                @"iPhone4,1" : DEVICE_TYPE_IPHONE_4S_GSM_CDMA,
                                @"iPhone5,1" : DEVICE_TYPE_IPHONE_5_GSM,
                                @"iPhone5,2" : DEVICE_TYPE_IPHONE_5_GSM_CDMA,
                                @"iPhone5,3" : DEVICE_TYPE_IPHONE_5C_GSM,
                                @"iPhone5,4" : DEVICE_TYPE_IPHONE_5C_GSM_CDMA,
                                @"iPhone6,1" : DEVICE_TYPE_IPHONE_5S_GSM,
                                @"iPhone6,2" : DEVICE_TYPE_IPHONE_5S_GSM_CDMA,
                                @"iPhone7,1" : DEVICE_TYPE_IPHONE_6_PLUS,
                                @"iPhone7,2" : DEVICE_TYPE_IPHONE_6,
                                @"iPhone8,1" : DEVICE_TYPE_IPHONE_6S,
                                @"iPhone8,2" : DEVICE_TYPE_IPHONE_6S_PLUS
                                };
    
    NSString * model = typeDict[type];
    if (model == nil)
        model = [NSString stringWithFormat:@"%@: %@", DEVICE_TYPE_UNKNOWN, type];
    
    return model;
}

- (BOOL) versionLessThaniOS7
{
    return [self versionLessThan:@"7.0"];
}

- (BOOL) versionGreaterThanEqualiOS7
{
    return ![self versionLessThaniOS7];
}

- (BOOL) versionLessThaniOS8
{
    return [self versionLessThan:@"8.0"];
}

- (BOOL) versionGreaterThanEqualiOS8
{
    return ![self versionLessThaniOS8];
}


- (BOOL) versionLessThan:(NSString *)version
{
    return ([[[UIDevice currentDevice] systemVersion] compare:version
                                                      options:NSNumericSearch]
            == NSOrderedAscending);
}

+ (NSInteger)iOSVersion
{
    static NSInteger s_iOS_Version = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * systemVersion = [[self currentDevice] systemVersion];
        NSArray * tokenizedVersion = [systemVersion componentsSeparatedByString:@"."];
        s_iOS_Version = [[tokenizedVersion firstObject] integerValue];
    });
    
    return s_iOS_Version;
}

+ (BOOL)isIPad
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIPhone
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isIPhone6Plus
{
    return ([self isIPhone] &&  SCREEN_MAX_LENGTH == 736.0f);
}

+ (BOOL)isIPhone6
{
    return ([self isIPhone] &&  SCREEN_MAX_LENGTH == 667.0f);
}

+ (BOOL)isIPhone5
{
    return ([self isIPhone] &&  SCREEN_MAX_LENGTH == 568.0f);
}

+ (BOOL)isIPhone4AndBelow
{
    return ([self isIPhone] &&  SCREEN_MAX_LENGTH < 568.0f);
}

+ (void)logProfile
{
    // Device information
//    O1LOG_APP_GENERAL_DBG(@"name: %@\n", [[UIDevice currentDevice] name]);
//    O1LOG_APP_GENERAL_DBG(@"systemName: %@\n", [[UIDevice currentDevice] systemName]);
//    O1LOG_APP_GENERAL_DBG(@"systemVersion: %@\n", [[UIDevice currentDevice] systemVersion]);
//    O1LOG_APP_GENERAL_DBG(@"model: %@\n", [[UIDevice currentDevice] model]);
//    O1LOG_APP_GENERAL_DBG(@"localizedModel: %@\n", [[UIDevice currentDevice] localizedModel]);
//    O1LOG_APP_GENERAL_DBG(@"modelName: %@\n", [[UIDevice currentDevice] deviceType]);
}

+ (BOOL)isTouchIDAvailabe
{
    if ([LAContext class])
    {
        LAContext * context = [[LAContext alloc] init];
        return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                    error:NULL];
    }
    return NO;
}

@end
