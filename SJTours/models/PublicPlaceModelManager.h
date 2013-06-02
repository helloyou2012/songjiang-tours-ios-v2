//
//  PublicPlaceModelManager.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicPlaceModelManager : NSObject
@property (nonatomic, strong) NSMutableArray *mainArray;

+ (PublicPlaceModelManager*) sharedInstance;
- (void)saveData;
@end
