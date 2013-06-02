//
//  RouteDetailCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/15/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "RouteDetailCell.h"

@implementation RouteDetailCell

@synthesize imageWay=_imageWay;
@synthesize titleWay=_titleWay;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageWay=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
        [self.contentView addSubview:_imageWay];
        
        _titleWay=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 270, 10)];
        _titleWay.backgroundColor=[UIColor clearColor];
        _titleWay.font=[UIFont systemFontOfSize:14.0f];
        _titleWay.textColor=[UIColor blackColor];
        _titleWay.lineBreakMode = UILineBreakModeWordWrap;
        _titleWay.numberOfLines = 0;
        [self.contentView addSubview:_titleWay];
        
        self.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
