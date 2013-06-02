//
//  PublicPlaceAnnotation.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "BMKPointAnnotation.h"

@interface PublicPlaceAnnotation : BMKPointAnnotation

@property (nonatomic, strong) NSDictionary *dictData;
- (id)initWith:(NSDictionary*)dict;

@end
