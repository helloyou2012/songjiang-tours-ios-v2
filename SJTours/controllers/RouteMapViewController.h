//
//  RouteMapViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/14/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "RouteDetailView.h"

@interface RouteMapViewController : UIViewController<UIScrollViewDelegate,BMKMapViewDelegate,RouteDetailViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BMKPlanResult *result;
@property (nonatomic, strong) NSMutableArray *resultViews;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) BMKPlanResult *resultMap;
@property (nonatomic, assign) NSInteger mapType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isExpand;
@end
