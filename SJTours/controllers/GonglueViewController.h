//
//  GonglueViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "GonglueRequest.h"

@interface GonglueViewController : UITableViewController<EGORefreshTableHeaderDelegate,GonglueRequestDelegage>

@property (nonatomic, strong) GonglueRequest *gonglueRequest;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isEnding;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSDictionary *dictType;

- (void)setupEGORefresh;
- (void)loadMoreData;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
