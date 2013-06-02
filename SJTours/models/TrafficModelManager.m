//
//  TrafficModelManager.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "TrafficModelManager.h"

static TrafficModelManager *a_instance=nil;

@implementation TrafficModelManager

@synthesize mainArray=_mainArray;

+ (TrafficModelManager*) sharedInstance{
    if (a_instance==nil) {
        a_instance=[[self alloc] init];
    }
    return a_instance;
}

- (id) init{
    self=[super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/jiaotong.plist", NSHomeDirectory()];
        _mainArray =[NSMutableArray arrayWithContentsOfFile:path];
        if (_mainArray==nil) {
            _mainArray =[[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveData{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/jiaotong.plist", NSHomeDirectory()];
    [_mainArray writeToFile:path atomically:YES];
}
@end
