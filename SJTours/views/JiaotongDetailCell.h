//
//  JiaotongDetailCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/27/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiaotongDetailCell : UITableViewCell

@property (nonatomic, assign) NSInteger linetype;
- (void)createViews:(NSString*)name;

@end
