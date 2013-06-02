//
//  RouteSearchCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/14/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteSearchCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *tipLabel;
@property (nonatomic, assign) BOOL isInitView;
- (void)createViews:(NSDictionary*)dict;
@end
