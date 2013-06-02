//
//  YinXiangModelManager.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/17/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YinXiangModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *mainArray;

+ (YinXiangModelManager*) sharedInstance;
- (void)saveData;

@end
