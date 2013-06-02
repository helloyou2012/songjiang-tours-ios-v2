//
//  SearchWaysView.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/11/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchWaysViewDelegate <NSObject>

- (void)searchTypeChanged;

@end

@interface SearchWaysView : UIView

@property (nonatomic, assign) NSInteger selected;
@property (nonatomic, strong) UIButton *carBtn;
@property (nonatomic, strong) UIButton *transitBtn;
@property (nonatomic, strong) UIButton *walkingBtn;
@property (nonatomic, retain) id<SearchWaysViewDelegate> delegate;

- (void)createViews;
- (IBAction)buttonClicked:(id)sender;
@end
