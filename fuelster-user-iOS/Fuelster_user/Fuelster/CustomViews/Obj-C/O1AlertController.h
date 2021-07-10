//
//  O1AlertController.h
//  Workspot
//
//  Created by Ji Fang on 10/31/14.
//  Copyright (c) 2014 O1 Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "O1Helper.h"


@class O1AlertAction;

@interface O1AlertController : NSObject

// This method has the same signature as UIAlertController. A simply macro
// definition could make this work when we deprecate the support for iOS7
+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle;

// This method has the same signature as UIAlertView to help refactoring
// existing UIALertView
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id <UIAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)addAction:(O1AlertAction *)action;

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

- (NSArray *)textFields;

- (NSArray *)actions;

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

- (void)presentAlertAnimated:(BOOL)flag
                          by:(UIViewController *)presentingViewController
                  completion:(O1CompletionBlock)completion;
@end

