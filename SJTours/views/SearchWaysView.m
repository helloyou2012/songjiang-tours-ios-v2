//
//  SearchWaysView.m
//  SJTours
//
//  Created by ZhenzhenXu on 5/11/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "SearchWaysView.h"

@implementation SearchWaysView

@synthesize carBtn=_carBtn;
@synthesize transitBtn=_transitBtn;
@synthesize walkingBtn=_walkingBtn;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createViews{
    _selected=1;
    
    _transitBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 4, 25, 25)];
    [_transitBtn setImage:[UIImage imageNamed:@"ic_transit"] forState:UIControlStateSelected];
    [_transitBtn setImage:[UIImage imageNamed:@"ic_transit_inactive"] forState:UIControlStateNormal];
    [_transitBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _transitBtn.tag=1;
    _transitBtn.selected=YES;
    [self addSubview:_transitBtn];
    
    _carBtn=[[UIButton alloc] initWithFrame:CGRectMake(51, 4, 25, 25)];
    [_carBtn setImage:[UIImage imageNamed:@"ic_car"] forState:UIControlStateSelected];
    [_carBtn setImage:[UIImage imageNamed:@"ic_car_inactive"] forState:UIControlStateNormal];
    [_carBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _carBtn.tag=2;
    [self addSubview:_carBtn];
    
    _walkingBtn=[[UIButton alloc] initWithFrame:CGRectMake(102, 4, 25, 25)];
    [_walkingBtn setImage:[UIImage imageNamed:@"ic_walking"] forState:UIControlStateSelected];
    [_walkingBtn setImage:[UIImage imageNamed:@"ic_walking_inactive"] forState:UIControlStateNormal];
    [_walkingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _walkingBtn.tag=3;
    [self addSubview:_walkingBtn];
}

- (IBAction)buttonClicked:(id)sender{
    _selected=[(UIButton*)sender tag];
    _carBtn.selected=NO;
    _transitBtn.selected=NO;
    _walkingBtn.selected=NO;
    [(UIButton*)sender setSelected:YES];
    [_delegate searchTypeChanged];
}

@end
