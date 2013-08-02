//
//  YinXiangRequest.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/17/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "YinXiangRequest.h"

@implementation YinXiangRequest

@synthesize receivedData=_receivedData;
@synthesize requestUrl=_requestUrl;
@synthesize delegate=_delegate;
@synthesize connection=_connection;

- (id)initWithUrl:(NSString*)url{
    if (self=[super init]) {
        _requestUrl=url;
    }
    return self;
}

- (void)createConnection{
    // Create the request.
    NSURL *url=[NSURL URLWithString:_requestUrl];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    [request setTimeoutInterval:30.0f];
    [request setHTTPMethod:@"GET"];
    // create the connection with the request
    // and start loading the data
    
    _connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (_connection) {
        // Create the NSMutableData to hold the received data.
        _receivedData = [NSMutableData data];
        
    } else {
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    [_receivedData setLength:0];
    
    NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
    if (statusCode > 400)
    {
        [connection cancel];  // stop connecting; no more delegate messages
        [_delegate yinXiangRequestFinished:nil withError:@"网络连接失败！"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [_delegate yinXiangRequestFinished:nil withError:@"网络连接失败！"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    NSError *jsonError = nil;
    NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&jsonError];
    if (json==nil) {
        [_delegate yinXiangRequestFinished:nil withError:@"网络连接失败！"];
    } else {
        [_delegate yinXiangRequestFinished:json withError:nil];
    }
    
}

@end
