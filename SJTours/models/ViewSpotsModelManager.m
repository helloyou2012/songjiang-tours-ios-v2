//
//  ViewSpotsModelManager.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ViewSpotsModelManager.h"


@implementation ViewSpotsModelManager

@synthesize mainArray=_mainArray;
@synthesize filename=_filename;

- (id) initWith:(NSString*)filename{
    self=[super init];
    if (self) {
        _filename=filename;
        NSString *path = [NSString stringWithFormat:@"%@/%@.plist", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], _filename];
        _mainArray =[NSMutableArray arrayWithContentsOfFile:path];
        if (_mainArray==nil) {
            _mainArray =[[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)saveData{
    NSString *path = [NSString stringWithFormat:@"%@/%@.plist", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], _filename];
    NSLog(@"write to file:%@",path);
    [_mainArray writeToFile:path atomically:YES];
}

@end
