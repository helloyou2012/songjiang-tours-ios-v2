//
//  ZixunDetailViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/28/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "ZixunDetailViewController.h"
#import "MLNavigationController.h"
#import "RequestUrls.h"

@implementation ZixunDetailViewController

@synthesize curData=_curData;
@synthesize headerWebView=_headerWebView;
@synthesize headerView=_headerView;
@synthesize timeLabel=_timeLabel;
@synthesize titleLabel=_titleLabel;
@synthesize startPoint=_startPoint;

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
    self.view.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createViews{
    //create webview
    
    CGFloat curY=15.0f;
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, curY, 300, 10)];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.font=[UIFont boldSystemFontOfSize:20.0f];
    _titleLabel.text=[_curData objectForKey:@"ntitle"];
    _titleLabel.textColor=[UIColor blackColor];
    _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFit];
    
    curY+=_titleLabel.frame.size.height+5;
    _timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, curY, 300, 10)];
    _timeLabel.backgroundColor=[UIColor clearColor];
    _timeLabel.font=[UIFont systemFontOfSize:14.0f];
    _timeLabel.text=[_curData objectForKey:@"time"];
    _timeLabel.textColor=[UIColor lightGrayColor];
    _timeLabel.lineBreakMode = UILineBreakModeWordWrap;
    _timeLabel.numberOfLines = 0;
    [_timeLabel sizeToFit];
    curY+=_timeLabel.frame.size.height+5;
    
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, curY)];
    _headerView.backgroundColor=self.view.backgroundColor;
    [_headerView addSubview:_titleLabel];
    [_headerView addSubview:_timeLabel];
    
    _headerWebView=[[MMSmartHeaderWebView alloc] initWithFrame:self.view.bounds header:_headerView];
    NSURL *url=[[NSURL alloc] initWithString:[RequestUrls domainUrl]];
    NSString *body=[_curData objectForKey:@"ncontent"];
    [_headerWebView loadHTMLString:body baseURL:url];
    [self.view addSubview:_headerWebView];
    UIPanGestureRecognizer *gesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    gesture.delegate=self;
    [self.view addGestureRecognizer:gesture];
}

-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    if ([self.navigationController isKindOfClass:[MLNavigationController class]]) {
        CGPoint translation = [gestureRecognizer translationInView:self.view.superview];
        if (translation.x<0) {
            return;
        }
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:
                [((MLNavigationController*)self.navigationController) gestureRecognizerBegan:translation];
                break;
            case UIGestureRecognizerStateChanged:
                [((MLNavigationController*)self.navigationController) gestureRecognizerMoved:translation];
                break;
            default:
                [((MLNavigationController*)self.navigationController) gestureRecognizerEnded:translation];
                break;
        }
    }
}

@end
