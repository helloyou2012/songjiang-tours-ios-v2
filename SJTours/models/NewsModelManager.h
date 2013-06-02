//
//  NewsModelManager.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *mainArray;

+ (NewsModelManager*) sharedInstance;
- (void)saveData;
@end
