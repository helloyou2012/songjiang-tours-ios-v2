//
//  JingdianCell.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingdianCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *smallImage;
@property (nonatomic, strong) IBOutlet UILabel *gTitle;
@property (nonatomic, strong) IBOutlet UILabel *gDescription;


- (void)createView:(NSDictionary *)dict;
@end
