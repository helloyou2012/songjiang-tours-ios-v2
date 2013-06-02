//
//  CompassViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/29/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface CompassViewController : UIViewController<CLLocationManagerDelegate>{
    CLLocationCoordinate2D  currentLocation;
    CLLocationDirection     currentHeading;
}

@property (nonatomic, strong) IBOutlet UIScrollView *compassView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
