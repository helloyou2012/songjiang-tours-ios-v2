//
//  CityViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChengshiRequest.h"

@interface CityViewController : UIViewController<ChengshiRequestDelegage>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) ChengshiRequest *request;
@property (nonatomic, strong) NSDictionary *dictType;

@end
