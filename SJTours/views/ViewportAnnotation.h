//
//  ViewportAnnotation.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "BMKPointAnnotation.h"

@interface ViewportAnnotation : BMKPointAnnotation

@property (nonatomic, strong) NSDictionary *dictData;
- (id)initWith:(NSDictionary*)dict;
@end
