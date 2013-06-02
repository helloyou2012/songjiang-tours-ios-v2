//
//  JiaotongDetailCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/27/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "JiaotongDetailCell.h"
#import <QuartzCore/QuartzCore.h>

#define LEFT_PADDING 17.0f
#define ROW_HEIGHT 50.0f

@implementation JiaotongDetailCell

@synthesize linetype=_linetype;

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

- (void)createViews:(NSString*)name{
    //开始
    if (_linetype==0) {
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(LEFT_PADDING-3, ROW_HEIGHT/2.0f, 6, ROW_HEIGHT/2)];
        lineView.backgroundColor=[UIColor orangeColor];
        [self addSubview:lineView];
    }
    //中间
    if (_linetype==1) {
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(LEFT_PADDING-3, 0, 6, ROW_HEIGHT)];
        lineView.backgroundColor=[UIColor orangeColor];
        [self addSubview:lineView];
    }
    //结尾
    if (_linetype==2) {
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(LEFT_PADDING-3, 0, 6, ROW_HEIGHT/2)];
        lineView.backgroundColor=[UIColor orangeColor];
        [self addSubview:lineView];
    }
    
    UIView *roundView=[[UIView alloc] initWithFrame:CGRectMake(LEFT_PADDING-9, ROW_HEIGHT/2-9, 18, 18)];
    CALayer *layer=[roundView layer];
    roundView.clipsToBounds=NO;
    layer.cornerRadius=9.0f;
    //设置边框线的宽
    [layer setBorderWidth:2.0f];
    //设置边框线的颜色
    UIColor *bgcolor=[UIColor orangeColor];
    [layer setBorderColor:[bgcolor CGColor]];
    [layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [self addSubview:roundView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(LEFT_PADDING+12, ROW_HEIGHT/2-10, 265, 20)];
    label.text=name;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:14.0f];
    label.textColor=[UIColor blackColor];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;
    [label sizeToFit];
    [self addSubview:label];
}

@end
