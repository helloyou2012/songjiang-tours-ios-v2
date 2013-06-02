//
//  RouteSearchView.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/11/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@protocol RouteSearchViewDelegate <NSObject>

- (void)searchPlaceChanged;

@end

@interface RouteSearchView : UIView

@property (nonatomic, strong) UITextField *fromTextField;
@property (nonatomic, strong) UITextField *toTextField;
@property (nonatomic, strong) UIButton *swapBtn;
@property (nonatomic, retain) id<RouteSearchViewDelegate> delegate;
@property (nonatomic, strong) NSString *baseAddress;
@property (nonatomic, assign) double baseLat;
@property (nonatomic, assign) double baseLng;

- (void)createViews;
- (void)swapTextField;
- (BMKPlanNode*)getStartedNode;
- (BMKPlanNode*)getEndedNode;
@end
