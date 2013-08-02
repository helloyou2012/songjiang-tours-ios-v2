//
//  AppsViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 7/4/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "AppRequest.h"

@interface AppsViewController : UITableViewController<EGORefreshTableHeaderDelegate,AppRequestDelegage>

@property (nonatomic, strong) AppRequest *appRequest;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isEnding;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setupEGORefresh;
- (void)loadMoreData;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
