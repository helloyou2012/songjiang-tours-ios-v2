//
//  SnsViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/23/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface SnsViewController : UITableViewController<SinaWeiboDelegate>

@property (nonatomic, strong) NSMutableArray *itemArray;

@end
