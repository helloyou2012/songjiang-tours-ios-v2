//
//  PublicPlaceModelManager.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "PublicPlaceModelManager.h"

static PublicPlaceModelManager *a_instance=nil;

@implementation PublicPlaceModelManager

@synthesize mainArray=_mainArray;

+ (PublicPlaceModelManager*) sharedInstance{
    if (a_instance==nil) {
        a_instance=[[self alloc] init];
    }
    return a_instance;
}

- (id) init{
    self=[super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/public_place.plist", NSHomeDirectory()];
        _mainArray =[NSMutableArray arrayWithContentsOfFile:path];
        if (_mainArray==nil) {
            _mainArray =[[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveData{
    NSString *path = [NSString stringWithFormat:@"%@/Documents/public_place.plist", NSHomeDirectory()];
    [_mainArray writeToFile:path atomically:YES];
}
@end
