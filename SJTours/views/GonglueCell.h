//
//  GonglueCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/19/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GonglueCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *smallImage;
@property (nonatomic, strong) IBOutlet UILabel *gTitle;
@property (nonatomic, strong) IBOutlet UILabel *gDescription;


- (void)createView:(NSDictionary *)dict;
@end
