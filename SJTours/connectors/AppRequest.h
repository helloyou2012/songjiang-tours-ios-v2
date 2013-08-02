//
//  AppRequest.h
//  SJTours
//
//  Created by ZhenzhenXu on 7/4/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppRequestDelegage

-(void) appRequestFinished:(NSArray*)data withError:(NSString*)error;

@end


@interface AppRequest : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSMutableDictionary *requestData;
@property (nonatomic, retain) id<AppRequestDelegage> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (id)initWithUrl:(NSString*)url andData:(NSMutableDictionary*)data;
- (void)createConnection;

@end
