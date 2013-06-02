//
//  RouteSearchViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/11/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteSearchView.h"
#import "SearchWaysView.h"
#import "BMapKit.h"

@interface RouteSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BMKSearchDelegate,SearchWaysViewDelegate,RouteSearchViewDelegate>
@property (nonatomic, strong) NSDictionary *curData;
@property (nonatomic, strong) RouteSearchView *headerSearchView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet SearchWaysView *headerWaysView;
@property (nonatomic, strong) BMKSearch* search;

@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) BMKPlanResult *resultMap;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIButton *keyControlBtn;

- (IBAction)searchClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)keyControlClicked:(id)sender;
- (void)customizeNavBar;
- (NSString*)getTransitShortName:(NSString*)longName;
- (void)searchNow;
- (void)registerForKeyboardNotifications;
@end
