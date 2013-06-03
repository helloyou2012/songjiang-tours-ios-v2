//
//  BusLineViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/1/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "BusLineViewController.h"
#import "SVProgressHUD.h"
#import "RouteAnnotation.h"


#define MYBUNDLE_NAME @ "mapapi.bundle"

#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]

#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


@implementation BusLineViewController

@synthesize mapView=_mapView;
@synthesize search=_search;
@synthesize annotation=_annotation;
@synthesize cityName=_cityName;
@synthesize busName=_busName;
@synthesize backBtn=_backBtn;

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"] autorelease];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"] autorelease];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
            view.image=image;
			view.annotation = routeAnnotation;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}


- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
	if (error == BMKErrorOk) {
		BMKPoiResult* result = [poiResultList objectAtIndex:0];
        BMKPoiInfo* poi=nil;
		for (int i = 0; i < result.poiInfoList.count; i++) {
			poi = [result.poiInfoList objectAtIndex:i];
            if (poi.epoitype == 2) {
                break;
            }
            
		}
        //开始bueline详情搜索
        if(poi != nil && poi.epoitype == 2 )
        {
            BOOL flag = [_search busLineSearch:_cityName withKey:poi.uid];
            if (!flag) {
                [SVProgressHUD showErrorWithStatus:@"公交查询失败！"];
            }
        }
	}
}
-(void)onGetBusDetailResult:(BMKBusLineResult *)busLineResult errorCode:(int)error
{
    if (error == BMKErrorOk) {        
        //起点
        RouteAnnotation* item = [[RouteAnnotation alloc]init];
        
        item.coordinate = busLineResult.mBusRoute.startPt;
        BMKStep* tempstep = [busLineResult.mBusRoute.steps objectAtIndex:0];
        
        item.title = tempstep.content;
        
        item.type = 0;
        [_mapView addAnnotation:item];
        [item release];
        
        //终点
        item = [[RouteAnnotation alloc]init];
        item.coordinate = busLineResult.mBusRoute.endPt;
        item.type = 1;
        tempstep = [busLineResult.mBusRoute.steps objectAtIndex:busLineResult.mBusRoute.steps.count-1];
        item.title = tempstep.content;
        [_mapView addAnnotation:item];
        [item release];
        
        //站点信息
        int size = 0;
        size = busLineResult.mBusRoute.steps.count;
        for (int j = 0; j < size; j++) {
            BMKStep* step = [busLineResult.mBusRoute.steps objectAtIndex:j];
            item = [[RouteAnnotation alloc]init];
            item.coordinate = step.pt;
            item.title = step.content;
            item.degree = step.degree * 30;
            item.type = 2;
            [_mapView addAnnotation:item];
            [item release];
        }
        
        
        //路段信息
        int index = 0;
		for (int i = 0; i < 1; i++) {
			for (int j = 0; j < busLineResult.mBusRoute.pointsCount; j++) {
				int len = [busLineResult.mBusRoute getPointsNum:j];
				index += len;
			}
		}
        
		index = 0;
		for (int i = 0; i < 1; i++) {
			for (int j = 0; j < busLineResult.mBusRoute.pointsCount; j++) {
				int len = [busLineResult.mBusRoute getPointsNum:j];
				index += len;
			}
        }
        
        
        //直角坐标划线
        BMKMapPoint * temppoints = new BMKMapPoint[index];
        index = 0;
		for (int i = 0; i < 1; i++) {
			for (int j = 0; j < busLineResult.mBusRoute.pointsCount; j++) {
				int len = [busLineResult.mBusRoute getPointsNum:j];
                for(int k=0;k<len;k++)
                {
                    BMKMapPoint pointarray;
                    pointarray.x = [busLineResult.mBusRoute getPoints:j][k].x;
                    pointarray.y = [busLineResult.mBusRoute getPoints:j][k].y;
                    temppoints[k] = pointarray;
                }
				index += len;
			}
        }
        
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:index];
		[_mapView addOverlay:polyLine];
		delete []temppoints;
        
        _annotation.coordinate = BMKCoordinateForMapPoint([busLineResult.mBusRoute getPoints:0][0]);
        
        [_mapView setCenterCoordinate:_annotation.coordinate animated:YES];
        
    }
}
-(void)busLineSearch
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	BOOL flag = [_search poiSearchInCity:_cityName withKey:_busName pageIndex:0];
	if (!flag) {
		[SVProgressHUD showErrorWithStatus:@"公交查询失败！"];
	}
    
}
- (void)mapView:(BMKMapView *)mmapView regionDidChangeAnimated:(BOOL)animated
{
	if (animated) {
        [mmapView selectAnnotation:_annotation animated:YES];
	}
	
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    [_mapView setShowsUserLocation:YES];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    [self.view bringSubviewToFront:_backBtn];
    
	_search = [[BMKSearch alloc]init];
    
    _annotation = [[BMKPointAnnotation alloc]init];
	CLLocationCoordinate2D coor;
	coor.latitude = 39.915;
	coor.longitude = 115.404;
	_annotation.coordinate = coor;
	
	_annotation.title = @"上海市松江";
	_annotation.subtitle = NULL;
	[_mapView addAnnotation:_annotation];
    
    _cityName=@"上海";
    //_busName=@"松江3路";
    [self busLineSearch];
}

- (IBAction)backToDetail:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _search.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_search release];
    [_mapView release];
    [super dealloc];
}

@end
