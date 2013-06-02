//
//  ZixunCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ZixunCell.h"
#import "UIImageView+WebCache.h"
#import "RequestUrls.h"

@implementation ZixunCell

@synthesize smallImage=_smallImage;
@synthesize gTitle=_gTitle;
@synthesize gDescription=_gDescription;

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

- (void)createView:(NSDictionary *)dict{
    NSString *url=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[dict objectForKey:@"nsmallImage"]];
    NSURL *imageUrl=[NSURL URLWithString:url];
    [_smallImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _smallImage.backgroundColor=[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.0f];
    _gTitle.text=[dict objectForKey:@"ntitle"];
    _gDescription.text=[dict objectForKey:@"ndescription"];
    _gTitle.textColor=[UIColor blackColor];
    _gTitle.highlightedTextColor=[UIColor blackColor];
    _gDescription.textColor=[UIColor lightGrayColor];
    _gDescription.highlightedTextColor=[UIColor lightGrayColor];
}

@end
