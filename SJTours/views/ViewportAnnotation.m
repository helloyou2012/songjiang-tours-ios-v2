//
//  ViewportAnnotation.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ViewportAnnotation.h"

@implementation ViewportAnnotation

@synthesize dictData=_dictData;

- (id)initWith:(NSDictionary*)dict{
    self=[super init];
    if (self) {
        CLLocationCoordinate2D coord=CLLocationCoordinate2DMake([[dict objectForKey:@"lat"] doubleValue], [[dict objectForKey:@"lng"] doubleValue]);
        self.coordinate=coord;
        self.title = [dict objectForKey:@"vtitle"];
        self.dictData=dict;
    }
    return self;
}
@end
