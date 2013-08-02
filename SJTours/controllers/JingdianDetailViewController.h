//
//  JingdianDetailViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/27/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "NiftyButton.h"
#import "SinaWeibo.h"
#import "TCWBEngine.h"
#import "MWPhotoBrowser.h"

@class PopView;

@interface JingdianDetailViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,SinaWeiboRequestDelegate,MWPhotoBrowserDelegate,SinaWeiboDelegate>

@property (nonatomic, strong) NSDictionary *curData;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *mapBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *bigImageButton;
@property (nonatomic, strong) FTCoreTextView *contentView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) NiftyButton *homepageButton;
@property (nonatomic, strong) UIButton *callButton;

@property (nonatomic, strong) PopView *popView;


- (NSArray *)coreTextStyle;
- (void)createViews;
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer;
- (void)openURL;
- (void)openImagesView;
- (BOOL)isFavored;
@end
