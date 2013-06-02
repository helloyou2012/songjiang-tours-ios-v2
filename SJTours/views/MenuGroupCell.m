//
//  MenuGroupCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "MenuGroupCell.h"

@implementation MenuGroupCell

+ (NSInteger) numberOfPlaceHolders
{
    return 3;
}

- (void) addGroupView:(UIView *)groupView atIndex:(NSInteger)index;
{
    if (index == 0)
    {
        for (UIView *view in [self subviews])
        {
            if (view.tag>=500) {
                [view removeFromSuperview];
            }
        }
    }
    
    if (index < [MenuGroupCell numberOfPlaceHolders])
    {
        CGFloat width = 106.0f;
        CGFloat height = 106.0f;
        CGFloat x = index * width+index;
        
        if (index>0) {
            UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(x-2, 0.0f, 2.0f, 106.0f)];
            backImage.image=[UIImage imageNamed:@"line_vertical"];
            [self addSubview:backImage];
        }
        
        [groupView setFrame:CGRectMake(x, 0.0f, width, height)];
        groupView.tag=500+index;
        
        [self addSubview:groupView];
    }
}

@end
