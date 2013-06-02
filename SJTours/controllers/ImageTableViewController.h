//
//  ImageTableViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/8/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface ImageTableViewController : UITableViewController<MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageArray;

- (IBAction)imageButtonClicked:(id)sender;

@end
