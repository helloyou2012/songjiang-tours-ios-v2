//
//  RequestUrls.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/15/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestUrls : NSObject

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params;
+ (NSString*) domainUrl;
+ (NSString*) cityUrl;
+ (NSString*) galleryUrl;
+ (NSString*)trafficList;
+ (NSString*)viewportList;
+ (NSString*)newsList;
+ (NSString*)strategyList;
+ (NSString*)publicPlaceList;
+ (NSString*)appList;
@end
