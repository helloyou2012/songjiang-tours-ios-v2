//
//  DituViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/17/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "DituViewController.h"
#import "SVProgressHUD.h"
#import "RequestUrls.h"
#import "SVProgressHUD.h"
#import "ViewSpotsModelManager.h"
#import "PublicPlaceModelManager.h"
#import "ViewportAnnotation.h"
#import "PublicPlaceAnnotation.h"
#import "AppDelegate.h"
#import "Viewport.h"

@implementation DituViewController

@synthesize mapView=_mapView;
@synthesize isSetMapSpan=_isSetMapSpan;
@synthesize searchTextField=_searchTextField;
@synthesize backBtn=_backBtn;
@synthesize backView=_backView;
@synthesize annotationArray=_annotationArray;
@synthesize jingdianRequest=_jingdianRequest;
@synthesize curSearchDict=_curSearchDict;
@synthesize curViewDict=_curViewDict;
@synthesize manager=_manager;
@synthesize compassBtn=_compassBtn;
@synthesize search=_search;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _annotationArray=[[NSMutableArray alloc] init];
    
    [self.view bringSubviewToFront:_backView];
    [self registerForKeyboardNotifications];
    
    self.navigationItem.leftBarButtonItem=[self createLeftBarButtonItem];
    self.navigationItem.rightBarButtonItem=[self createRightBarButtonItem];
    
    _compassBtn=[[UIButton alloc] initWithFrame:CGRectMake(320-51, 10, 41, 41)];
    [_compassBtn setImage:[UIImage imageNamed:@"button_my_location_compass_mode"] forState:UIControlStateNormal];
    [_compassBtn showsTouchWhenHighlighted];
    [_compassBtn addTarget:self action:@selector(compassBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_compassBtn];
    
    [self createSearchMainView];
    
    _manager=[[ViewSpotsModelManager alloc] initWith:@"search-viewports"];
    _jingdianRequest=[[JingdianRequest alloc] init];
    _jingdianRequest.delegate=self;
    
    CLLocationCoordinate2D curLacation=CLLocationCoordinate2DMake(31, 121.24);
    _mapView.centerCoordinate=curLacation;
    
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    [data setObject:[NSString stringWithFormat:@"%d",1] forKey:@"page"];
    [data setObject:[NSString stringWithFormat:@"%d",20] forKey:@"rows"];
    _jingdianRequest.requestUrl=[RequestUrls viewportList];
    _jingdianRequest.requestData=data;
    [_jingdianRequest createConnection];
    
    _search = [[BMKSearch alloc] init];
    _search.delegate=self;
}

- (void)compassBtnClicked{
    [self performSegueWithIdentifier:@"gotoCompass" sender:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_jingdianRequest.connection cancel];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
}

- (UIBarButtonItem*)createLeftBarButtonItem{
    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, 260, 34)];
    _backBtn=[[UIButton alloc] initWithFrame:CGRectMake(-28, 5, 24, 24)];
    [_backBtn setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backToMap:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn showsTouchWhenHighlighted];
    [barView addSubview:_backBtn];
    
    _searchTextField=[[SearchTextField alloc] initWithFrame:CGRectMake(0, 2, 260, 30)];
    _searchTextField.placeholder=@"搜索松江吃喝玩乐";
    _searchTextField.enablesReturnKeyAutomatically=YES;
    _searchTextField.delegate=self;
    [barView addSubview:_searchTextField];
    
    barView.clipsToBounds=YES;
    
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc] initWithCustomView:barView];
    return buttonItem;
}

- (UIBarButtonItem*)createRightBarButtonItem{
    UIView *barView=[[UIView alloc] initWithFrame:CGRectMake(5, 5, 34, 34)];
    UIButton *rightFavorBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 5, 24, 24)];
    [rightFavorBtn setImage:[UIImage imageNamed:@"toolmap_favor"] forState:UIControlStateNormal];
    [rightFavorBtn addTarget:self action:@selector(favorClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightFavorBtn showsTouchWhenHighlighted];
    [barView addSubview:rightFavorBtn];
    barView.clipsToBounds=YES;
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc] initWithCustomView:barView];
    return buttonItem;
}

- (void)createSearchMainView{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchItems" ofType:@"plist"];
    NSMutableArray *menuItems=[NSMutableArray arrayWithContentsOfFile:path];
    
    for (NSInteger i = 0; i < menuItems.count; ++i)
    {
        NSDictionary *numberItem = [menuItems objectAtIndex:i];
        MenuGroupView *groupView=[[MenuGroupView alloc] initWithObject:numberItem isSearch:YES];
        CGFloat width = 64.0f;
        CGFloat height = 67.0f;
        CGFloat x = (i%5)* width;
        CGFloat y = (i/5)* height;
        [groupView setFrame:CGRectMake(x, y, width, height)];
        groupView.delegate=self;
        [_backView addSubview:groupView];
    }
    
    CGRect rect=self.view.bounds;
    rect.origin.y=rect.size.height-100;
    _backView.frame=rect;
    _backView.alpha=0.0f;
}

- (void)favorClicked{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSError *error=nil;
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Viewport" inManagedObjectContext:context]];
    NSArray *objects=[context executeFetchRequest:fetchRequest error:&error];
    if (objects&&objects.count>0) {
        NSMutableArray *viewports=[[NSMutableArray alloc] initWithCapacity:objects.count];
        for (NSManagedObject *obj in objects) {
            [viewports addObject:[(Viewport*)obj getData]];
        }
        [self createViewSpots:viewports];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前没有收藏！"];
    }
    
    
}

- (void)groupClicked:(NSDictionary*)dict{
    _searchTextField.text=[dict objectForKey:@"name"];
    [_searchTextField resignFirstResponder];
    NSString *id_dict=[dict objectForKey:@"pushIdentifier"];
    
    _curSearchDict=dict;
    NSMutableDictionary *data=[[NSMutableDictionary alloc] init];
    [data setObject:[NSString stringWithFormat:@"%d",1] forKey:@"page"];
    [data setObject:[NSString stringWithFormat:@"%d",20] forKey:@"rows"];
    [data setObject:[dict objectForKey:@"type"] forKey:@"type"];
    
    if ([id_dict isEqualToString:@"viewport"]) {
        _jingdianRequest.requestUrl=[RequestUrls viewportList];
        _jingdianRequest.requestData=data;
        [_jingdianRequest createConnection];
    }else{
        if (_mapView.userLocation!=nil) {
            [_search poiSearchNearBy:[dict objectForKey:@"name"] center:_mapView.userLocation.coordinate radius:1000 pageIndex:0];
        }else{
            [SVProgressHUD showErrorWithStatus:@"未获取到当前位置！"];
        }
        
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    [_mapView setShowsUserLocation:YES];
    _mapView.delegate=self;
    self.navigationItem.title=@"";
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        _backBtn.frame=CGRectMake(0, 5, 24, 24);
        _searchTextField.frame=CGRectMake(30, 2, 230, 30);
        _backView.frame=self.view.bounds;
        _backView.alpha=1.0f;
        _compassBtn.alpha=0.0f;
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3 animations:^{
        _backBtn.frame=CGRectMake(-30, 5, 24, 24);
        _searchTextField.frame=CGRectMake(0, 2, 260, 30);
        CGRect rect=self.view.bounds;
        rect.origin.y=rect.size.height-100;
        _backView.frame=rect;
        _backView.alpha=0.0f;
        _compassBtn.alpha=1.0f;
    }];
}

- (IBAction)backToMap:(id)sender{
    [_searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (_mapView.userLocation!=nil) {
        [_search poiSearchNearBy:textField.text center:_mapView.userLocation.coordinate radius:1000 pageIndex:0];
    }else{
        [SVProgressHUD showErrorWithStatus:@"未获取到当前位置！"];
    }
    return NO;
}

//传入经纬度,将baiduMapView 锁定到以当前经纬度为中心点的显示区域和合适的显示范围
- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKCoordinateRegion region;
    if (!_isSetMapSpan)//这里用一个变量判断一下,只在第一次锁定显示区域时 设置一下显示范围 Map Region
    {
        region = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.05, 0.05));//越小地图显示越详细
        _isSetMapSpan = YES;
        [_mapView setRegion:region animated:YES];//执行设定显示范围
    }
    [_mapView setCenterCoordinate:coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createViewSpots:(NSArray*)dataArray{
    [_mapView removeAnnotations:_annotationArray];
    [_annotationArray removeAllObjects];
    
    CLLocationCoordinate2D curLacation=CLLocationCoordinate2DMake(31, 121.24);
    BMKCoordinateSpan theSpan=BMKCoordinateSpanMake(0.1, 0.1);
    BMKCoordinateRegion viewRegion=BMKCoordinateRegionMake(curLacation, theSpan);
    [_mapView setRegion:viewRegion];
    
    for (NSDictionary *dict in dataArray) {
        ViewportAnnotation *annotation=[[ViewportAnnotation alloc] initWith:dict];
        [_annotationArray addObject:annotation];
        [_mapView addAnnotation:annotation];
    }
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[ViewportAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = NO;
        NSString *imageUrl=@"mark";
        if (((ViewportAnnotation*)annotation).dictData) {
            NSDictionary *type=[((ViewportAnnotation*)annotation).dictData objectForKey:@"vtype"];
            imageUrl=[NSString stringWithFormat:@"mark-%@",[type objectForKey:@"id"]];
            
            UIButton *rightView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            [rightView setImage:[UIImage imageNamed:@"poi_detail_search_nearby"] forState:UIControlStateNormal];
            rightView.showsTouchWhenHighlighted=YES;
            rightView.tag=[_annotationArray indexOfObject:annotation];
            [rightView addTarget:self action:@selector(viewDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
            newAnnotation.rightCalloutAccessoryView=rightView;
            
            UIButton *leftView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            [leftView setImage:[UIImage imageNamed:@"poi_detail_route"] forState:UIControlStateNormal];
            leftView.showsTouchWhenHighlighted=YES;
            leftView.tag=[_annotationArray indexOfObject:annotation];
            [leftView addTarget:self action:@selector(viewRouteClicked:) forControlEvents:UIControlEventTouchUpInside];
            newAnnotation.leftCalloutAccessoryView=leftView;
        }
        newAnnotation.image=[UIImage imageNamed:imageUrl];
		return newAnnotation;
	}
    if ([annotation isKindOfClass:[PublicPlaceAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = NO;
        
        UIButton *leftView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftView setImage:[UIImage imageNamed:@"poi_detail_route"] forState:UIControlStateNormal];
        leftView.showsTouchWhenHighlighted=YES;
        leftView.tag=[_annotationArray indexOfObject:annotation];
        [leftView addTarget:self action:@selector(viewPublicRouteClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imageUrl=[NSString stringWithFormat:@"icon_mark%d", leftView.tag+1];
        newAnnotation.image=[UIImage imageNamed:imageUrl];
        newAnnotation.leftCalloutAccessoryView=leftView;
		return newAnnotation;
	}
	return nil;
}

-(void) jingdianRequestFinished:(NSArray*)data withError:(NSString*)error
{
    //[SVProgressHUD dismiss];
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        if (data&&data.count>0) {
            [_manager.mainArray removeAllObjects];
            [_manager.mainArray addObjectsFromArray:data];
            [_manager saveData];
            
            [ self createViewSpots:_manager.mainArray];
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂时没有数据"];
        }
    }
}

- (IBAction)viewDetailClicked:(id)sender{
    NSInteger tag=((UIButton*)sender).tag;
    ViewportAnnotation *annotation=[_annotationArray objectAtIndex:tag];
    if (annotation.dictData) {
        _curViewDict=[NSMutableDictionary dictionaryWithDictionary:annotation.dictData];
        [self performSegueWithIdentifier:@"gotoViewport" sender:self];
    }
}

- (IBAction)viewRouteClicked:(id)sender{
    NSInteger tag=((UIButton*)sender).tag;
    ViewportAnnotation *annotation=[_annotationArray objectAtIndex:tag];
    if (annotation.dictData) {
        _curViewDict=[NSMutableDictionary dictionaryWithDictionary:annotation.dictData];
        [self performSegueWithIdentifier:@"gotoSearchLine" sender:self];
    }
}

- (IBAction)viewPublicRouteClicked:(id)sender{
    NSInteger tag=[(UIButton*)sender tag];
    BMKPointAnnotation* item=[_annotationArray objectAtIndex:tag];
    
    _curViewDict=[[NSMutableDictionary alloc] init];
    [_curViewDict setObject:item.title forKey:@"vtitle"];
    [_curViewDict setObject:[NSNumber numberWithDouble:item.coordinate.longitude] forKey:@"lng"];
    [_curViewDict setObject:[NSNumber numberWithDouble:item.coordinate.latitude] forKey:@"lat"];
    
    [self performSegueWithIdentifier:@"gotoSearchLine" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gotoSearchLine"]){
        UINavigationController *nc=segue.destinationViewController;
        [nc.topViewController setValue:_curViewDict forKey:@"curData"];
    }else if([[segue identifier] isEqualToString:@"gotoViewport"]){
        self.navigationItem.title=@"地图";
        [segue.destinationViewController setValue:_curViewDict forKey:@"curData"];
    }
}

#pragma mark Map Delegate

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation) {
        NSNumber *lat=[NSNumber numberWithDouble:userLocation.coordinate.latitude];
        NSNumber *lng=[NSNumber numberWithDouble:userLocation.coordinate.longitude];
        
        NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                                  lat, @"lat",
                                  lng, @"lng", nil];
        [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"UserLocation"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark Search Delegate

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
	if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
        [_mapView removeAnnotations:_annotationArray];
        [_annotationArray removeAllObjects];
        if (result.poiInfoList.count>0) {
            for (int i = 0; i < result.poiInfoList.count && i<10; i++) {
                BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
                PublicPlaceAnnotation* item = [[PublicPlaceAnnotation alloc] init];
                item.coordinate = poi.pt;
                item.title = poi.name;
                [_annotationArray addObject:item];
                [_mapView addAnnotation:item];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"未搜索到！"];
        }
	}else{
        [SVProgressHUD showErrorWithStatus:@"未搜索到！"];
    }
}

@end
