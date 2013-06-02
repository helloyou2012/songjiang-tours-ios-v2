//
//  MapModelManager.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *mainArray;

+ (MapModelManager*) sharedInstance;
- (void)saveData;
@end
