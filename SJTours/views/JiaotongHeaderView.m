//
//  JiaotongHeaderView.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/3/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "JiaotongHeaderView.h"

@implementation JiaotongHeaderView

@synthesize timeGapLabel=_timeGapLabel;
@synthesize firstTimeLabel=_firstTimeLabel;
@synthesize lastTimeLabel=_lastTimeLabel;
@synthesize titleLabel=_titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createViewData:(NSDictionary*)dict{
    _titleLabel.text=[dict objectForKey:@"tfline"];
    _firstTimeLabel.text=[NSString stringWithFormat:@"首班车：%@",[dict objectForKey:@"tffirstexpress"]];
    _lastTimeLabel.text=[NSString stringWithFormat:@"末班车：%@",[dict objectForKey:@"tflastexpress"]];
    _timeGapLabel.text=[NSString stringWithFormat:@"途径：%@",[dict objectForKey:@"tfintervaltime"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
