//
//  DaolanViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuGroupCell.h"
#import "MenuGroupView.h"

@interface DaolanViewController : UITableViewController<MenuGroupViewDelegate>

@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) NSDictionary *currentDict;

- (UIBarButtonItem*)createRightBarButtonItem;
- (void)favorClicked;

@end
