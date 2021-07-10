//
//  RBAPopup.m
//  Sample
//
//  Created by Prasad on 11/1/13.
//  Copyright (c) 2013 rapidBizApps. All rights reserved.
//

#import "RBAPopup.h"
#import "UIColor+Color.h"



@interface RBAPopup ()
{
	CGSize					popupViewSize;
    BOOL					isHilight;
	PinDirection			pinDirection;
	CGFloat				_cornerRadius;
	CGFloat				_pointerSize;
	CGPoint				_targetPoint;
}

@property (nonatomic, strong, readwrite)	id	targetObject;
@property (nonatomic, strong) NSTimer *autoDismissTimer;
@property (nonatomic, strong) UIButton *dismissTarget;
@end


@implementation RBAPopup

- (CGRect)bubbleFrame
{
	CGRect bubbleFrame;
	if (pinDirection == PinDirectionUp)
    {
		bubbleFrame = CGRectMake(_sidePadding, _targetPoint.y+_pointerSize, popupViewSize.width, popupViewSize.height);
	}
	else
    {
		bubbleFrame = CGRectMake(_sidePadding, _targetPoint.y-_pointerSize-popupViewSize.height, popupViewSize.width, popupViewSize.height);
	}
	return bubbleFrame;
}

- (CGRect)contentFrame
{
	CGRect bubbleFrame = [self bubbleFrame];
	CGRect contentFrame = CGRectMake(bubbleFrame.origin.x + _cornerRadius,
									 bubbleFrame.origin.y + _cornerRadius,
									 bubbleFrame.size.width - _cornerRadius*2,
									 bubbleFrame.size.height - _cornerRadius*2);
	return contentFrame;
}

- (void)layoutSubviews
{
	if (self.customView)
    {
		CGRect contentFrame = [self contentFrame];
        [self.customView setFrame:contentFrame];
    }
}

- (void)drawRect:(CGRect)rect
{
	CGRect bubbleRect = [self bubbleFrame];
	
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(currentContext, 0.0, 0.0, 0.0, 1.0);
	CGContextSetLineWidth(currentContext, self.borderWidth);
    
	CGMutablePathRef bubblePath = CGPathCreateMutable();
	
	if (pinDirection == PinDirectionUp)
    {
		CGPathMoveToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding, _targetPoint.y);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding+_pointerSize, _targetPoint.y+_pointerSize);
		
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x+bubbleRect.size.width-_cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y,
							bubbleRect.origin.x+_cornerRadius, bubbleRect.origin.y,
							_cornerRadius);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding-_pointerSize, _targetPoint.y+_pointerSize);
	}
	else
    {
		CGPathMoveToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding, _targetPoint.y);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding-_pointerSize, _targetPoint.y-_pointerSize);
		
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x, bubbleRect.origin.y+bubbleRect.size.height-_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x, bubbleRect.origin.y,
							bubbleRect.origin.x+_cornerRadius, bubbleRect.origin.y,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+_cornerRadius,
							_cornerRadius);
		CGPathAddArcToPoint(bubblePath, NULL,
							bubbleRect.origin.x+bubbleRect.size.width, bubbleRect.origin.y+bubbleRect.size.height,
							bubbleRect.origin.x+bubbleRect.size.width-_cornerRadius, bubbleRect.origin.y+bubbleRect.size.height,
							_cornerRadius);
		CGPathAddLineToPoint(bubblePath, NULL, _targetPoint.x+_sidePadding+_pointerSize, _targetPoint.y-_pointerSize);
	}
    
	CGPathCloseSubpath(bubblePath);
    
    CGContextSaveGState(currentContext);
	CGContextAddPath(currentContext, bubblePath);
	CGContextClip(currentContext);
    
        // Fill with solid color
        CGContextSetFillColorWithColor(currentContext, [self.backgroundColor CGColor]);
        CGContextFillRect(currentContext, self.bounds);
    
 
	
    // Draw top highlight and bottom shadow
    if (self.has3DStyle)
    {
        CGContextSaveGState(currentContext);
        CGMutablePathRef innerShadowPath = CGPathCreateMutable();
        
        // add a rect larger than the bounds of bubblePath
        CGPathAddRect(innerShadowPath, NULL, CGRectInset(CGPathGetPathBoundingBox(bubblePath), -30, -30));
        
        // add bubblePath to innershadow
        CGPathAddPath(innerShadowPath, NULL, bubblePath);
        CGPathCloseSubpath(innerShadowPath);
        
        // draw top highlight
        UIColor *highlightColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        CGContextSetFillColorWithColor(currentContext, highlightColor.CGColor);
        CGContextSetShadowWithColor(currentContext, CGSizeMake(0.0, 4.0), 4.0, highlightColor.CGColor);
        CGContextAddPath(currentContext, innerShadowPath);
        CGContextEOFillPath(currentContext);
        
        // draw bottom shadow
        UIColor *shadowColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        CGContextSetFillColorWithColor(currentContext, shadowColor.CGColor);
        CGContextSetShadowWithColor(currentContext, CGSizeMake(0.0, -4.0), 4.0, shadowColor.CGColor);
        CGContextAddPath(currentContext, innerShadowPath);
        CGContextEOFillPath(currentContext);
        
        CGPathRelease(innerShadowPath);
        CGContextRestoreGState(currentContext);
    }
	
	CGContextRestoreGState(currentContext);
    
    //Draw Border
    if (self.borderWidth > 0)
    {
        int numBorderComponents = CGColorGetNumberOfComponents([self.borderColor CGColor]);
        const CGFloat *borderComponents = CGColorGetComponents(self.borderColor.CGColor);
        
        CGFloat red, green, blue, alpha;
        
        if (numBorderComponents == 2)
        {
            red = borderComponents[0];
            green = borderComponents[0];
            blue = borderComponents[0];
            alpha = borderComponents[1];
        }
        else
        {
            red = borderComponents[0];
            green = borderComponents[1];
            blue = borderComponents[2];
            alpha = borderComponents[3];
        }
        
        CGContextSetRGBStrokeColor(currentContext, red, green, blue, alpha);
        CGContextAddPath(currentContext, bubblePath);
        CGContextDrawPath(currentContext, kCGPathStroke);
    }
    
	CGPathRelease(bubblePath);
	
	// Draw title and text
    if (self.title)
    {
        [self.titleTextColor set];
        CGRect titleFrame = [self contentFrame];
        [self.title drawInRect:titleFrame
                      withFont:self.titleFont
                 lineBreakMode:NSLineBreakByClipping
                     alignment:self.titleTextAlignment];
    }
	
	if (self.message)
    {
		[self.messageTextColor set];
		CGRect textFrame = [self contentFrame];
        
        // Move down to make room for title
        if (self.title)
        {
            textFrame.origin.y += [self.title sizeWithFont:self.titleFont
                                         constrainedToSize:CGSizeMake(textFrame.size.width, 99999.0)
                                             lineBreakMode:NSLineBreakByClipping].height;
        }
        
        [self.message drawInRect:textFrame
                        withFont:self.messageFont
                   lineBreakMode:NSLineBreakByWordWrapping
                       alignment:self.messageTextAlignment];
    }
}

- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated
{
	if (!self.targetObject)
    {
		self.targetObject = targetView;
	}
    
    // If we want to dismiss the bubble when the user taps anywhere, we need to insert
    // an invisible button over the background.
    if ( self.dismissTapAnywhere )
    {
        self.dismissTarget = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dismissTarget addTarget:self action:@selector(dismissTapAnywhereFired:) forControlEvents:UIControlEventTouchUpInside];
        [self.dismissTarget setTitle:@"" forState:UIControlStateNormal];
        self.dismissTarget.frame = containerView.bounds;
        [containerView addSubview:self.dismissTarget];
    }
	
	[containerView addSubview:self];
    
	// Size of rounded rect
	CGFloat rectWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // iPad
        if (self.bubbleWidth)
        {
            if (self.bubbleWidth < containerView.frame.size.width)
            {
                rectWidth = self.bubbleWidth;
            }
            else
            {
                rectWidth = containerView.frame.size.width - 20;
            }
        }
        else
        {
            rectWidth = (int)(containerView.frame.size.width/3);
        }
    }
    else
    {
        // iPhone
        if (self.bubbleWidth)
        {
            if (self.bubbleWidth < containerView.frame.size.width)
            {
                rectWidth = self.bubbleWidth;
            }
            else
            {
                rectWidth = containerView.frame.size.width - 10;
            }
        }
        else
        {
            rectWidth = (int)(containerView.frame.size.width*2/3);
        }
    }
    
	CGSize textSize = CGSizeZero;
    
    if (self.message!=nil)
    {
        textSize= [self.message sizeWithFont:self.messageFont
                           constrainedToSize:CGSizeMake(rectWidth, 99999.0)
                               lineBreakMode:NSLineBreakByWordWrapping];
    }
    if (self.customView != nil)
    {
        textSize = self.customView.frame.size;
    }
    if (self.title != nil)
    {
        textSize.height += [self.title sizeWithFont:self.titleFont
                                  constrainedToSize:CGSizeMake(rectWidth, 99999.0)
                                      lineBreakMode:NSLineBreakByClipping].height;
    }
    
    float textSizeWidth = textSize.width;
    if(textSizeWidth <= 50)
        textSizeWidth = 60;
    
	popupViewSize = CGSizeMake(textSizeWidth + _cornerRadius*2, textSize.height + _cornerRadius*2);
	
	UIView *superview = containerView.superview;
	if ([superview isKindOfClass:[UIWindow class]])
		superview = containerView;
	
	CGPoint targetRelativeOrigin    = [targetView.superview convertPoint:targetView.frame.origin toView:superview];
	CGPoint containerRelativeOrigin = [superview convertPoint:containerView.frame.origin toView:superview];
    
	CGFloat pointerY;	// Y coordinate of pointer target (within containerView)
	
    
    if (targetRelativeOrigin.y+targetView.bounds.size.height < containerRelativeOrigin.y)
    {
        pointerY = 0.0;
        pinDirection = PinDirectionUp;
    }
    else if (targetRelativeOrigin.y > containerRelativeOrigin.y+containerView.bounds.size.height)
    {
        pointerY = containerView.bounds.size.height;
        pinDirection = PinDirectionDown;
    }
    else
    {
        pinDirection = _preferredPinDirection;
        CGPoint targetOriginInContainer = [targetView convertPoint:CGPointMake(0.0, 0.0) toView:containerView];
        CGFloat sizeBelow = containerView.bounds.size.height - targetOriginInContainer.y;
        if (pinDirection == PinDirectionAny)
        {
            if (sizeBelow > targetOriginInContainer.y)
            {
                pointerY = targetOriginInContainer.y + targetView.bounds.size.height;
                pinDirection = PinDirectionUp;
            }
            else
            {
                pointerY = targetOriginInContainer.y;
                pinDirection = PinDirectionDown;
            }
        }
        else
        {
            if (pinDirection == PinDirectionDown)
            {
                pointerY = targetOriginInContainer.y;
            }
            else
            {
                pointerY = targetOriginInContainer.y + targetView.bounds.size.height;
            }
        }
    }
    
	CGFloat W = containerView.bounds.size.width;
	
	CGPoint p = [targetView.superview convertPoint:targetView.center toView:containerView];
	CGFloat x_p = p.x;
	CGFloat x_b = x_p - roundf(popupViewSize.width/2);
	if (x_b < _sidePadding)
    {
		x_b = _sidePadding;
	}
	if (x_b + popupViewSize.width + _sidePadding > W)
    {
		x_b = W - popupViewSize.width - _sidePadding;
	}
	if (x_p - _pointerSize < x_b + _cornerRadius)
    {
		x_p = x_b + _cornerRadius + _pointerSize;
	}
	if (x_p + _pointerSize > x_b + popupViewSize.width - _cornerRadius)
    {
		x_p = x_b + popupViewSize.width - _cornerRadius - _pointerSize;
	}
	
	CGFloat fullHeight = popupViewSize.height + _pointerSize + 10.0;
	CGFloat y_b;
	if (pinDirection == PinDirectionUp)
    {
		y_b = _topMargin + pointerY;
		_targetPoint = CGPointMake(x_p-x_b, 0);
	}
	else
    {
		y_b = pointerY - fullHeight;
		_targetPoint = CGPointMake(x_p-x_b, fullHeight-2.0);
	}
	
	CGRect finalFrame = CGRectMake(x_b-_sidePadding,
								   y_b,
								   popupViewSize.width+_sidePadding*2,
								   fullHeight);
    
   	
	if (animated) {
        if (self.animation == PopTipAnimationSlide)
        {
            self.alpha = 0.0;
            CGRect startFrame = finalFrame;
            startFrame.origin.y += 10;
            self.frame = startFrame;
        }
		else if (self.animation == PopTipAnimationPop)
        {
            self.frame = finalFrame;
            self.alpha = 0.5;
            
            // start a little smaller
            self.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
            
            // animate to a bigger size
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(popAnimationDidStop:finished:context:)];
            [UIView setAnimationDuration:0.15f];
            self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            self.alpha = 1.0;
            [UIView commitAnimations];
        }
		
		[self setNeedsDisplay];
		
		if (self.animation == PopTipAnimationSlide)
        {
			[UIView beginAnimations:nil context:nil];
			self.alpha = 1.0;
			self.frame = finalFrame;
			[UIView commitAnimations];
		}
	}
	else
    {
		// Not animated
		[self setNeedsDisplay];
		self.frame = finalFrame;
	}
}

- (void)presentPointingAtBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated
{
	UIView *targetView = (UIView *)[barButtonItem performSelector:@selector(view)];
	UIView *targetSuperview = [targetView superview];
	UIView *containerView = nil;
	if ([targetSuperview isKindOfClass:[UINavigationBar class]])
    {
		containerView = [UIApplication sharedApplication].keyWindow;
	}
	else if ([targetSuperview isKindOfClass:[UIToolbar class]])
    {
		containerView = [targetSuperview superview];
	}
	
	if (nil == containerView)
    {
		////NSLog(@"Cannot determine container view from UIBarButtonItem: %@", barButtonItem);
		self.targetObject = nil;
		return;
	}
	
	self.targetObject = barButtonItem;
	
	[self presentPointingAtView:targetView inView:containerView animated:animated];
}

- (void)finaliseDismiss
{
	[self.autoDismissTimer invalidate]; self.autoDismissTimer = nil;
    
    if (self.dismissTarget)
    {
        [self.dismissTarget removeFromSuperview];
		self.dismissTarget = nil;
    }
	
	[self removeFromSuperview];
    
	isHilight = NO;
	self.targetObject = nil;
}

- (void)dismissAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self finaliseDismiss];
}

- (void)dismissAnimated:(BOOL)animated
{
	
	if (animated)
    {
		CGRect frame = self.frame;
		frame.origin.y += 10.0;
		
		[UIView beginAnimations:nil context:nil];
		self.alpha = 0.0;
		self.frame = frame;
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(dismissAnimationDidStop:finished:context:)];
		[UIView commitAnimations];
	}
	else
    {
		[self finaliseDismiss];
	}
}

- (void)autoDismissAnimatedDidFire:(NSTimer *)theTimer
{
    NSNumber *animated = [[theTimer userInfo] objectForKey:@"animated"];
    [self dismissAnimated:[animated boolValue]];
	[self notifyDelegatePopTipViewWasDismissedByUser];
}

- (void)autoDismissAnimated:(BOOL)animated atTimeInterval:(NSTimeInterval)timeInvertal
{
    NSDictionary * userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:animated] forKey:@"animated"];
    
    self.autoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:timeInvertal
															 target:self
														   selector:@selector(autoDismissAnimatedDidFire:)
														   userInfo:userInfo
															repeats:NO];
}

- (void)notifyDelegatePopTipViewWasDismissedByUser
{
	__strong id<RBAPopupDelegate> delegate = self.delegate;
	[delegate popTipViewWasDismissedByUser:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.disableTapToDismiss)
    {
		[super touchesBegan:touches withEvent:event];
		return;
	}
    
	[self dismissByUser];
}

- (void)dismissTapAnywhereFired:(UIButton *)button
{
	[self dismissByUser];
}

- (void)dismissByUser
{
	isHilight = YES;
	[self setNeedsDisplay];
	
	[self dismissAnimated:YES];
	
	[self notifyDelegatePopTipViewWasDismissedByUser];
}

- (void)popAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // at the end set to normal size
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1f];
	self.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // Initialization code
		self.opaque = NO;
        
		_topMargin = 2.0;
		_pointerSize = 12.0;
		_sidePadding = 2.0;
        _borderWidth = 1.0;
		
		self.messageFont = [UIFont boldSystemFontOfSize:14.0];
		self.messageTextColor = [UIColor whiteColor];
		self.messageTextAlignment = NSTextAlignmentCenter;
		self.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:60.0/255.0 blue:154.0/255.0 alpha:1.0];
        self.has3DStyle = NO;
        self.borderColor = [UIColor blackColor];
        self.hasShadow = YES;
        self.animation = PopTipAnimationSlide;
        self.dismissTapAnywhere = YES;
        self.preferredPinDirection = PinDirectionAny;
        self.cornerRadius = 3.0;
        
                
        self.backgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor appUltraLightFontColor];
        self.borderWidth = 0.5;
        self.cornerRadius = 10;

        
    }
    return self;
}

- (void)setHasShadow:(BOOL)isHasShadow
{
    if (isHasShadow)
    {
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity = 0.3;
    }
    else
    {
        self.layer.shadowOpacity = 0.0;
    }
}

- (PinDirection) getPinDirection
{
    return pinDirection;
}


- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow
{
	CGRect frame = CGRectZero;
	
	if ((self = [self initWithFrame:frame]))
    {
        self.title = titleToShow;
		self.message = messageToShow;
        
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.titleTextColor = [UIColor whiteColor];
        self.titleTextAlignment = NSTextAlignmentCenter;
        self.messageFont = [UIFont systemFontOfSize:14.0];
		self.messageTextColor = [UIColor whiteColor];
	}
	return self;
}

- (id)initWithTitle:(NSString *)titleToShow message:(NSString *)messageToShow  delegate: (id)delegate titleColor:(UIColor *)titleColor  messageColor:(UIColor *)messageColor  backGroundColor:(UIColor *)backGroundColor borderColor:(UIColor *)borderColor;
{
    
    CGRect frame = CGRectZero;
	self.delegate = delegate;
	if ((self = [self initWithFrame:frame]))
    {
        self.title = titleToShow;
		self.message = messageToShow;
        
        self.titleFont = [UIFont boldSystemFontOfSize:16.0];
        self.messageFont = [UIFont systemFontOfSize:14.0];
        
        self.titleTextAlignment = NSTextAlignmentCenter;
        
        
        //To set Defaul Colors
        if(messageColor == nil && backGroundColor == nil)
        {
            messageColor = [UIColor whiteColor];
            backGroundColor = [UIColor blackColor];
        }
        else if (messageColor != nil && backGroundColor == nil)
        {
            backGroundColor = [self reverseColorOf:messageColor];
        }
        else  if(messageColor == nil && backGroundColor != nil)
        {
            messageColor = [self reverseColorOf:backGroundColor];
        }
        
        if(titleColor == nil)
            titleColor = messageColor;
        if (borderColor == nil)
            borderColor = backGroundColor;
        
        //Set the colors
        self.backgroundColor = backGroundColor;
        self.borderColor = borderColor;
        self.titleTextColor = titleColor;
        self.messageTextColor = messageColor;
	}
	return self;
}

//====== TO GET THE OPPOSIT COLORS =====
-(UIColor *)reverseColorOf :(UIColor *)oldColor
{
    CGColorRef oldCGColor = oldColor.CGColor;
    
    int numberOfComponents = CGColorGetNumberOfComponents(oldCGColor);
    // can not invert - the only component is the alpha
    if (numberOfComponents == 1) {
        return [UIColor colorWithCGColor:oldCGColor];
    }
    
    const CGFloat *oldComponentColors = CGColorGetComponents(oldCGColor);
    CGFloat newComponentColors[numberOfComponents];
    
    int i = numberOfComponents - 1;
    newComponentColors[i] = oldComponentColors[i]; // alpha
    while (--i >= 0) {
        newComponentColors[i] = 1 - oldComponentColors[i];
    }
    
    CGColorRef newCGColor = CGColorCreate(CGColorGetColorSpace(oldCGColor), newComponentColors);
    UIColor *newColor = [UIColor colorWithCGColor:newCGColor];
    CGColorRelease(newCGColor);
    
    //For the gray colors 'Middle level colors'
    CGFloat white = 0;
    [oldColor getWhite:&white alpha:nil];
    
    if(white>0.3 && white < 0.67)
    {
        if(white >= 0.5)
            newColor = [UIColor darkGrayColor];
        else if (white < 0.5)
            newColor = [UIColor blackColor];
    }
    return newColor;
}

- (id)initWithMessage:(NSString *)messageToShow
{
	CGRect frame = CGRectZero;
	
	if ((self = [self initWithFrame:frame]))
    {
		self.message = messageToShow;
	}
	return self;
}

- (id)initWithCustomView:(UIView *)aView
{
	CGRect frame = CGRectZero;
	
	if ((self = [self initWithFrame:frame]))
    {
		self.customView = aView;
        [self addSubview:self.customView];
	}
	return self;
}

@end
