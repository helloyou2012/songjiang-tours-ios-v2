//
//  ViewSpotsModelManager.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewSpotsModelManager : NSObject

@property (nonatomic, strong) NSMutableArray *mainArray;
@property (nonatomic, strong) NSString *filename;

- (void)saveData;
- (id) initWith:(NSString*)filename;

@end
