//
//  JiaotongDetailViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/27/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiaotongHeaderView.h"

@interface JiaotongDetailViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *curData;
@property (nonatomic, strong) NSMutableArray *routeLines;
@property (nonatomic, strong) IBOutlet JiaotongHeaderView *headerView;

- (IBAction)gotoBusMapClicked:(id)sender;

@end
