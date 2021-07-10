//
//  DateTimeLabel.h
//  Fuelster
//
//  Created by Kareem on 24/09/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateTimeLabel : UILabel
@property (strong,nonnull) UILabel * dateLabel, * timeLabel, * amPmLabel;
-(void)setTimeText:(NSString *)string;
-(void)updateFrames;
-(void)initilizeSubView;
@end
