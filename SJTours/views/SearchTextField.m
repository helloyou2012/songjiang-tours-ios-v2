//
//  SearchTextField.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/22/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "SearchTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    self.borderStyle = UITextBorderStyleNone;
    self.clipsToBounds = YES;
	
	self.backgroundColor = [UIColor whiteColor];
	UIColor *glowingColor = [UIColor colorWithRed:(82.f / 255.f) green:(168.f / 255.f) blue:(236.f / 255.f) alpha:0.8];
	UIColor *borderColor = [UIColor lightGrayColor];
	
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 4.f;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = borderColor.CGColor;
	
    self.layer.shadowColor = glowingColor.CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f].CGPath;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 5.f;
    
    UIImageView *leftImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    leftImage.image=[UIImage imageNamed:@"icon_search"];
    self.leftView=leftImage;
    self.leftViewMode=UITextFieldViewModeAlways;
    self.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    self.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.returnKeyType=UIReturnKeySearch;
    self.font=[UIFont systemFontOfSize:14.0f];
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
