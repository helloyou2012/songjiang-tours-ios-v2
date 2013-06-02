//
//  FeedBackViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "FeedBackViewController.h"
#import "SVProgressHUD.h"

@implementation FeedBackViewController

@synthesize emailField=_emailField;
@synthesize textView=_textView;

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
    self.view.backgroundColor=[UIColor colorWithRed:243.0f/255.0f green:246.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    _textView.text=@"";
    [_textView setFont:[UIFont systemFontOfSize:14.0f]];
    [_textView setPlaceholderText:@"请输入反馈，我们将为您不断改进"];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_emailField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedBackClicked:(id)sender{
    if (_textView.text.length>0) {
        [SVProgressHUD showSuccessWithStatus:@"我们将尽快给您回复"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请您填写意见"];
    }
}

@end
