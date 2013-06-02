//
//  PublicPlaceAnnotation.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "PublicPlaceAnnotation.h"

@implementation PublicPlaceAnnotation

@synthesize dictData=_dictData;

- (id)initWith:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        CLLocationCoordinate2D coord=CLLocationCoordinate2DMake([[dict objectForKey:@"lat"] doubleValue], [[dict objectForKey:@"lng"] doubleValue]);
        self.coordinate=coord;
        self.title = [dict objectForKey:@"ptitle"];
        self.dictData=dict;
    }
    return self;
}

@end
