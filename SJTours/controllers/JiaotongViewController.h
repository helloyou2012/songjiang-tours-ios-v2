//
//  JiaotongViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/27/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "JiaotongRequest.h"

@interface JiaotongViewController : UITableViewController<EGORefreshTableHeaderDelegate,JiaotongRequestDelegage>

@property (nonatomic, strong) JiaotongRequest *jiaotongRequest;
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