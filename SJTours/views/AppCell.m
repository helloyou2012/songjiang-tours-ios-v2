//
//  AppCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 7/4/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "AppCell.h"
#import "UIImageView+WebCache.h"
#import "RequestUrls.h"

@implementation AppCell

@synthesize smallImage=_smallImage;
@synthesize aTitle=_aTitle;
@synthesize aContent=_aContent;

- (void)createView:(NSDictionary *)dict{
    NSString *url=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[dict objectForKey:@"aimage"]];
    NSURL *imageUrl=[NSURL URLWithString:url];
    [_smallImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _smallImage.backgroundColor=[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.0f];
    _aTitle.text=[dict objectForKey:@"atitle"];
    _aContent.text=[dict objectForKey:@"acontent"];
    _aTitle.textColor=[UIColor blackColor];
    _aTitle.highlightedTextColor=[UIColor blackColor];
    _aContent.textColor=[UIColor lightGrayColor];
    _aContent.highlightedTextColor=[UIColor lightGrayColor];
}

@end