//
//  O1AlertAction.h
//  O1Util
//
//  Created by Ji Fang on 11/4/14.
//  Copyright (c) 2014 Workspot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "O1Helper.h"


@class O1AlertAction;

typedef void (^O1AlertActionCallBack)(O1AlertAction *action);

@interface O1AlertAction : NSObject

@property (nonatomic, readonly, strong) UIAlertAction * alertAction;
@property (nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) UIAlertActionStyle style;
@property (nonatomic, strong) O1AlertActionCallBack callback;
@property (nonatomic, strong) O1CompletionBlock completionBlock;
@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(UIAlertActionStyle)style
                        handler:(O1AlertActionCallBack)handler;
@end

