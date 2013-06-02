//
//  PopView.h
//  PopViewTest
//
//  Created by HelloYou on 12/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopView;

@protocol PopViewDelegate <UITextViewDelegate>
@optional
- (void)popupTextView:(PopView*)textView willDismissWithText:(NSString*)text;
- (void)popupTextView:(PopView*)textView didDismissWithText:(NSString*)text;
@end

@interface PopView : UIView
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *postImage;

@property (nonatomic, strong) UILabel*    countLabel;
@property (nonatomic, strong) UIButton*   closeButton;
@property (nonatomic, strong) UIButton*   shareButton;
@property (nonatomic, assign) NSUInteger  maxCount;
@property (nonatomic, strong) id <PopViewDelegate> delegate;

- (void)createViews;
- (void)resetViews;
- (void)updateCount;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (id)initWithFrame:(CGRect)frame withImage:(UIImage*)img;

- (void)startObservingNotifications;
- (void)stopObservingNotifications;
@end
