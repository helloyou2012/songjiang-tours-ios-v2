//
//  RouteMapViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/14/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "RouteMapViewController.h"
#import "RouteAnnotation.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGSize rotatedSize = self.size;
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end


@implementation RouteMapViewController

@synthesize mapView=_mapView;
@synthesize result=_result;
@synthesize resultViews=_resultViews;
@synthesize scrollView=_scrollView;
@synthesize currentPage=_currentPage;
@synthesize isExpand=_isExpand;
@synthesize resultArray=_resultArray;
@synthesize mapType=_mapType;
@synthesize resultMap=_resultMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelClicked:)];
    cancelItem.tintColor=[UIColor lightGrayColor];
    self.navigationItem.leftBarButtonItem=cancelItem;
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    _resultViews=[[NSMutableArray alloc] init];
    for (unsigned i = 0; i < _resultArray.count; i++)
    {
		[_resultViews addObject:[NSNull null]];
    }
    //scroll view
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-104.0f, 320, self.view.bounds.size.height-44.0f)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(320 * _resultViews.count, self.view.bounds.size.height-44.0f);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.backgroundColor=[UIColor colorWithRed:0.949f green:0.949f blue:0.949f alpha:1.0f];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    
    [self loadScrollViewWithPage:_currentPage-1];
    [self loadScrollViewWithPage:_currentPage];
    [self loadScrollViewWithPage:_currentPage+1];
    
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _currentPage;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    switch (_mapType) {
        case 1:
            [self showTransitRouteResult:_resultMap];
            break;
        case 2:
            [self showDrivingRouteResult:_resultMap];
            break;
        default:
            [self showWalkingRouteResult:_resultMap];
            break;
    }
    _isExpand=NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
}

- (IBAction)cancelClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headerChanged{
    CGRect rect=CGRectMake(0, 0, 320, self.view.bounds.size.height);
    if (_isExpand) {
        rect=CGRectMake(0, self.view.bounds.size.height-60.0f, 320, self.view.bounds.size.height);
    }
    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.frame=rect;
    }];
    _isExpand=!_isExpand;
}

- (void)cellSelectedAt:(NSInteger)index{
    RouteAnnotation *annotation=[_mapView.annotations objectAtIndex:index];
    [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
    [_mapView selectAnnotation:annotation animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImagePageController method

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= _resultViews.count)
        return;
    
    // replace the placeholder if necessary
    RouteDetailView *routeDetailView = [_resultViews objectAtIndex:page];
    if ((NSNull *)routeDetailView == [NSNull null])
    {
        CGRect rect = _scrollView.frame;
        rect.origin.x = rect.size.width * page;
        rect.origin.y = 0;
        routeDetailView=[[RouteDetailView alloc] initWithFrame:rect];
        routeDetailView.delegate=self;
        NSDictionary *dict=[_resultArray objectAtIndex:page];
        routeDetailView.titleLabel.text=[dict objectForKey:@"title"];
        routeDetailView.tipLabel.text=[dict objectForKey:@"tip"];
        switch (_mapType) {
            case 1:
            {
                BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[_resultMap.plans objectAtIndex:page];
                [routeDetailView showTransitRouteResult:plan];
                break;
            }
            case 2:
            {
                BMKRoutePlan* plan = (BMKRoutePlan*)[_resultMap.plans objectAtIndex:page];
                [routeDetailView showDrivingRouteResult:plan];
                break;
            }
            default:
            {
                BMKRoutePlan* plan = (BMKRoutePlan*)[_resultMap.plans objectAtIndex:page];
                [routeDetailView showWalkingRouteResult:plan];
                break;
            }
        }
        [_resultViews replaceObjectAtIndex:page withObject:routeDetailView];
    }
    
    // add the controller's view to the scroll view
    if (routeDetailView.superview==nil) {
        [_scrollView addSubview:routeDetailView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page>=0&&page<_resultViews.count) {
        _currentPage=page;
        [self loadScrollViewWithPage:page - 1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page + 1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// update the scroll view to the appropriate page
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * _currentPage;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
    switch (_mapType) {
        case 1:
            [self showTransitRouteResult:_resultMap];
            break;
        case 2:
            [self showDrivingRouteResult:_resultMap];
            break;
        default:
            [self showWalkingRouteResult:_resultMap];
            break;
    }
}

- (void)showTransitRouteResult:(BMKPlanResult*)result
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    
	BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:_currentPage];
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = plan.startPt;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item];
    [item release];
    
    int size = [plan.lines count];
    int index = 0;
    for (int i = 0; i < size; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        for (int j = 0; j < route.pointsCount; j++) {
            int len = [route getPointsNum:j];
            index += len;
        }
        BMKLine* line = [plan.lines objectAtIndex:i];
        index += line.pointsCount;
        if (i == size - 1) {
            i++;
            route = [plan.routes objectAtIndex:i];
            for (int j = 0; j < route.pointsCount; j++) {
                int len = [route getPointsNum:j];
                index += len;
            }
            break;
        }
    }
    
    BMKMapPoint* points = new BMKMapPoint[index];
    index = 0;
    
    for (int i = 0; i < size; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        for (int j = 0; j < route.pointsCount; j++) {
            int len = [route getPointsNum:j];
            BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
            memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
            index += len;
        }
        BMKLine* line = [plan.lines objectAtIndex:i];
        memcpy(points + index, line.points, line.pointsCount * sizeof(BMKMapPoint));
        index += line.pointsCount;
        
        item = [[RouteAnnotation alloc]init];
        item.coordinate = line.getOnStopPoiInfo.pt;
        item.title = line.tip;
        if (line.type == 0) {
            item.type = 2;
        } else {
            item.type = 3;
        }
        
        [_mapView addAnnotation:item];
        [item release];
        route = [plan.routes objectAtIndex:i+1];
        item = [[RouteAnnotation alloc]init];
        item.coordinate = line.getOffStopPoiInfo.pt;
        item.title = route.tip;
        if (line.type == 0) {
            item.type = 2;
        } else {
            item.type = 3;
        }
        [_mapView addAnnotation:item];
        [item release];
        if (i == size - 1) {
            i++;
            route = [plan.routes objectAtIndex:i];
            for (int j = 0; j < route.pointsCount; j++) {
                int len = [route getPointsNum:j];
                BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
                memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
                index += len;
            }
            break;
        }
    }
    
    item = [[RouteAnnotation alloc]init];
    item.coordinate = plan.endPt;
    item.type = 1;
    item.title = @"终点";
    [_mapView addAnnotation:item];
    [item release];
    
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
    [_mapView addOverlay:polyLine];
    delete []points;
}


- (void)showDrivingRouteResult:(BMKPlanResult*)result
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    
    BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:_currentPage];
    
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = result.startNode.pt;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item];
    [item release];
    
    int index = 0;
    int size = [plan.routes count];
    for (int i = 0; i < 1; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        for (int j = 0; j < route.pointsCount; j++) {
            int len = [route getPointsNum:j];
            index += len;
        }
    }
    
    BMKMapPoint* points = new BMKMapPoint[index];
    index = 0;
    
    for (int i = 0; i < 1; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        for (int j = 0; j < route.pointsCount; j++) {
            int len = [route getPointsNum:j];
            BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
            memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
            index += len;
        }
        size = route.steps.count;
        for (int j = 0; j < size; j++) {
            BMKStep* step = [route.steps objectAtIndex:j];
            item = [[RouteAnnotation alloc]init];
            item.coordinate = step.pt;
            item.title = step.content;
            item.degree = step.degree * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
        }
        
    }
    
    item = [[RouteAnnotation alloc]init];
    item.coordinate = result.endNode.pt;
    item.type = 1;
    item.title = @"终点";
    [_mapView addAnnotation:item];
    [item release];
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
    [_mapView addOverlay:polyLine];
    delete []points;
	
}

- (void)showWalkingRouteResult:(BMKPlanResult*)result
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    
	BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:_currentPage];
    
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = result.startNode.pt;
    item.title = @"起点";
    item.type = 0;
    [_mapView addAnnotation:item];
    [item release];
    
    int index = 0;
    int size = [plan.routes count];
    for (int i = 0; i < 1; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        for (int j = 0; j < route.pointsCount; j++) {
            int len = [route getPointsNum:j];
            index += len;
        }
    }
    
    BMKMapPoint* points = new BMKMapPoint[index];
    index = 0;
    
    for (int i = 0; i < 1; i++) {
        BMKRoute* route = [plan.routes objectAtIndex:i];
        for (int j = 0; j < route.pointsCount; j++) {
            int len = [route getPointsNum:j];
            BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
            memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
            index += len;
        }
        size = route.steps.count;
        for (int j = 0; j < size; j++) {
            BMKStep* step = [route.steps objectAtIndex:j];
            item = [[RouteAnnotation alloc]init];
            item.coordinate = step.pt;
            item.title = step.content;
            item.degree = step.degree * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            [item release];
        }
        
    }
    
    item = [[RouteAnnotation alloc]init];
    item.coordinate = result.endNode.pt;
    item.type = 1;
    item.title = @"终点";
    [_mapView addAnnotation:item];
    [item release];
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
    [_mapView addOverlay:polyLine];
    delete []points;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark BMKAnnotationView delegate

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
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
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
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
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
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
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
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
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
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

@end
