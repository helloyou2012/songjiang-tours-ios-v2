//
//  GonglueDetailViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/20/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSmartHeaderWebView.h"

@interface GonglueDetailViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSDictionary *curData;
@property (nonatomic, strong) MMSmartHeaderWebView *headerWebView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) CGPoint startPoint;

- (void)createViews;
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer;
@end
