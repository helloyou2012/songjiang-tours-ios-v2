//
//  ZixunRequest.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZixunRequestDelegage

-(void) zixunRequestFinished:(NSArray*)data withError:(NSString*)error;

@end

@interface ZixunRequest : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSDictionary *requestData;
@property (nonatomic, retain) id<ZixunRequestDelegage> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (id)initWithUrl:(NSString*)url andData:(NSDictionary*)data;
- (void)createConnection;

@end
