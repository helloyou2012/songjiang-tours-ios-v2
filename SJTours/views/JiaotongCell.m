//
//  JiaotongCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "JiaotongCell.h"

@implementation JiaotongCell

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
    self.textLabel.text=[dict objectForKey:@"tfline"];
    NSString *detail=[NSString stringWithFormat:@"%@-%@",[dict objectForKey:@"tffirstexpress"],[dict objectForKey:@"tflastexpress"]];
    self.detailTextLabel.text=detail;
    self.textLabel.textColor=[UIColor blackColor];
    self.textLabel.highlightedTextColor=[UIColor blackColor];
    self.detailTextLabel.textColor=[UIColor lightGrayColor];
    self.detailTextLabel.highlightedTextColor=[UIColor lightGrayColor];
}

@end
