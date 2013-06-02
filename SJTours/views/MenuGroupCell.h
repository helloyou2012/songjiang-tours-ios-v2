//
//  MenuGroupCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuGroupCell : UITableViewCell

+ (NSInteger) numberOfPlaceHolders;
- (void) addGroupView:(UIView *)groupView atIndex:(NSInteger)index;

@end
