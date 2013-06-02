//
//  CompassViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/29/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "CompassViewController.h"
#import <CoreLocation/CLHeading.h>
#import "math.h"

#define toRad(X) (X*M_PI/180.0)
#define toDeg(X) (X*180.0/M_PI)

@implementation CompassViewController

@synthesize compassView=_compassView;
@synthesize locationManager=_locationManager;

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
    currentHeading = 0.0;
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 10, 54, 44)];
    [backBtn setImage:[UIImage imageNamed:@"top_navigation_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)backToMain{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateHeadingDisplays {
    // Animate Compass
    [UIView     animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGAffineTransform headingRotation;
                             headingRotation = CGAffineTransformRotate(CGAffineTransformIdentity, (CGFloat)-toRad(currentHeading));
                             _compassView.transform = headingRotation;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    
}


// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation.coordinate;
    [self updateHeadingDisplays];
}

- (void)startLocationHeadingEvents {
    if (!self.locationManager) {
        CLLocationManager* theManager = [[CLLocationManager alloc] init];
        // Retain the object in a property.
        self.locationManager = theManager;
        _locationManager.delegate = self;
    }
    
    // Start location services to get the true heading.
    _locationManager.distanceFilter = 1;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [_locationManager startUpdatingLocation];
    
    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        _locationManager.headingFilter = 5;
        [_locationManager startUpdatingHeading];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0)
        return;
    
    // Use the true heading if it is valid.
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    
    currentHeading = theHeading;
    [self updateHeadingDisplays];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startLocationHeadingEvents];
    
    [self updateHeadingDisplays];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.locationManager) {
        [_locationManager stopUpdatingHeading];
        [_locationManager stopUpdatingLocation];
    }
    [super viewWillDisappear:animated];
}

@end
