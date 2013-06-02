//
//  YinXiangRequest.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/17/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YinXiangRequestDelegage

-(void) yinXiangRequestFinished:(NSMutableArray*)data withError:(NSString*)error;

@end

@interface YinXiangRequest : NSObject

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, retain) id<YinXiangRequestDelegage> delegate;
@property (nonatomic, strong) NSURLConnection *connection;

- (id)initWithUrl:(NSString*)url;
- (void)createConnection;

@end
