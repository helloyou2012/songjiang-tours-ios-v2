//
//  BusLineViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/1/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface BusLineViewController : UIViewController<BMKMapViewDelegate, BMKSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKSearch *search;
@property (nonatomic, strong) BMKPointAnnotation *annotation;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *busName;
@property (nonatomic, strong) IBOutlet UIButton *backBtn;

-(void)busLineSearch;
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;
- (IBAction)backToDetail:(id)sender;

@end