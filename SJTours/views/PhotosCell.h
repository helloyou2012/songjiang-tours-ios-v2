//
//  PhotosCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosCell : UITableViewCell

+ (NSInteger) numberOfPlaceHolders;
- (void) addViewModeView:(UIView *)viewModeView atIndex:(NSInteger)index;

@end
