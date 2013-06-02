//
//  JiaotongHeaderView.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/3/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JiaotongHeaderView : UIView

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *firstTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeGapLabel;

- (void)createViewData:(NSDictionary*)dict;
@end
