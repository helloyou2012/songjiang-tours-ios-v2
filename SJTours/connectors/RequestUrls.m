//
//  RequestUrls.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/15/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "RequestUrls.h"

static NSString *DOMIN_NAME = @"http://112.124.40.118:8080/ToursManager/";

@implementation RequestUrls

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSString* queryPrefix = @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        NSString* escaped_value = [[params objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString*) domainUrl{
    return DOMIN_NAME;
}

+ (NSString*) cityUrl{
    return [DOMIN_NAME stringByAppendingString:@"city/get.json"];
}

+ (NSString*) galleryUrl{
    return [DOMIN_NAME stringByAppendingString:@"gallery/list.json"];
}

+ (NSString*)trafficList{
    return [DOMIN_NAME stringByAppendingString:@"traffic/list.json"];
}

+ (NSString*)viewportList{
    return [DOMIN_NAME stringByAppendingString:@"viewport/list.json"];
}

+ (NSString*)newsList{
    return [DOMIN_NAME stringByAppendingString:@"news/list.json"];
}

+ (NSString*)strategyList{
    return [DOMIN_NAME stringByAppendingString:@"strategy/list.json"];
}

+ (NSString*)publicPlaceList{
    return [DOMIN_NAME stringByAppendingString:@"publicplace/list.json"];
}

+ (NSString*)appList{
    return [DOMIN_NAME stringByAppendingString:@"app/list.json"];
}

@end
