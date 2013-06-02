//
//  RouteSearchView.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/11/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "RouteSearchView.h"
#import "SVProgressHUD.h"

@implementation RouteSearchView

@synthesize fromTextField=_fromTextField;
@synthesize toTextField=_toTextField;
@synthesize swapBtn=_swapBtn;
@synthesize delegate=_delegate;
@synthesize baseAddress=_baseAddress;
@synthesize baseLat=_baseLat;
@synthesize baseLng=_baseLng;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createViews{
    self.backgroundColor=[UIColor clearColor];
    UIView *backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 89)];
    backView.backgroundColor=[UIColor whiteColor];
    [self addSubview:backView];
    
    UIImageView *lineImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 89, 320, 6)];
    lineImage.image=[UIImage imageNamed:@"nav_bar_shadow"];
    [self addSubview:lineImage];
    
    _fromTextField=[[UITextField alloc] initWithFrame:CGRectMake(20, 11, 260, 20)];
    UIImageView *leftImage1=[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 18.0f, 18.0f)];
    leftImage1.image=[UIImage imageNamed:@"directions_waypoint_myLocation"];
    _fromTextField.leftView=leftImage1;
    _fromTextField.leftViewMode=UITextFieldViewModeAlways;
    _fromTextField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _fromTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _fromTextField.font=[UIFont systemFontOfSize:14.0f];
    _fromTextField.borderStyle=UITextBorderStyleNone;
    _fromTextField.clipsToBounds=YES;
    _fromTextField.placeholder=@"选择起点";
    _fromTextField.text=@"我的位置";
    [self addSubview:_fromTextField];
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(40, 44, 240, 1)];
    lineView.backgroundColor=[UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.0f];
    [self addSubview:lineView];
    
    _toTextField=[[UITextField alloc] initWithFrame:CGRectMake(20, 56, 260, 20)];
    UIImageView *leftImage2=[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 18.0f, 18.0f)];
    leftImage2.image=[UIImage imageNamed:@"directions_waypoint_blank"];
    _toTextField.leftView=leftImage2;
    _toTextField.leftViewMode=UITextFieldViewModeAlways;
    _toTextField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    _toTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _toTextField.font=[UIFont systemFontOfSize:14.0f];
    _toTextField.borderStyle=UITextBorderStyleNone;
    _toTextField.clipsToBounds=YES;
    _toTextField.placeholder=@"选择终点";
    [self addSubview:_toTextField];
    
    _swapBtn=[[UIButton alloc] initWithFrame:CGRectMake(288, 35, 23, 18)];
    [_swapBtn setImage:[UIImage imageNamed:@"ic_swap"] forState:UIControlStateNormal];
    [_swapBtn addTarget:self action:@selector(swapTextField) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_swapBtn];

}

- (void)swapTextField{
    NSString *temp=_fromTextField.text;
    _fromTextField.text=_toTextField.text;
    _toTextField.text=temp;
    if ([_fromTextField.text isEqualToString:@"我的位置"]) {
        [(UIImageView*)_fromTextField.leftView setImage:[UIImage imageNamed:@"directions_waypoint_myLocation"]];
    }else{
        [(UIImageView*)_fromTextField.leftView setImage:[UIImage imageNamed:@"directions_waypoint_blank"]];
    }
    if ([_toTextField.text isEqualToString:@"我的位置"]) {
        [(UIImageView*)_toTextField.leftView setImage:[UIImage imageNamed:@"directions_waypoint_myLocation"]];
    }else{
        [(UIImageView*)_toTextField.leftView setImage:[UIImage imageNamed:@"directions_waypoint_blank"]];
    }
    [_delegate searchPlaceChanged];
}

- (BMKPlanNode*)getStartedNode{
    if (_fromTextField.text.length>0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userLocation=[defaults objectForKey:@"UserLocation"];
        if ([_fromTextField.text isEqualToString:@"我的位置"]) {
            if (userLocation!=nil) {
                BMKPlanNode* start = [[BMKPlanNode alloc]init];
                start.pt=CLLocationCoordinate2DMake([[userLocation objectForKey:@"lat"] doubleValue], [[userLocation objectForKey:@"lng"] doubleValue]);
                return start;
            } else {
                [SVProgressHUD showErrorWithStatus:@"未定位到当前位置！"];
                return nil;
            }
        }else if([_fromTextField.text isEqualToString:_baseAddress]){
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.pt=CLLocationCoordinate2DMake(_baseLat, _baseLng);
            return start;
        }else{
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.name=_fromTextField.text;
            return start;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入起点！"];
        return nil;
    }
}

- (BMKPlanNode*)getEndedNode{
    if (_toTextField.text.length>0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userLocation=[defaults objectForKey:@"UserLocation"];
        if ([_toTextField.text isEqualToString:@"我的位置"]) {
            if (userLocation!=nil) {
                BMKPlanNode* end = [[BMKPlanNode alloc]init];
                end.pt=CLLocationCoordinate2DMake([[userLocation objectForKey:@"lat"] doubleValue], [[userLocation objectForKey:@"lng"] doubleValue]);
                return end;
            } else {
                [SVProgressHUD showErrorWithStatus:@"未定位到当前位置！"];
                return nil;
            }
        }else if([_toTextField.text isEqualToString:_baseAddress]){
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.pt=CLLocationCoordinate2DMake(_baseLat, _baseLng);
            return end;
        }else{
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.name=_toTextField.text;
            return end;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入终点！"];
        return nil;
    }
}

@end
