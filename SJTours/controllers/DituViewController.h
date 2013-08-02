//
//  DituViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/17/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "SearchTextField.h"
#import "MenuGroupView.h"
#import "JingdianRequest.h"

@class ViewSpotsModelManager;

@interface DituViewController : UIViewController<BMKMapViewDelegate,MenuGroupViewDelegate,UITextFieldDelegate,JingdianRequestDelegage,BMKSearchDelegate>

@property (nonatomic, strong) IBOutlet BMKMapView *mapView;
@property (nonatomic, assign) BOOL isSetMapSpan;
@property (nonatomic, strong) SearchTextField *searchTextField;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) NSMutableArray *annotationArray;

@property (nonatomic, strong) JingdianRequest *jingdianRequest;
@property (nonatomic, strong) NSDictionary *curSearchDict;
@property (nonatomic, strong) NSMutableDictionary *curViewDict;
@property (nonatomic, strong) ViewSpotsModelManager *manager;
@property (nonatomic, strong) UIButton *compassBtn;

@property (nonatomic, strong) BMKSearch* search;

- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)createViewSpots:(NSArray*)dataArray;

- (void)registerForKeyboardNotifications;
- (void)createSearchMainView;
- (UIBarButtonItem*)createLeftBarButtonItem;
- (UIBarButtonItem*)createRightBarButtonItem;
- (IBAction)viewDetailClicked:(id)sender;
- (IBAction)viewRouteClicked:(id)sender;
@end
