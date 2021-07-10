//
//  DateTimeLabel.m
//  Fuelster
//
//  Created by Kareem on 24/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "DateTimeLabel.h"
#import "UIFont+Font.h"
#import "UIColor+Color.h"
@implementation DateTimeLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self initilizeSubView];
}


-(id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        
    }
    return self;
}
-(void)updateFrames
{
    float x = 0;
    float y = 0;
    
    self.dateLabel.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height/4.0f);
    y = CGRectGetMaxY(self.dateLabel.frame);
    
    self.timeLabel.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height/2.0f);
    y = CGRectGetMaxY(self.timeLabel.frame);
    
    self.amPmLabel.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height/4.0f);
    
    
}

-(void)setTimeText:(NSString *)string
{
    NSArray * titlesArray = [string componentsSeparatedByString:@" "];
    self.dateLabel.text = [titlesArray objectAtIndex:0];
    self.timeLabel.text = [titlesArray objectAtIndex:1];
    if (titlesArray.count == 3) {
        self.amPmLabel.text = [titlesArray objectAtIndex:2];
    }
    else {
        self.amPmLabel.text = @"";
    }
}

-(void)initilizeSubView
{
    if (self.dateLabel == nil)
    {
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = [UIFont appRegularFontWithSize12];
        self.dateLabel.textColor = [UIColor appUltraLightFontColor];
        [self addSubview:self.dateLabel];
    }
    if (self.timeLabel == nil)
    {
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont appBoldFontWithSize15];
        //  self.timeLabel.textColor = [UIColor appLightFontColor];
        [self addSubview:self.timeLabel];
    }
    if (self.amPmLabel == nil)
    {
        self.amPmLabel = [[UILabel alloc] init];
        self.amPmLabel.textAlignment = NSTextAlignmentRight;
        self.amPmLabel.font = [UIFont appRegularFontWithSize12];
        //  self.amPmLabel.textColor = [UIColor appLightFontColor];
        [self addSubview:self.amPmLabel];
    }
}
@end
