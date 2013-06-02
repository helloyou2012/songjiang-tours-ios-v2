//
//  JingdianMapViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/24/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "MenuGroupView.h"

@class ViewportAnnotation;

@interface JingdianMapViewController : UIViewController<BMKMapViewDelegate,MenuGroupViewDelegate,BMKSearchDelegate>

@property (nonatomic, strong) NSDictionary *curData;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) ViewportAnnotation *annotation;
@property (nonatomic, strong) UIView *searchPoiView;
@property (nonatomic, strong) UIButton *searchPoiBtn;
@property (nonatomic, strong) BMKSearch* search;
@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) NSMutableDictionary *routeSearchData;

@end
