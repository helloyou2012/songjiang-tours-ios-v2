//
//  PublicPlaceRequest.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/30/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PublicPlaceRequestDelegage

-(void) publicPlaceRequestFinished:(NSArray*)data withError:(NSString*)error;

@end

@interface PublicPlaceRequest : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSDictionary *requestData;
@property (nonatomic, retain) id<PublicPlaceRequestDelegage> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (id)initWithUrl:(NSString*)url andData:(NSDictionary*)data;
- (void)createConnection;

@end
