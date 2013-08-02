//
//  GonglueRequest.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/19/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "GonglueRequest.h"
#import "RequestUrls.h"

@implementation GonglueRequest

@synthesize receivedData=_receivedData;
@synthesize requestData=_requestData;
@synthesize requestUrl=_requestUrl;
@synthesize delegate=_delegate;
@synthesize connection=_connection;

- (id)initWithUrl:(NSString*)url andData:(NSMutableDictionary*)data{
    if (self=[super init]) {
        _requestData=data;
        _requestUrl=url;
        NSLog(@"url:%@\ndata:%@",url,data);
    }
    return self;
}

- (void)createConnection{
    // Create the request.
    NSURL *url=[NSURL URLWithString:[RequestUrls serializeURL:_requestUrl params:_requestData]];
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
        [_delegate gonglueRequestFinished:nil withError:@"网络连接失败！"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [_delegate gonglueRequestFinished:nil withError:@"加载失败！"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    NSError *jsonError = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&jsonError];
    if (json!=nil) {
        [_delegate gonglueRequestFinished:json withError:nil];
    }else{
        [_delegate gonglueRequestFinished:nil withError:@"没有数据！"];
    }
    
}

@end
