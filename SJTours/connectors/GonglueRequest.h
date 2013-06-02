//
//  GonglueRequest.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/19/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GonglueRequestDelegage

-(void) gonglueRequestFinished:(NSArray*)data withError:(NSString*)error;

@end


@interface GonglueRequest : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSMutableDictionary *requestData;
@property (nonatomic, retain) id<GonglueRequestDelegage> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (id)initWithUrl:(NSString*)url andData:(NSMutableDictionary*)data;
- (void)createConnection;

@end
