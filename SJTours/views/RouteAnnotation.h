//
//  RouteAnnotation.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/1/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "BMKPointAnnotation.h"

@interface RouteAnnotation : BMKPointAnnotation

//<0:起点 1：终点 2：公交 3：地铁 4:驾乘
@property (nonatomic) int type;
@property (nonatomic) int degree;
@end
