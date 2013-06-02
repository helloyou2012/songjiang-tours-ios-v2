//
//  ViewportImage.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/21/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Viewport;

@interface ViewportImage : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) Viewport *viewport;

- (void)setData:(NSDictionary*)dict;
- (NSMutableDictionary*)getData;
@end
