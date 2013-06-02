//
//  JingdianRequest.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JingdianRequestDelegage

-(void) jingdianRequestFinished:(NSArray*)data withError:(NSString*)error;

@end

@interface JingdianRequest : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSDictionary *requestData;
@property (nonatomic, retain) id<JingdianRequestDelegage> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (id)initWithUrl:(NSString*)url andData:(NSDictionary*)data;
- (void)createConnection;

@end
