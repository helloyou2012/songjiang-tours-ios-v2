//
//  AppDelegate.h
//  SJTours
//
//  Created by ZhenzhenXu on 4/11/13.
//  Copyright (c) 2013 ZhenzhenXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@class SinaWeibo;
@class TCWBEngine;

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BMKMapManager *mapManager;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) SinaWeibo *sinaweibo;
@property (nonatomic, strong) TCWBEngine *txweibo;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)deleteObject:(NSString*)object_id with:(NSString*)tableName;
@end
