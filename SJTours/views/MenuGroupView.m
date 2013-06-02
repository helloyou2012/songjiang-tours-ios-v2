//
//  MenuGroupView.m
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import "MenuGroupView.h"

#define IMAGE_WIDTH	24.0f
#define IMAGE_HEIGHT 24.0f
#define LABEL_HEIGHT 21.0f
#define GAP 4.0f

#define WIDTH 106.0f
#define HEIGHT 106.0f

#define SEARCH_WIDTH 64.0f
#define SEARCH_HEIGHT 67.0f

@implementation MenuGroupView

@synthesize delegate=_delegate;
@synthesize contentDict=_contentDict;
@synthesize menuImageView=_menuImageView;
@synthesize menuLabel=_menuLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithObject:(NSDictionary*)dict isSearch:(BOOL)isSearch
{
    self = [super init];
    _contentDict=dict;
    if (self) {
        CGFloat curWidth=WIDTH;
        CGFloat curHeight=HEIGHT;
        CGFloat image_size=54.0f;
        if (isSearch) {
            curWidth=SEARCH_WIDTH;
            curHeight=SEARCH_HEIGHT;
            image_size=IMAGE_WIDTH;
        }
        self.frame=CGRectMake(0, 0, curWidth, curHeight);
        
        CGFloat ix=(curWidth-image_size)/2.0f;
        CGFloat iy=(curHeight -image_size-LABEL_HEIGHT-GAP)/2.0f;
        _menuImageView=[[UIImageView alloc] initWithFrame:CGRectMake(ix, iy, image_size, image_size)];
        _menuImageView.image=[UIImage imageNamed:[dict objectForKey:@"imageName"]];
        _menuImageView.backgroundColor=[UIColor clearColor];
        [self addSubview:_menuImageView];
        
        iy+=image_size+GAP;
        _menuLabel=[[UILabel alloc] initWithFrame:CGRectMake(1, iy, curWidth-2, LABEL_HEIGHT)];
        _menuLabel.text=[dict objectForKey:@"name"];
        _menuLabel.textAlignment=UITextAlignmentCenter;
        _menuLabel.font=[UIFont systemFontOfSize:12.0f];
        _menuLabel.textColor=[UIColor blackColor];
        _menuLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:_menuLabel];
        
        [self addTarget:self action:@selector(viewClicked) forControlEvents:UIControlEventTouchUpInside];
        [self setImage:[UIImage imageNamed:@"menu_bg_sel"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)viewClicked
{
    [_delegate groupClicked:_contentDict];
}

@end
