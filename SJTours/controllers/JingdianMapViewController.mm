//
//  JingdianMapViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/24/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "JingdianMapViewController.h"
#import "ViewportAnnotation.h"
#import "BMKPinAnnotationView.h"
#import "SVProgressHUD.h"

@implementation JingdianMapViewController

@synthesize curData=_curData;
@synthesize mapView=_mapView;
@synthesize annotation=_annotation;
@synthesize searchPoiView=_searchPoiView;
@synthesize searchPoiBtn=_searchPoiBtn;
@synthesize search=_search;
@synthesize annotationArray=_annotationArray;
@synthesize routeSearchData=_routeSearchData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[_curData objectForKey:@"vtitle"];
    
    _mapView.delegate=self;
    _annotation=[[ViewportAnnotation alloc] initWith:_curData];
    [_mapView addAnnotation:_annotation];
    [_mapView setCenterCoordinate:_annotation.coordinate];
    
    _searchPoiBtn=[[UIButton alloc] initWithFrame:CGRectMake(272, 10, 38, 38)];
    [_searchPoiBtn setImage:[UIImage imageNamed:@"icon_map_poi"] forState:UIControlStateNormal];
    [_searchPoiBtn showsTouchWhenHighlighted];
    [_searchPoiBtn addTarget:self action:@selector(searchPoiClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchPoiBtn];
    
    _search = [[BMKSearch alloc] init];
    _annotationArray=[[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_searchPoiView==nil) {
        [self createSearchMainView];
    }
    _search.delegate=self;
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    [_mapView setShowsUserLocation:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
}

- (void)createSearchMainView{
    CGRect rect=CGRectMake(0, self.view.bounds.size.height, 320, 140);
    _searchPoiView=[[UIView alloc] initWithFrame:rect];
    
    rect.size.height-=6.0f;
    rect.origin.y=6.0f;
    UIScrollView *backView=[[UIScrollView alloc] initWithFrame:rect];
    backView.backgroundColor=[UIColor colorWithRed:243.0f/255.0f green:246.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    backView.pagingEnabled = YES;
    backView.showsHorizontalScrollIndicator = NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PoiSearch" ofType:@"plist"];
    NSMutableArray *menuItems=[NSMutableArray arrayWithContentsOfFile:path];
    
    CGFloat rows=ceil(menuItems.count/5.0f);
    [backView setContentSize:CGSizeMake(320, rows*67.0f+6.0f)];
    //分割线
    UIImageView *lineView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 6)];
    lineView.backgroundColor=[UIColor clearColor];
    lineView.image=[UIImage imageNamed:@"top_shadow"];
    lineView.alpha=0.8f;
    [_searchPoiView addSubview:lineView];
    
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
        [backView addSubview:groupView];
    }
    [_searchPoiView addSubview:backView];
    _searchPoiView.alpha=0.0f;
    [self.view addSubview:_searchPoiView];
}

- (void)searchPoiClicked{
    CGRect rect=CGRectMake(0, self.view.bounds.size.height, 320, 140);
    CGFloat alpha_temp=0.0f;
    if (_searchPoiView.alpha<0.1) {
        alpha_temp=1.0f;
        rect.origin.y=self.view.bounds.size.height-140;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _searchPoiView.frame=rect;
        _searchPoiView.alpha=alpha_temp;
    }];
}

- (void)groupClicked:(NSDictionary*)dict{
    //_searchTextField.text=[dict objectForKey:@"name"];
    [_search poiSearchNearBy:[dict objectForKey:@"name"] center:_annotation.coordinate radius:1000 pageIndex:0];
    [self searchPoiClicked];
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
            
            UIButton *leftView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            [leftView setImage:[UIImage imageNamed:@"poi_detail_route"] forState:UIControlStateNormal];
            leftView.showsTouchWhenHighlighted=YES;
            [leftView addTarget:self action:@selector(viewRouteClicked:) forControlEvents:UIControlEventTouchUpInside];
            newAnnotation.leftCalloutAccessoryView=leftView;
        }
        newAnnotation.image=[UIImage imageNamed:imageUrl];
		return newAnnotation;
	}else if([_annotationArray containsObject:annotation]){
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.animatesDrop = YES;
		newAnnotation.draggable = NO;
        
        UIButton *leftView=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [leftView setImage:[UIImage imageNamed:@"poi_detail_route"] forState:UIControlStateNormal];
        leftView.showsTouchWhenHighlighted=YES;
        leftView.tag=[_annotationArray indexOfObject:annotation];
        [leftView addTarget:self action:@selector(viewPoiRouteClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imageUrl=[NSString stringWithFormat:@"icon_mark%d", leftView.tag+1];
        newAnnotation.image=[UIImage imageNamed:imageUrl];
        newAnnotation.leftCalloutAccessoryView=leftView;
        
		return newAnnotation;
    }
	return nil;
}

- (IBAction)viewRouteClicked:(id)sender{
    _routeSearchData=[NSMutableDictionary dictionaryWithDictionary:_curData];
    [self performSegueWithIdentifier:@"gotoRouteSearch" sender:self];
}

- (IBAction)viewPoiRouteClicked:(id)sender{
    NSInteger tag=[(UIButton*)sender tag];
    BMKPointAnnotation* item=[_annotationArray objectAtIndex:tag];
    
    _routeSearchData=[[NSMutableDictionary alloc] init];
    [_routeSearchData setObject:item.title forKey:@"vtitle"];
    [_routeSearchData setObject:[NSNumber numberWithDouble:item.coordinate.longitude] forKey:@"lng"];
    [_routeSearchData setObject:[NSNumber numberWithDouble:item.coordinate.latitude] forKey:@"lat"];
    
    [self performSegueWithIdentifier:@"gotoRouteSearch" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *nc=segue.destinationViewController;
    [nc.topViewController setValue:_routeSearchData forKey:@"curData"];
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
                BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
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
