//
//  ChengshiRequest.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChengshiRequestDelegage

-(void) chengshiRequestFinished:(NSDictionary*)data withError:(NSString*)error;

@end

@interface ChengshiRequest : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, retain) id<ChengshiRequestDelegage> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (id)initWithUrl:(NSString*)url;
- (void)createConnection;

@end
