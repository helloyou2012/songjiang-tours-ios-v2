//
//  NewsModelManager.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "NewsModelManager.h"
static NewsModelManager *a_instance=nil;

@implementation NewsModelManager

@synthesize mainArray=_mainArray;

+ (NewsModelManager*) sharedInstance{
    if (a_instance==nil) {
        a_instance=[[self alloc] init];
    }
    return a_instance;
}

- (id) init{
    self=[super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/zixun.plist", NSHomeDirectory()];
        _mainArray =[NSMutableArray arrayWithContentsOfFile:path];
        if (_mainArray==nil) {
            _mainArray =[[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveData{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/zixun.plist", NSHomeDirectory()];
    [_mainArray writeToFile:path atomically:YES];
}
@end
