//
//  YinXiangModelManager.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/17/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "YinXiangModelManager.h"

static YinXiangModelManager *a_instance=nil;

@implementation YinXiangModelManager

@synthesize mainArray=_mainArray;

+ (YinXiangModelManager*) sharedInstance{
    if (a_instance==nil) {
        a_instance=[[self alloc] init];
    }
    return a_instance;
}

- (id) init{
    self=[super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/yinxiang.plist", NSHomeDirectory()];
        _mainArray =[NSMutableArray arrayWithContentsOfFile:path];
        if (_mainArray==nil) {
            _mainArray =[[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveData{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/yinxiang.plist", NSHomeDirectory()];
    [_mainArray writeToFile:path atomically:YES];
}

@end
