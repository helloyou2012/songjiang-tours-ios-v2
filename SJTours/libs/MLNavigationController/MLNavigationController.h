//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLNavigationController : UINavigationController

@property (nonatomic,assign) BOOL canDragBack;
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,strong) NSMutableArray *screenShotsList;


- (void)gestureRecognizerBegan:(CGPoint)startPoint;
- (void)gestureRecognizerMoved:(CGPoint)moveTouch;
- (void)gestureRecognizerEnded:(CGPoint)endTouch;
- (UIImage *)capture;
@end
