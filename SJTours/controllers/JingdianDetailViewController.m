//
//  JingdianDetailViewController.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/27/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "JingdianDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MLNavigationController.h"
#import "RequestUrls.h"
#import "UIButton+WebCache.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "Viewport.h"
#import "ViewportImage.h"
#import "SVProgressHUD.h"
#import "PopView.h"
#import <QuartzCore/QuartzCore.h>

#define BAR_HEIGHT 46.0f
#define PADDING 15.0f

@implementation JingdianDetailViewController

@synthesize curData=_curData;
@synthesize scrollView=_scrollView;
@synthesize addBtn=_addBtn;
@synthesize shareBtn=_shareBtn;
@synthesize mapBtn=_mapBtn;

@synthesize titleLabel=_titleLabel;
@synthesize bigImageButton=_bigImageButton;
@synthesize contentView=_contentView;
@synthesize priceLabel=_priceLabel;
@synthesize addressLabel=_addressLabel;
@synthesize phoneLabel=_phoneLabel;
@synthesize tagLabel=_tagLabel;
@synthesize callButton=_callButton;
@synthesize homepageButton=_homepageButton;

@synthesize popView=_popView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:246.0f/255.0f green:243.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    
    UIPanGestureRecognizer *gesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handelPan:)];
    gesture.delegate=self;
    [self.view addGestureRecognizer:gesture];
    
    [self createViews];
	// Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)coreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
	defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
	defaultStyle.font = [UIFont systemFontOfSize:14.0f];
    defaultStyle.color=[UIColor colorWithWhite:51.0f/255.0f alpha:1.0f];
	defaultStyle.textAlignment = FTCoreTextAlignementLeft;
	[result addObject:defaultStyle];
	
	FTCoreTextStyle *linkStyle = [defaultStyle copy];
	linkStyle.name = FTCoreTextTagLink;
	linkStyle.color = [UIColor colorWithRed:132.0/255.0 green:147.0/255.0 blue:174.0/255.0 alpha:1.0];
	[result addObject:linkStyle];
    return  result;
}

- (void)createViews{
    CGRect rect=self.view.bounds;
    rect.size.height=rect.size.height-BAR_HEIGHT-42.0f;
    _scrollView=[[UIScrollView alloc] initWithFrame:rect];
    _scrollView.backgroundColor=[UIColor clearColor];
    _scrollView.canCancelContentTouches=YES;
    
    CGFloat curY=15.0f;
    //标题
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 10)];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.font=[UIFont boldSystemFontOfSize:16.0f];
    _titleLabel.text=[_curData objectForKey:@"vtitle"];
    _titleLabel.textColor=[UIColor blackColor];
    _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    _titleLabel.numberOfLines = 0;
    [_titleLabel sizeToFit];
    [_scrollView addSubview:_titleLabel];
    curY+=_titleLabel.frame.size.height+15;
    
    //图片
    _bigImageButton=[[UIButton alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 200.0f)];
    [[_bigImageButton layer] setBorderWidth:5.0f];
    [[_bigImageButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [_bigImageButton.layer setShadowOffset:CGSizeMake(0, 0)];
    [_bigImageButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_bigImageButton.layer setShadowOpacity:0.3];
    [_bigImageButton.layer setShadowRadius:1.0f];
    [_bigImageButton addTarget:self action:@selector(openImagesView) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *vbigImages=[_curData objectForKey:@"vbigImage"];
    if (vbigImages!=nil&&vbigImages.count>0) {
        NSDictionary *bigImage=[vbigImages objectAtIndex:0];
        NSString *url=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[bigImage objectForKey:@"imageUrl"]];
        NSURL *imageUrl=[[NSURL alloc] initWithString:url];
        [_bigImageButton setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }else{
        [_bigImageButton setImage:[UIImage imageNamed:@"placeholder"] forState:UIControlStateNormal];
    }
    
    _bigImageButton.backgroundColor=[UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.0f];
    [_scrollView addSubview:_bigImageButton];
    curY+=_bigImageButton.frame.size.height+15;
    
    //详细内容
    _contentView=[[FTCoreTextView alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 10)];
	_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_contentView setText:[_curData objectForKey:@"vcontent"]];
    // set styles
    [_contentView addStyles:[self coreTextStyle]];
    [_contentView setDelegate:nil];
	[_contentView fitToSuggestedHeight];
    [_scrollView addSubview:_contentView];
    curY+=_contentView.frame.size.height+10.0f;
    
    //分割线
    UIImageView *lineView1=[[UIImageView alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 2)];
    lineView1.backgroundColor=[UIColor clearColor];
    lineView1.image=[UIImage imageNamed:@"toolbar_line"];
    [_scrollView addSubview:lineView1];
    curY+=12.0f;
    
    //价格
    _priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 10)];
    _priceLabel.backgroundColor=[UIColor clearColor];
    _priceLabel.font=[UIFont systemFontOfSize:14.0f];
    _priceLabel.text=[NSString stringWithFormat:@"价格：%@",[_curData objectForKey:@"vprice"]];
    _priceLabel.textColor=[UIColor blackColor];
    _priceLabel.lineBreakMode = UILineBreakModeWordWrap;
    _priceLabel.numberOfLines = 0;
    [_priceLabel sizeToFit];
    [_scrollView addSubview:_priceLabel];
    curY+=_priceLabel.frame.size.height+5;
    
    //地址
    _addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 10)];
    _addressLabel.backgroundColor=[UIColor clearColor];
    _addressLabel.font=[UIFont systemFontOfSize:14.0f];
    _addressLabel.text=[NSString stringWithFormat:@"地址：%@",[_curData objectForKey:@"vaddress"]];
    _addressLabel.textColor=[UIColor blackColor];
    _addressLabel.lineBreakMode = UILineBreakModeWordWrap;
    _addressLabel.numberOfLines = 0;
    [_addressLabel sizeToFit];
    [_scrollView addSubview:_addressLabel];
    curY+=_addressLabel.frame.size.height+5;
    
    //电话
    _phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 10)];
    _phoneLabel.backgroundColor=[UIColor clearColor];
    _phoneLabel.font=[UIFont systemFontOfSize:14.0f];
    _phoneLabel.text=[NSString stringWithFormat:@"电话：%@",[_curData objectForKey:@"vphoneNumber"]];
    _phoneLabel.textColor=[UIColor blackColor];
    _phoneLabel.lineBreakMode = UILineBreakModeWordWrap;
    _phoneLabel.numberOfLines = 0;
    [_phoneLabel sizeToFit];
    [_scrollView addSubview:_phoneLabel];
    curY+=_phoneLabel.frame.size.height+5;
    
    //标签
    _tagLabel=[[UILabel alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 10)];
    _tagLabel.backgroundColor=[UIColor clearColor];
    _tagLabel.font=[UIFont systemFontOfSize:14.0f];
    _tagLabel.text=[NSString stringWithFormat:@"标签：%@",[_curData objectForKey:@"vlabel"]];
    _tagLabel.textColor=[UIColor blackColor];
    _tagLabel.lineBreakMode = UILineBreakModeWordWrap;
    _tagLabel.numberOfLines = 0;
    [_tagLabel sizeToFit];
    [_scrollView addSubview:_tagLabel];
    curY+=_tagLabel.frame.size.height+10.0f;
    
    //分割线
    UIImageView *lineView2=[[UIImageView alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 2)];
    lineView2.backgroundColor=[UIColor clearColor];
    lineView2.image=[UIImage imageNamed:@"toolbar_line"];
    [_scrollView addSubview:lineView2];
    curY+=10.0f;
    
    //网站
    _homepageButton=[[NiftyButton alloc] initWithFrame:CGRectMake(PADDING, curY, 320-2*PADDING, 37)];
    [_homepageButton setTitle:@"查看官方网站" forState:UIControlStateNormal];
    _homepageButton.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    NSString *url=[_curData objectForKey:@"vhomepage"];
    if (url&&url.length>0) {
        _homepageButton.enabled=YES;
    }else{
        _homepageButton.enabled=NO;
        _homepageButton.titleLabel.textColor=[UIColor lightGrayColor];
    }
    [_homepageButton addTarget:self action:@selector(openURL) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_homepageButton];
    curY+=_homepageButton.frame.size.height+8.0f;
    
    rect.size.height=curY;
    _scrollView.contentSize=rect.size;
    [self.view addSubview:_scrollView];
    
    curY=_scrollView.frame.size.height;
    //分割线
    UIImageView *lineView3=[[UIImageView alloc] initWithFrame:CGRectMake(0, curY-4, 320, 6)];
    lineView3.backgroundColor=[UIColor clearColor];
    lineView3.image=[UIImage imageNamed:@"top_shadow"];
    lineView3.alpha=0.8f;
    [self.view addSubview:lineView3];
    curY+=2.0f;
    
    //Call
    _callButton=[[UIButton alloc] initWithFrame:CGRectMake(56.0f, curY+8.0f, 28, 28)];
    [_callButton setImage:[UIImage imageNamed:@"toolbar_call"] forState:UIControlStateNormal];
    [_callButton addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_callButton];
    
    _addBtn=[[UIButton alloc] initWithFrame:CGRectMake(116, curY+8.0f, 28, 28)];
    [_addBtn setImage:[UIImage imageNamed:@"toolbar_add"] forState:UIControlStateSelected];
    [_addBtn setImage:[UIImage imageNamed:@"toolbar_add_no"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addFavorClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
    
    _shareBtn=[[UIButton alloc] initWithFrame:CGRectMake(176, curY+8.0f, 28, 28)];
    [_shareBtn setImage:[UIImage imageNamed:@"toolbar_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn];
    
    _mapBtn=[[UIButton alloc] initWithFrame:CGRectMake(236, curY+8.0f, 28, 28)];
    [_mapBtn setImage:[UIImage imageNamed:@"toolbar_map"] forState:UIControlStateNormal];
    [_mapBtn addTarget:self action:@selector(mapButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mapBtn];
    
    if ([self isFavored]) {
        [_addBtn setSelected:YES];
    }else{
        [_addBtn setSelected:NO];
    }
}

- (void)callBtnClicked{
    NSString *url=[_curData objectForKey:@"vphoneNumber"];
    if (url!=nil&&url.length>0) {
        url=[NSString stringWithFormat:@"tel://%@",url];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        [SVProgressHUD showErrorWithStatus:@"暂时没有电话！"];
    }
}

- (void)mapButtonClicked{
    [self performSegueWithIdentifier:@"gotoMap" sender:self];
}

- (void)shareBtnClicked{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", @"腾讯微博",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_popView) {
        [_popView setPostImage:_bigImageButton.currentImage];
    }else{
        _popView=[[PopView alloc] initWithFrame:CGRectMake(0, 0, 320, 209) withImage:_bigImageButton.currentImage];
        [_popView.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    _popView.textView.text=[NSString stringWithFormat:@"//分享松江旅游：「%@」", _titleLabel.text];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (buttonIndex == 0) {
        //新浪
        _popView.titleLabel.text=@"新浪微博";
        if ([delegate.sinaweibo isAuthValid]) {
            [_popView showInView:nil];
        }else{
            //[SVProgressHUD showErrorWithStatus:@"亲，请先绑定新浪微博哦！"];
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo logIn];
        }
    }else if (buttonIndex == 1) {
        //腾讯
        _popView.titleLabel.text=@"腾讯微博";
        if ([delegate.txweibo isAuthorizeExpired]) {
            //[SVProgressHUD showErrorWithStatus:@"亲，请先绑定新浪微博哦！"];
            TCWBEngine *txweibo = [self txweibo];
            [txweibo logInWithDelegate:self
                             onSuccess:@selector(onSuccessLogin)
                             onFailure:@selector(onFailureLogin:)];
        }else{
            
            [_popView showInView:nil];
        }
    }
}

-(void)shareButtonClicked{
    if (_popView.textView.text.length>0) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([_popView.titleLabel.text isEqualToString:@"新浪微博"]) {
            [delegate.sinaweibo requestWithURL:@"statuses/upload.json"
                                        params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                _popView.textView.text, @"status",
                                                [self convertToPostData:_popView.imageView.image], @"pic",
                                                [NSString stringWithFormat:@"%@",[_curData objectForKey:@"lng"]],@"long",
                                                [NSString stringWithFormat:@"%@",[_curData objectForKey:@"lat"]],@"lat",nil]
                                    httpMethod:@"POST"
                                      delegate:self];
        }else{
            NSMutableDictionary *dicAppFrom = [NSMutableDictionary dictionaryWithObject:@"松江旅游" forKey:@"appfrom"];
            // 调用发带图片微博借口
            [delegate.txweibo postPictureTweetWithFormat:@"json"
                                                 content:_popView.textView.text
                                                clientIP:nil
                                                     pic:[self convertToPostData:_popView.imageView.image]
                                          compatibleFlag:@"0"
                                               longitude:[NSString stringWithFormat:@"%@",[_curData objectForKey:@"lng"]]
                                             andLatitude:[NSString stringWithFormat:@"%@",[_curData objectForKey:@"lat"]]
                                             parReserved:dicAppFrom
                                                delegate:self
                                               onSuccess:@selector(successCallback)
                                               onFailure:@selector(failureCallback)];
        }
        [_popView dismiss];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写分享内容！"];
    }
}

- (void)successCallback{
    [SVProgressHUD showSuccessWithStatus:@"发送成功！"];
}

-(void)failureCallback{
    [SVProgressHUD showErrorWithStatus:@"发送失败！"];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/upload.json"]){
        [SVProgressHUD showErrorWithStatus:@"发送失败！"];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/upload.json"]){
        [SVProgressHUD showSuccessWithStatus:@"发送成功！"];
    }
}

- (void)openURL{
    NSString *url=[_curData objectForKey:@"vhomepage"];
    if (url!=nil&&url.length>0) {
        if (![url hasPrefix:@"http"]) {
            url=[NSString stringWithFormat:@"http://%@",url];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)addFavorClicked{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self isFavored]) {
        [delegate deleteObject:[_curData objectForKey:@"id"] with:@"Viewport"];
        [_addBtn setSelected:NO];
        [SVProgressHUD showSuccessWithStatus:@"取消收藏！"];
    }else{
        [delegate deleteObject:[_curData objectForKey:@"id"] with:@"Viewport"];
        NSManagedObjectContext *context = [delegate managedObjectContext];
        Viewport *viewport=[NSEntityDescription insertNewObjectForEntityForName:@"Viewport" inManagedObjectContext:context];
        [viewport setData:_curData];
        NSArray *bigImages=[_curData objectForKey:@"vbigImage"];
        for (NSDictionary *dict in bigImages) {
            [delegate deleteObject:[dict objectForKey:@"id"] with:@"ViewportImage"];
            ViewportImage *viewportImage=[NSEntityDescription insertNewObjectForEntityForName:@"ViewportImage" inManagedObjectContext:context];
            [viewportImage setData:dict];
            [viewportImage setViewport:viewport];
        }
        NSError *error=nil;
        if ([context hasChanges] && ![context save:&error]) {
            [SVProgressHUD showErrorWithStatus:@"收藏失败！"];
            [_addBtn setSelected:NO];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"收藏成功！"];
            [_addBtn setSelected:YES];
        }
    }
}

- (BOOL)isFavored{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSError *error=nil;
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Viewport" inManagedObjectContext:context]];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(id == %@)", [_curData objectForKey:@"id"]];
    [fetchRequest setPredicate:predicate];
    NSArray *objects=[context executeFetchRequest:fetchRequest error:&error];
    if (objects&&objects.count>0) {
        return YES;
    }
    return NO;
}

- (void)openImagesView{
    NSArray *vbigImages=[_curData objectForKey:@"vbigImage"];
    if (vbigImages!=nil&&vbigImages.count>0) {
        //[self performSegueWithIdentifier:@"gotoImageView" sender:self];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        browser.wantsFullScreenLayout = NO;
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:nc animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前页面不存在图片"];
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    NSArray *vbigImages=[_curData objectForKey:@"vbigImage"];
    return vbigImages.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSArray *vbigImages=[_curData objectForKey:@"vbigImage"];
    NSDictionary *imageDict=[vbigImages objectAtIndex:index];
    NSString *url=[NSString stringWithFormat:@"%@%@",[RequestUrls domainUrl],[imageDict objectForKey:@"imageUrl"]];
    NSURL *imageUrl=[[NSURL alloc] initWithString:url];
    MWPhoto *photo=[MWPhoto photoWithURL:imageUrl];
    return photo;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gotoMap"]) {
        [segue.destinationViewController setValue:_curData forKey:@"curData"];
    }else{
        [segue.destinationViewController setValue:[_curData objectForKey:@"vbigImage"] forKey:@"imageArray"];
    }
}

- (NSData*)convertToPostData:(UIImage*)imageReadyPost{
    NSData *dataImage = UIImageJPEGRepresentation(imageReadyPost, 1.0);
    NSUInteger sizeOrigin = [dataImage length];
    NSUInteger sizesizeOriginKB = sizeOrigin / 1024;
    // 图片大于500k要先进行压缩
    if (sizesizeOriginKB > 500) {
        float a = 500.00000;
        float  b = (float)sizesizeOriginKB;
        float q = sqrt(a/b);
        CGSize sizeImage = [imageReadyPost size];
        CGFloat iwidthSmall = sizeImage.width * q;
        CGFloat iheightSmall = sizeImage.height * q;
        CGSize itemSizeSmall = CGSizeMake(iwidthSmall, iheightSmall);
        UIGraphicsBeginImageContext(itemSizeSmall);
        CGRect imageRectSmall = CGRectMake(0.0f, 0.0f, itemSizeSmall.width, itemSizeSmall.height);
        [imageReadyPost drawInRect:imageRectSmall];
        UIImage *SmallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *dataImageSend = UIImageJPEGRepresentation(SmallImage, 1.0);
        dataImage = dataImageSend;
    }
    return dataImage;
}

- (UIImage*)convertToPostImage:(UIImage*)imageReadyPost{
    NSData *dataImage = UIImageJPEGRepresentation(imageReadyPost, 1.0);
    NSUInteger sizeOrigin = [dataImage length];
    NSUInteger sizesizeOriginKB = sizeOrigin / 1024;
    // 图片大于500k要先进行压缩
    if (sizesizeOriginKB > 500) {
        float a = 500.00000;
        float  b = (float)sizesizeOriginKB;
        float q = sqrt(a/b);
        CGSize sizeImage = [imageReadyPost size];
        CGFloat iwidthSmall = sizeImage.width * q;
        CGFloat iheightSmall = sizeImage.height * q;
        CGSize itemSizeSmall = CGSizeMake(iwidthSmall, iheightSmall);
        UIGraphicsBeginImageContext(itemSizeSmall);
        CGRect imageRectSmall = CGRectMake(0.0f, 0.0f, itemSizeSmall.width, itemSizeSmall.height);
        [imageReadyPost drawInRect:imageRectSmall];
        UIImage *SmallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return SmallImage;
    }
    return imageReadyPost;
}

#pragma mark - SinaWeibo delegate

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.sinaweibo.delegate=self;
    return delegate.sinaweibo;
    
}
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
    [_popView showInView:nil];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"登录失败！"];
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"账号过期或失效！"];
}

#pragma mark - TengxunWeibo delegate

- (TCWBEngine*)txweibo{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.txweibo setRootViewController:self];
    return delegate.txweibo;
}

//登录成功回调
- (void)onSuccessLogin
{
    [_popView showInView:nil];
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"登录失败！"];
}

@end
