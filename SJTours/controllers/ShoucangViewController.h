//
//  ShoucangViewController.h
//  SJTours
//
//  Created by ZhenzhenXu on 5/21/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoucangViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, assign) NSUInteger searchRequestNumber;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDictionary *dictType;
@property (nonatomic, strong) NSDictionary *curData;
@end
