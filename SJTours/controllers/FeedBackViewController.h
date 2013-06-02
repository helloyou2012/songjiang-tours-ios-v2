//
//  FeedBackViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGlowingTextField.h"
#import "KTTextView.h"

@interface FeedBackViewController : UIViewController

@property (nonatomic, strong) IBOutlet SLGlowingTextField *emailField;
@property (nonatomic, strong) IBOutlet KTTextView *textView;

- (IBAction)feedBackClicked:(id)sender;
@end
