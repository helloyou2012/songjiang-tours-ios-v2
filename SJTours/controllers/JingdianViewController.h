//
//  JingdianViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "JingdianRequest.h"

@class ViewSpotsModelManager;

@interface JingdianViewController : UITableViewController<EGORefreshTableHeaderDelegate,JingdianRequestDelegage>

@property (nonatomic, strong) JingdianRequest *jingdianRequest;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isEnding;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSDictionary *dictType;
@property (nonatomic, strong) ViewSpotsModelManager *modelManager;

- (void)setupEGORefresh;
- (void)loadMoreData;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
