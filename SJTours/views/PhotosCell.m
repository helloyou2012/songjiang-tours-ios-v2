//
//  PhotosCell.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "PhotosCell.h"

@implementation PhotosCell

+ (NSInteger) numberOfPlaceHolders
{
    return 3;
}

- (void) addViewModeView:(UIView *)viewModeView atIndex:(NSInteger)index
{
    if (index == 0)
    {
        for (UIView *view in [[self contentView] subviews])
        {
            [view removeFromSuperview];
        }
    }
    
    if (index < [PhotosCell numberOfPlaceHolders])
    {
        CGFloat x = index *96 + (index + 1) *8;
        CGFloat y = 4;
        CGFloat width = 96;
        CGFloat height = 72;
        [viewModeView setFrame:CGRectMake(x, y, width, height)];
        [self.contentView addSubview:viewModeView];
    }
}

@end
