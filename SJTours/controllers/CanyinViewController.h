//
//  CanyinViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 7/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "JingdianRequest.h"
#import "SDSegmentedControl.h"

@class ViewSpotsModelManager;

@interface CanyinViewController : UITableViewController<EGORefreshTableHeaderDelegate,JingdianRequestDelegage>

@property (nonatomic, strong) JingdianRequest *jingdianRequest;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isEnding;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSDictionary *dictType;
@property (nonatomic, strong) ViewSpotsModelManager *modelManager;

@property (nonatomic, strong) IBOutlet SDSegmentedControl *segmentedControl;

- (void)setupEGORefresh;
- (void)loadMoreData;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (IBAction)segmentDidChange:(id)sender;

@end
