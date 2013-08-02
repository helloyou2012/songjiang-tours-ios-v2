//
//  AppCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 7/4/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *smallImage;
@property (nonatomic, strong) IBOutlet UILabel *aTitle;
@property (nonatomic, strong) IBOutlet UILabel *aContent;


- (void)createView:(NSDictionary *)dict;

@end
