//
//  YinxiangCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/15/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YinxiangCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) IBOutlet UIImageView *imagesView;
@property (nonatomic, strong) IBOutlet UILabel *titleView;

- (void) createViews:(NSDictionary*)dict;

@end
