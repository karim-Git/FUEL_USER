//
//  RBAPopup.h
//  Sample
//
//  Created by Prasad on 11/1/13.
//  Copyright (c) 2013 rapidBizApps. All rights reserved.
//

//Ref From:  https://github.com/chrismiles/CMPopTipView


#import <UIKit/UIKit.h>

typedef enum { 
    PinDirectionAny = 0,
	PinDirectionUp,
	PinDirectionDown,
} PinDirection;

typedef enum {
    PopTipAnimationSlide = 0,
    PopTipAnimationPop
} PopTipAnimation;


@protocol RBAPopupDelegate;

@interface RBAPopup : UIView

@property (nonatomic, weak)            id<RBAPopupDelegate>	delegate;

@property (nonatomic, strong)			NSString				*title;
@property (nonatomic, strong)			NSString				*message;
@property (nonatomic, strong)           UIView	                *customView;

@property (nonatomic, strong)			UIColor					*backgroundColor;
@property (nonatomic, strong)			UIColor					*borderColor;

@property (nonatomic, strong)			UIColor					*titleTextColor;
@property (nonatomic, strong)			UIColor					*messageTextColor;

@property (nonatomic, strong)			UIFont					*titleFont;
@property (nonatomic, strong)			UIFont					*messageFont;

@property (nonatomic, assign)           CGFloat                 cornerRadius;
@property (nonatomic, assign)			CGFloat                 borderWidth;
@property (nonatomic, assign)           CGFloat                 bubbleWidth;



@property (nonatomic, assign)			NSTextAlignment     titleTextAlignment;
@property (nonatomic, assign)			NSTextAlignment     messageTextAlignment;
@property (nonatomic, strong, readonly) id                      targetObject;

@property (nonatomic, assign)			BOOL                    disableTapToDismiss;
@property (nonatomic, assign)			BOOL                    dismissTapAnywhere;

@property (nonatomic, assign)           BOOL                    has3DStyle;
@property (nonatomic, assign)           BOOL                    hasShadow;


@property (nonatomic, assign)           CGFloat                 sidePadding;
@property (nonatomic, assign)           CGFloat                 topMargin;

@property (nonatomic, assign)           PopTipAnimation       animation;
@property (nonatomic, assign)           PinDirection          preferredPinDirection;



// Initialization methods 
- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow  delegate: (id)delegate titleColor:(UIColor *)titleColor  messageColor:(UIColor *)messageColor  backGroundColor:(UIColor *)backGroundColor borderColor:(UIColor *)borderColor;

- (id)initWithCustomView:(UIView *)aView;

//- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow;
//- (id)initWithMessage:(NSString *)messageToShow;


- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated;
- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;
- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal;
- (PinDirection) getPinDirection;

@end


@protocol RBAPopupDelegate <NSObject>
- (void)popTipViewWasDismissedByUser:(RBAPopup *)popTipView;
@end
