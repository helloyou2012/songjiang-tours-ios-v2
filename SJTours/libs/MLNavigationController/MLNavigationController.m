//
//  MLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

#import "MLNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface MLNavigationController ()
{
    CGPoint startTouch;
    BOOL isMoving;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@end

@implementation MLNavigationController

@synthesize canDragBack=_canDragBack;
@synthesize backgroundView=_backgroundView;
@synthesize screenShotsList=_screenShotsList;

- (void)viewDidUnload
{
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // draw a shadow for navigation view to differ the layers obviously.
    // using this way to draw shadow will lead to the low performace
    // the best alternative way is making a shadow image.
    //
    //self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    //self.view.layer.shadowOffset = CGSizeMake(5, 5);
    //self.view.layer.shadowRadius = 5;
    //self.view.layer.shadowOpacity = 1;
    _screenShotsList = [[NSMutableArray alloc]init];
    _canDragBack=YES;
    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
    [self.view addSubview:shadowImageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NSLog(@"push view controller");
    [self.screenShotsList addObject:[self capture]];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(KEY_WINDOW.bounds.size, self.view.opaque, 0.0);
    [KEY_WINDOW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //fixed bug
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

- (void)moveViewWithX:(float)x
{

    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/32000)+0.99;
    float alpha = 0.4 - (x/800);

    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
    
}

#pragma mark - UIResponse Subclassing Methods -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    isMoving = NO;
    startTouch = [((UITouch *)[touches anyObject])locationInView:KEY_WINDOW];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint moveTouch = [((UITouch *)[touches anyObject])locationInView:KEY_WINDOW];

    if (!isMoving) {
        if(moveTouch.x - startTouch.x > 10)
        {
            isMoving = YES;
            
            if (!self.backgroundView)
            {
                CGRect frame = self.view.frame;
                
                self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                
                [self.parentViewController.view.superview insertSubview:self.backgroundView belowSubview:self.parentViewController.view];
                
                blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                blackMask.backgroundColor = [UIColor blackColor];
                [self.backgroundView addSubview:blackMask];
            }
            
            if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
            
            UIImage *lastScreenShot = [_screenShotsList lastObject];
            lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
            [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        }
    }
    
    if (isMoving) {
        [self moveViewWithX:moveTouch.x - startTouch.x];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;

    CGPoint endTouch = [((UITouch *)[touches anyObject])locationInView:KEY_WINDOW];

    if (endTouch.x - startTouch.x > 70)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:320];
        } completion:^(BOOL finished) {

            [self popViewControllerAnimated:NO];
            CGRect frame = self.view.frame;
            frame.origin.x = 0;
            self.view.frame = frame;
            isMoving = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            isMoving = NO;
        }];

    }
}


#pragma mark - GestureRecognizer Methods -

- (void)gestureRecognizerBegan:(CGPoint)startPoint
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    isMoving = NO;
}

- (void)gestureRecognizerMoved:(CGPoint)moveTouch
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    if (!isMoving) {
        if(moveTouch.x > 10)
        {
            isMoving = YES;
            
            if (!self.backgroundView)
            {
                CGRect frame = self.view.frame;
                
                self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                
                [self.parentViewController.view.superview insertSubview:self.backgroundView belowSubview:self.parentViewController.view];
                
                blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                blackMask.backgroundColor = [UIColor blackColor];
                [self.backgroundView addSubview:blackMask];
            }
            
            if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
            
            UIImage *lastScreenShot = [_screenShotsList lastObject];
            lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
            [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        }
    }
    
    if (isMoving) {
        [self moveViewWithX:moveTouch.x];
    }
}

- (void)gestureRecognizerEnded:(CGPoint)endTouch
{
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    if (endTouch.x > 50)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:320];
        } completion:^(BOOL finished) {
            
            [self popViewControllerAnimated:NO];
            CGRect frame = self.view.frame;
            frame.origin.x = 0;
            self.view.frame = frame;
            isMoving = NO;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            isMoving = NO;
        }];
        
    }
}

@end
