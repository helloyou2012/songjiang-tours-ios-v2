//
//  GonglueModelManager.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/19/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GonglueModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *mainArray;

+ (GonglueModelManager*) sharedInstance;
- (void)saveData;

@end
