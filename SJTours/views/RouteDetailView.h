//
//  RouteDetailView.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/14/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@protocol RouteDetailViewDelegate <NSObject>

- (void)headerChanged;
- (void)cellSelectedAt:(NSInteger)index;

@end

@interface RouteDetailView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableDatas;
@property (nonatomic, retain) id<RouteDetailViewDelegate> delegate;

- (IBAction)headerClicked:(id)sender;
- (void)showTransitRouteResult:(BMKTransitRoutePlan*)plan;
- (void)showDrivingRouteResult:(BMKRoutePlan*)plan;
- (void)showWalkingRouteResult:(BMKRoutePlan*)plan;

@end
