//
//  MenuGroupView.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/18/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuGroupViewDelegate <NSObject>
- (void)groupClicked:(NSDictionary*)dict;
@end

@interface MenuGroupView : UIButton

@property (nonatomic,strong) id<MenuGroupViewDelegate> delegate;
@property (nonatomic,strong) NSDictionary *contentDict;
@property (nonatomic, strong) UIImageView *menuImageView;
@property (nonatomic, strong) UILabel *menuLabel;

- (void)viewClicked;
- (id)initWithObject:(NSDictionary*)dict isSearch:(BOOL)isSearch;

@end
