//
//  O1AlertController.m
//  Workspot
//
//  Created by Ji Fang on 10/31/14.
//  Copyright (c) 2014 O1 Works. All rights reserved.
//

@import UIKit;




#import "O1AlertAction.h"
#import "O1AlertController.h"

@interface O1AlertController () <UIActionSheetDelegate, UIAlertViewDelegate>

#pragma mark - properties for UIAlertView prior to iOS8

@property (nonatomic, weak) id <UIAlertViewDelegate> legacyAlertViewDelegate;

@property (nonatomic, strong) UIAlertView * alertView; //iOS7 and before

@property (nonatomic, strong) UIActionSheet * actionSheet; //iOS7 and before

@property (nonatomic, strong) NSString * cancelButtonTitle; //iOS7 and before

@property (nonatomic, strong) NSString * destructiveButtonTitle; //iOS7 and before

@property (nonatomic, strong) NSMutableArray * alertActions;

@property (nonatomic, strong) NSMutableArray * legacyTextFields;

@property (nonatomic, strong) O1CompletionBlock presentCompletionBlock;

@property (nonatomic, strong) O1CompletionBlock dismissCompletionBlock;

#pragma mark - properties for UIAlertController in iOS8

@property (nonatomic, weak) UIViewController * presentingViewController;

@property (nonatomic, strong) UIAlertController * alertController; //iOS8 and later

@property (nonatomic, strong) O1AlertController * myself;


@end

@implementation O1AlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title
                                 message:(NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    O1AlertController * controller = [[[self class] alloc] initWithTitle:title
                                                                 message:message
                                                                delegate:nil
                                                          preferredStyle:preferredStyle
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:nil];
    
    return controller;
}

#pragma mark - properties for UIAlertView prior to iOS8

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id <UIAlertViewDelegate>)delegate
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    return [self initWithTitle:title
                       message:message
                      delegate:delegate
                preferredStyle:UIAlertControllerStyleAlert
             cancelButtonTitle:cancelButtonTitle
             otherButtonTitles:otherButtonTitles, nil];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     delegate:(id <UIAlertViewDelegate>)delegate
               preferredStyle:(UIAlertControllerStyle)preferredStyle
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super init];
    self.legacyAlertViewDelegate = delegate;

    if ([UIAlertController class])
    {
        if (delegate)
        {
           // O1AssertMsg([delegate isKindOfClass:[UIViewController class]], @"We should avoid using non UIViewController to initiate a UIAlert");
        }
        
        self.presentingViewController = (UIViewController *)delegate;
        self.alertController = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:preferredStyle];
        
        NSInteger buttonIndex = 0;
        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString * title = otherButtonTitles; title != nil; title = va_arg(args, NSString*))
        {
            UIAlertAction * action = [UIAlertAction actionWithTitle:title
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                
                                                                if ([self.legacyAlertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                                                {
                                                                    UIAlertView *alertView;
                                                                    [self.legacyAlertViewDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
                                                                }
                                                                
                                                                self.myself = nil;
                                                            }];
            [self.alertController addAction:action];
            
            ++buttonIndex;
        }
        va_end(args);
        
        if (cancelButtonTitle)
        {
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:title
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {
                                                                      
                                                                      if ([self.legacyAlertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                                                                      {
                                                                          UIAlertView *alertView;
                                                                          [self.legacyAlertViewDelegate alertView:alertView clickedButtonAtIndex:-1];
                                                                      }
                                                                      
                                                                      self.myself = nil;
                                                                  }];
            [self.alertController addAction:cancelAction];
        }
    }
    else if (preferredStyle == UIAlertControllerStyleActionSheet)
    {
   //     O1Assert(otherButtonTitles == nil);
        self.alertActions = [NSMutableArray new];
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:self
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    else
    {
        self.alertActions = [NSMutableArray new];
        self.legacyTextFields = [NSMutableArray new];
        self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles, nil];
    }

    self.myself = self;
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground:(NSNotification *)note
{
    self.actionSheet.delegate = nil;

    [self.actionSheet dismissWithClickedButtonIndex:[self cancelButtonIndex]
                                           animated:NO];
    
    NSInteger idx = [self cancelButtonIndex];
    if (idx != -1)
    {
        O1AlertAction * cancelAction = self.actions[idx];
        if (cancelAction.callback)
            cancelAction.callback(cancelAction);
    }
    
    self.actionSheet = nil;
    
    [self actionSheet:self.actionSheet didDismissWithButtonIndex:idx];
}

- (void)setTitle:(NSString *)title
{
    if (self.alertView)
    {
        self.alertView.title = title;
    }
    else if (self.actionSheet)
    {
        self.actionSheet.title = title;
    }
    else
    {
        self.alertController.title = title;
    }
}

- (NSString *)title
{
    if (self.alertView)
    {
        return self.alertView.title;
    }
    else if (self.actionSheet)
    {
        return self.actionSheet.title;
    }
    
    return self.alertController.title;
}

- (void)setMessage:(NSString *)message
{
    if (self.alertView)
    {
        self.alertView.message = message;
    }
    else
    {
        self.alertController.message = message;
    }
}

- (NSString *)message
{
    if (self.alertView)
    {
        return self.alertView.message;
    }
    
    return self.alertController.message;
}

- (NSInteger)addButtonWithTitle:(NSString *)title
{
    if (self.alertView)
    {
        return [self.alertView addButtonWithTitle:title];
    }
    
    return -1;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex
{
    if (self.alertView)
    {
        return [self.alertView buttonTitleAtIndex:buttonIndex];
    }
    
    return nil;
}

- (NSInteger)cancelButtonIndex
{
    if (self.alertView || self.actionSheet)
    {
        __block NSInteger cancelButtonIndex = -1;
        [self.alertActions enumerateObjectsUsingBlock:^(O1AlertAction * action, NSUInteger idx, BOOL *stop) {
            if (action.style == UIAlertActionStyleCancel)
            {
                cancelButtonIndex = idx;
                *stop = YES;
            }
        }];
        
        return cancelButtonIndex;
    }
    
    return -1;
}

- (void)presentAlertAnimated:(BOOL)flag
                          by:(UIViewController *)presentingViewController
                  completion:(O1CompletionBlock)completion
{
    self.presentingViewController = presentingViewController;
    
    if (self.alertView)
    {
        [self.alertView show];
    }
    else if (self.actionSheet)
    {
        [self.actionSheet showInView:presentingViewController.view];
    }
    else
    {
        [self.presentingViewController presentViewController:self.alertController
                                                    animated:flag
                                                  completion:completion];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.alertView)
    {
        [self.alertView dismissWithClickedButtonIndex:[self cancelButtonIndex]
                                             animated:flag];
        self.dismissCompletionBlock = completion;
    }
    else if (self.actionSheet)
    {
        [self.actionSheet dismissWithClickedButtonIndex:0
                                               animated:flag];
        self.dismissCompletionBlock = completion;
    }
    else
    {
        [self.alertController dismissViewControllerAnimated:flag completion:completion];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (self.presentCompletionBlock)
        self.presentCompletionBlock();
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (self.alertView)
    {
        [self dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
    else
    {
        [self.alertController dismissViewControllerAnimated:animated completion:^{}];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.legacyAlertViewDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [self.legacyAlertViewDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
    else
    {
        if ([self.alertActions count] > buttonIndex)
        {
            O1AlertAction * action = self.alertActions[buttonIndex];
            if (action.callback)
                action.callback(action);
        }
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.legacyAlertViewDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
    {
        [self.legacyAlertViewDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([self.legacyAlertViewDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
    {
        [self.legacyAlertViewDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
    
    if (self.dismissCompletionBlock)
    {
        self.dismissCompletionBlock();
        self.dismissCompletionBlock = nil;
    }
    
    self.myself = nil;
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if ([self.legacyAlertViewDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)])
    {
        return [self.legacyAlertViewDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    else
    {
        // We need to post the notification here because the notification sent
        // by system is too late.
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification
                                                            object:[self.legacyTextFields firstObject]
                                                          userInfo:nil];
        
        NSInteger firstOtherButtonIndex = 0;
        if ([self cancelButtonIndex] == 0)
            firstOtherButtonIndex = 1;
        
        if (firstOtherButtonIndex < [self.alertActions count])
        {
            O1AlertAction * action = self.alertActions[firstOtherButtonIndex];
            return action.isEnabled;
        }
    }
    
    return YES;
}

#pragma mark - properties for iOS 8
- (void)addAction:(O1AlertAction *)action
{
    if (action.alertAction)
    {
        __weak typeof(self) weakself = self;
        action.completionBlock = ^() {
            weakself.myself = nil;
        };
        [self.alertController addAction:action.alertAction];
    }
    else
    {
        [self.alertActions addObject:action];
        
        if (self.alertView)
        {
            [self.alertView addButtonWithTitle:action.title];
        }
        else
        {
            if (action.style == UIAlertActionStyleCancel)
                self.cancelButtonTitle = action.title;
            else if (action.style == UIAlertActionStyleDestructive)
                self.destructiveButtonTitle = action.title;
            
            self.actionSheet.delegate = nil;
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:[self title]
                                                           delegate:self
                                                  cancelButtonTitle:self.cancelButtonTitle
                                             destructiveButtonTitle:self.destructiveButtonTitle
                                                  otherButtonTitles:nil];
            
            [self.alertActions enumerateObjectsUsingBlock:^(O1AlertAction * otherAction, NSUInteger idx, BOOL *stop) {
                if (otherAction.style == UIAlertActionStyleDefault)
                {
                    [self.actionSheet addButtonWithTitle:otherAction.title];
                }
            }];
        }
    }
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler
{
    if (self.alertView)
    {
        NSInteger cancelButtonIndex = [self cancelButtonIndex];
        NSInteger firstOtherButtonIndex = 0;
        if (cancelButtonIndex == 0)
            firstOtherButtonIndex = 1;
        
        NSString * cancelButtonTitle = nil;
        NSString * firstOtherButtonTitle = nil;
        
        if (cancelButtonIndex < [self.alertActions count])
            cancelButtonTitle = [self.alertActions[cancelButtonIndex] title];
        if (firstOtherButtonIndex < [self.alertActions count])
            firstOtherButtonTitle = [self.alertActions[firstOtherButtonIndex] title];
        
       // O1AssertMsg(firstOtherButtonTitle, @"On iOS 7, you have to add at least one alert action block before adding any textfield.\n");

        self.alertView.delegate = nil;
        self.alertView = [[UIAlertView alloc] initWithTitle:[self title]
                                                    message:[self message]
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:firstOtherButtonTitle, nil];
        
        self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        self.alertView.delegate = self;
        
        [self.alertActions enumerateObjectsUsingBlock:^(O1AlertAction * action, NSUInteger idx, BOOL *stop) {
            if (idx > firstOtherButtonIndex && action.style != UIAlertActionStyleCancel)
            {
                [self.alertView addButtonWithTitle:action.title];
            }
        }];
        
        UITextField * textField = [self.alertView textFieldAtIndex:0];
        [self.legacyTextFields addObject:textField];
        
        if (configurationHandler)
            configurationHandler(textField);
    }
    else
    {
        [self.alertController addTextFieldWithConfigurationHandler:configurationHandler];
    }
}

- (NSArray *)textFields
{
    if (self.alertView)
        return self.legacyTextFields;
    else
        return self.alertController.textFields;
}

- (NSArray *)actions
{
    if (self.alertView)
        return self.alertActions;
    else
        return self.alertController.actions;
}

#pragma mark - UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.alertActions count] > buttonIndex)
    {
        O1AlertAction * action = self.alertActions[buttonIndex];
        if (action.callback)
            action.callback(action);
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    if (self.presentCompletionBlock)
        self.presentCompletionBlock();
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (self.dismissCompletionBlock)
    {
        self.dismissCompletionBlock();
        self.dismissCompletionBlock = nil;
    }

    self.myself = nil;
}

@end



#pragma mark - O1Alert 

void O1AlertOK(UIViewController * presentingController, NSString * titleInNSString, NSString * messageInNSString)
{
    O1AlertController * alert = [O1AlertController alertControllerWithTitle:titleInNSString
                                                                    message:messageInNSString
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    alert.legacyAlertViewDelegate = nil;
    
    [alert addAction:[O1AlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                              style:UIAlertActionStyleDefault
                                            handler:NULL]];
    if (presentingController != nil)
    {
        
        if ([alert isKindOfClass:[UIAlertController class]])
        {
            [presentingController presentViewController:(UIViewController *)alert
                               animated:YES
                             completion:^{}];
        }
        else
        {
            [alert presentAlertAnimated:YES by:presentingController completion:^{}];
        }
    }
    else
    {
        [alert presentAlertAnimated:YES by:nil completion:^{}];
    }
}
