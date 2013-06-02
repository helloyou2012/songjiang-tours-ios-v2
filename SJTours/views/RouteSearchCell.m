//
//  RouteSearchCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/14/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "RouteSearchCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation RouteSearchCell

@synthesize backView=_backView;
@synthesize titleLabel=_titleLabel;
@synthesize tipLabel=_tipLabel;
@synthesize isInitView=_isInitView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createViews:(NSDictionary*)dict{
    if (!_isInitView) {
        CALayer *layer=_backView.layer;
        //是否设置边框以及是否可见
        [layer setMasksToBounds:YES];
        layer.backgroundColor=[[UIColor whiteColor] CGColor];
        //设置阴影
        layer.shadowColor=[[UIColor blackColor] CGColor];
        layer.shadowRadius = 1.f;
        layer.shadowOffset = CGSizeMake(2.f, 2.f);
        layer.shadowOpacity = 0.3f;
        //设置边框线的宽
        [layer setBorderWidth:1];
        //设置边框线的颜色
        UIColor *borderColor=[UIColor colorWithWhite:0.9f alpha:1.0f];
        [layer setBorderColor:[borderColor CGColor]];
        _isInitView=YES;
    }
    _titleLabel.text=[dict objectForKey:@"title"];
    _tipLabel.text=[dict objectForKey:@"tip"];
}

@end
