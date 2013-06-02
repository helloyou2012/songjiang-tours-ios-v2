//
//  PopView.m
//  PopViewTest
//
//  Created by HelloYou on 12/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PopView.h"

#define kTextAlignment UITextAlignmentCenter

//title font
#define kTitleFont [UIFont boldSystemFontOfSize:17.0f]

//title text color
#define kTitleColor [UIColor colorWithRed:0.329 green:0.341 blue:0.353 alpha:1]

static NSString *bundleURL = @"ShareSDKiPhoneSimpleShareViewUI.bundle/Publish/";

@implementation PopView

@synthesize titleView=_titleView;
@synthesize titleLabel=_titleLabel;
@synthesize contentView=_contentView;
@synthesize textView=_textView;
@synthesize imageView=_imageView;
@synthesize countLabel=_countLabel;
@synthesize maxCount=_maxCount;
@synthesize closeButton=_closeButton;
@synthesize shareButton=_shareButton;
@synthesize delegate=_delegate;
@synthesize postImage=_postImage;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)img
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        _maxCount=140;
        [self createViews];
        _titleLabel.text=@"新浪微博";
        _postImage=img;
        [_imageView setImage:_postImage];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    return self;
}

- (void)setPostImage:(UIImage *)postImage{
    _postImage=postImage;
    [_imageView setImage:_postImage];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)createViews{
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:self.bounds];
    [backImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",bundleURL,@"AGShareBG"]]];
    [self addSubview:backImageView];
    //Create a label for the title text.
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, self.frame.size.width, 22)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = kTitleFont;
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.textColor = kTitleColor;

    _titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 54.0f)];
    [_titleView addSubview:_titleLabel];
    
    _closeButton=[[UIButton alloc] initWithFrame:CGRectMake(12, 17, 49, 30)];
    [_closeButton setTitle:@"取消" forState:UIControlStateNormal];
    _closeButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    [_closeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",bundleURL,@"AGShareCancelButton"]] forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(handleCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_closeButton];
    
    _shareButton=[[UIButton alloc] initWithFrame:CGRectMake(320.0f-12-49, 17, 49, 30)];
    [_shareButton setTitle:@"发布" forState:UIControlStateNormal];
    _shareButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];
    [_shareButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",bundleURL,@"AGShareSubmitButton"]] forState:UIControlStateNormal];
    [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_titleView addSubview:_shareButton];
    
    //Create content View
    _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, 54, 320, 209-54)];
    //Create text View
    _textView=[[UITextView alloc] initWithFrame:CGRectMake(15, 0, 205, 108)];
    _textView.backgroundColor=[UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:14.0f];
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [_contentView addSubview:_textView];
    //Create image view
    UIImageView *imageBG=[[UIImageView alloc] initWithFrame:CGRectMake(223, 14, 77, 77)];
    [imageBG setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",bundleURL,@"AGShareImageBG"]]];
    [_contentView addSubview:imageBG];
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(228, 19, 67, 67)];
    [_contentView addSubview:_imageView];
    
    UIImageView *pinView=[[UIImageView alloc] initWithFrame:CGRectMake(240, 0, 80, 36)];
    [pinView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",bundleURL,@"AGSharePin"]]];
    [_contentView addSubview:pinView];
    
    if (_maxCount > 0) {
        _countLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 115, 300, 22)];
        _countLabel.textAlignment = UITextAlignmentRight;
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor lightGrayColor];
        _countLabel.font = [UIFont boldSystemFontOfSize:14];
        [_contentView addSubview:_countLabel];
    }
    [self addSubview:_contentView];
    [self addSubview:_titleView];
}

- (void)resetViews{
    if (_maxCount > 0) {
        [self updateCount];
    }
}

#pragma mark Show/Dismiss

- (void)showInView:(UIView*)view
{
    // TODO: show in window + orientation handling
    if (!view || [view isKindOfClass:[UIWindow class]]) {
        NSLog(@"Warning: show in window currently doesn't support orientation.");
    }
    
    UIView* targetView = nil;
    CGRect frame;
    if (!view) {
        targetView = [UIApplication sharedApplication].keyWindow;
        frame = [UIScreen mainScreen].applicationFrame;
    }
    else {
        targetView = view;
        frame = view.bounds;
    }
    
    self.alpha = 0;
    self.frame = frame;
    [targetView addSubview:self];
    
    [self updateCount];
    [self startObservingNotifications];
    [_textView becomeFirstResponder];
}

- (void)dismiss
{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}

#pragma mark Count

- (void)updateCount
{
    NSUInteger textCount = [_textView.text length];
    _countLabel.text = [NSString stringWithFormat:@"%d", _maxCount-textCount];
    
    if (textCount > _maxCount) {
        _countLabel.textColor = [UIColor redColor];
    } else {
        _countLabel.textColor = [UIColor lightGrayColor];
    }
    //[_countLabel sizeToFit];
}

#pragma mark Buttons

- (void)handleCloseButton:(UIButton*)sender
{
    [self dismiss];
}

#pragma mark Notifications

- (void)startObservingNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification 
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveTextDidEndEditingNotification:)
                                                 name:UITextViewTextDidEndEditingNotification 
                                               object:nil];
}

- (void)stopObservingNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)didReceiveKeyboardWillShowNotification:(NSNotification*)notification
{
    if (!self.superview) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.f;
    }];
    
}

- (void)didReceiveTextDidChangeNotification:(NSNotification*)notification
{
    if ([notification object] != _textView) return;
    
    [self updateCount];
}

- (void)didReceiveTextDidEndEditingNotification:(NSNotification*)notification
{
    if ([notification object] != _textView) return;
    
    [self stopObservingNotifications];
    
    if ([_textView.delegate respondsToSelector:@selector(popupTextView:willDismissWithText:)]) {
        [self.delegate popupTextView:self willDismissWithText:_textView.text];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            if ([_textView.delegate respondsToSelector:@selector(popupTextView:didDismissWithText:)]) {
                [self.delegate popupTextView:self didDismissWithText:_textView.text];
            }
            
            [self removeFromSuperview];
        }
        
    }];
}

@end
