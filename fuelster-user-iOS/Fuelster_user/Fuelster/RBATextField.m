//
//  RBATextField.m
//  VMC
//
//  Created by Karimulla on 17/09/13.
//  Copyright (c) 2013 RapidbizApps. All rights reserved.
//

#import "RBATextField.h"

@implementation RBATextField
@synthesize paddingX, paddingY;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (CGRect) textRectForBounds: (CGRect) bounds
{
    CGRect origValue = [super textRectForBounds: bounds];
    
    /* Just a sample offset */
    if (!paddingX && !paddingY) {
        return CGRectOffset(origValue, 10.0f, 0.0f);
    }else
        return CGRectOffset(origValue, paddingX, paddingY);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGRect) editingRectForBounds: (CGRect) bounds
{
    CGRect origValue = [super textRectForBounds: bounds];
    
    /* Just a sample offset */
    
    if (!paddingX && !paddingY) {
        return CGRectOffset(origValue, 10.0f, 0.0f);
    }else
        return CGRectOffset(origValue, paddingX, paddingY);
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect origValue = [super leftViewRectForBounds: bounds];

    if (!paddingX && !paddingY) {
        return CGRectOffset(origValue, 10.0f, 0.0f);
    }else
        return CGRectOffset(origValue, paddingX, paddingY);
}


- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect origValue = [super rightViewRectForBounds: bounds];

    if (!paddingX && !paddingY) {
        return CGRectOffset(origValue, - 10.0f, 0.0f);
    }else
        return CGRectOffset(origValue, paddingX, paddingY);
}


@end
