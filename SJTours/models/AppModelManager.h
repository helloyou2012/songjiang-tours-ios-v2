//
//  AppModelManager.h
//  SJTours
//
//  Created by ZhenzhenXu on 7/4/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModelManager : NSObject
@property (nonatomic, strong) NSMutableArray *mainArray;

+ (AppModelManager*) sharedInstance;
- (void)saveData;
@end
