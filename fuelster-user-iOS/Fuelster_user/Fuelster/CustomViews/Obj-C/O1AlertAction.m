//
//  O1AlertAction.m
//  O1Util
//
//  Created by Ji Fang on 11/4/14.
//  Copyright (c) 2014 Workspot. All rights reserved.
//

#import "O1AlertAction.h"


@interface O1AlertAction ()

@property (nonatomic, readwrite, strong) UIAlertAction * alertAction;
@property (nonatomic, readwrite, strong) NSString * title;
@property (nonatomic, readwrite) UIAlertActionStyle style;

@end

@implementation O1AlertAction

+ (instancetype)actionWithTitle:(NSString *)title
                          style:(UIAlertActionStyle)style
                        handler:(O1AlertActionCallBack)handler
{
    O1AlertAction * action = [O1AlertAction new];
    action.style = style;
    action.title = title;
    
    if ([UIAlertAction class])
    {
        action.alertAction = [UIAlertAction actionWithTitle:title
                                                    style:style
                                                  handler:^(UIAlertAction *_action) {
                                                      if (handler)
                                                      {
                                                          handler(action);
                                                      }
                                                      if (action.completionBlock)
                                                          action.completionBlock();
                                                  }];
    }
    else
    {
        action.callback = handler;
    }
    
    return action;
}

- (void)setEnabled:(BOOL)enabled
{
    self.alertAction.enabled = enabled;
    _enabled = enabled;
}

@end

