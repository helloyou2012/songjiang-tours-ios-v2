//
//  MapModelManager.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "MapModelManager.h"

@implementation MapModelManager

static MapModelManager *a_instance=nil;

@synthesize mainArray=_mainArray;

+ (MapModelManager*) sharedInstance{
    if (a_instance==nil) {
        a_instance=[[self alloc] init];
    }
    return a_instance;
}

- (id) init{
    self=[super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/ditu.plist", NSHomeDirectory()];
        _mainArray =[NSMutableArray arrayWithContentsOfFile:path];
        if (_mainArray==nil) {
            _mainArray =[[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveData{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/ditu.plist", NSHomeDirectory()];
    [_mainArray writeToFile:path atomically:YES];
}
@end
