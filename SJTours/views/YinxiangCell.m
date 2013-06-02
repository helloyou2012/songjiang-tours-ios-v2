//
//  YinxiangCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/15/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "YinxiangCell.h"
#import "UIImageView+WebCache.h"
#import "RequestUrls.h"

@implementation YinxiangCell

@synthesize bgView=_bgView;
@synthesize imagesView=_imagesView;
@synthesize titleView=_titleView;

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

- (void) createViews:(NSDictionary*)dict{
    NSString *url=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[dict objectForKey:@"gimage"]];
    NSURL *imageUrl=[[NSURL alloc] initWithString:url];
    [_imagesView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _imagesView.backgroundColor=[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.0f];
    _titleView.text=[dict objectForKey:@"gname"];
}

@end
