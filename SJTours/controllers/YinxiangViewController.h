//
//  YinxiangViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/15/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "YinXiangModelManager.h"
#import "YinXiangRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface YinxiangViewController : UITableViewController<MWPhotoBrowserDelegate,YinXiangRequestDelegage,EGORefreshTableHeaderDelegate>

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) YinXiangRequest *request;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) BOOL reloading;

- (void)setupEGORefresh;

@end
