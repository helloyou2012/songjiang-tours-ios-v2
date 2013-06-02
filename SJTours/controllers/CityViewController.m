//
//  CityViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "CityViewController.h"
#import "RequestUrls.h"
#import "SVProgressHUD.h"


@implementation CityViewController

@synthesize webView=_webView;
@synthesize request=_request;
@synthesize dictType=_dictType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _request=[[ChengshiRequest alloc] initWithUrl:[RequestUrls cityUrl]];
    _request.delegate=self;
    [_request createConnection];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillWebViewWith:(NSDictionary*)dict{
    NSURL *url=[[NSURL alloc] initWithString:[RequestUrls domainUrl]];
    NSString *body=[NSString stringWithFormat:@"<html><body style=\"background-color:#F4F4F4;\">%@</body></html>",[dict objectForKey:@"ccontent"]];
    [_webView loadHTMLString:body baseURL:url];
}

-(void) chengshiRequestFinished:(NSDictionary*)data withError:(NSString*)error{
    if (error) {
        [SVProgressHUD showErrorWithStatus:error];
    }else{
        [self fillWebViewWith:data];
    }
}

@end
