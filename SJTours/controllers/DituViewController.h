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
#import "PublicPlaceRequest.h"

@class ViewSpotsModelManager;
@class PublicPlaceModelManager;

@interface DituViewController : UIViewController<BMKMapViewDelegate,MenuGroupViewDelegate,UITextFieldDelegate,JingdianRequestDelegage,PublicPlaceRequestDelegage>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, assign) BOOL isSetMapSpan;
@property (nonatomic, strong) SearchTextField *searchTextField;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) IBOutlet UIView *backView;
@property (nonatomic, strong) NSMutableArray *annotationArray;

@property (nonatomic, strong) JingdianRequest *jingdianRequest;
@property (nonatomic, strong) PublicPlaceRequest *publicRequest;
@property (nonatomic, strong) NSDictionary *curSearchDict;
@property (nonatomic, strong) NSDictionary *curViewDict;
@property (nonatomic, strong) ViewSpotsModelManager *manager;
@property (nonatomic, strong) PublicPlaceModelManager *public_manager;
@property (nonatomic, strong) UIButton *compassBtn;

- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)createViewSpots:(NSArray*)dataArray;
- (void)createPublicPlace:(NSArray*)dataArray;

- (void)registerForKeyboardNotifications;
- (void)createSearchMainView;
- (UIBarButtonItem*)createLeftBarButtonItem;
- (UIBarButtonItem*)createRightBarButtonItem;
- (IBAction)viewDetailClicked:(id)sender;
- (IBAction)viewRouteClicked:(id)sender;
@end
