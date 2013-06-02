//
//  KTTextView.m
//
//  Created by Kirby Turner on 10/29/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//
//  The MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "KTTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation KTTextView

@synthesize placeholder = _placeholder;
@synthesize placeholderColor=_placeholderColor;
@synthesize placeholderText=_placeholderText;

@synthesize alwaysGlowing=_alwaysGlowing;
@synthesize borderColor=_borderColor;
@synthesize glowingColor=_glowingColor;

- (void)setup
{
   if ([self placeholder]) {
      [[self placeholder] removeFromSuperview];
      [self setPlaceholder:nil];
   }
   
   CGRect frame = CGRectMake(8, 8, self.bounds.size.width - 16, 0.0);
   UILabel *placeholder = [[UILabel alloc] initWithFrame:frame];
   [placeholder setLineBreakMode:UILineBreakModeWordWrap];
   [placeholder setNumberOfLines:0];
   [placeholder setBackgroundColor:[UIColor clearColor]];
   [placeholder setAlpha:1.0];
   [placeholder setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
   [placeholder setTextColor:[UIColor lightGrayColor]];
   [placeholder setText:@""];
   [self addSubview:placeholder];
   [self sendSubviewToBack:placeholder];
    
   [self setPlaceholder:placeholder];

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFocus:) name:UITextViewTextDidBeginEditingNotification object:nil];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lostFocus:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)awakeFromNib
{
   [super awakeFromNib];
    self.alwaysGlowing = NO;
    [self _configureView];
    self.clipsToBounds=YES;
   [self setup];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
   self = [super initWithCoder:aDecoder];
   if (self) {
       self.alwaysGlowing = NO;
       [self _configureView];
       self.clipsToBounds=YES;
      [self setup];
   }
   return self;
}

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
       self.alwaysGlowing = NO;
       [self _configureView];
       self.clipsToBounds=YES;
      [self setup];
   }
   return self;
}

- (void)textChanged:(NSNotification *)notification
{
   if ([[_placeholder text] length] == 0) {
      return;
   }
   
   if ([[self text] length] == 0) {
      [_placeholder setAlpha:1.0];
   } else {
      [_placeholder setAlpha:0.0];
   }
}

- (void)getFocus:(NSNotification *)notification
{
    [_placeholder setAlpha:0.0];
}

- (void)lostFocus:(NSNotification *)notification
{
    if ([[self text] length] == 0) {
        [_placeholder setAlpha:1.0];
    } else {
        [_placeholder setAlpha:0.0];
    }
}

- (void)drawRect:(CGRect)rect
{
   [super drawRect:rect];
    [_backgroundColor set];
    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f] fill];
   if ([[self text] length] == 0 && [[_placeholder text] length] > 0) {
      [_placeholder setAlpha:1.0];
   } else {
      [_placeholder setAlpha:0.0];
   }
}

- (void)setFont:(UIFont *)font
{
   [super setFont:font];
   [_placeholder setFont:font];
}

- (NSString *)placeholderText
{
   return [_placeholder text];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
   [_placeholder setText:placeholderText];
   
   CGRect frame = _placeholder.frame;
   CGSize constraint = CGSizeMake(frame.size.width, 42.0f);
   CGSize size = [placeholderText sizeWithFont:[self font] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];      
   
   frame.size.height = size.height;
   [_placeholder setFrame:frame];
}

- (UIColor *)placeholderColor
{
   return [_placeholder textColor];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
   [_placeholder setTextColor:placeholderColor];
}

#pragma mark Border setting

- (void)_configureView
{
    self.clipsToBounds = YES;
	
	if (!self.backgroundColor)
	{
		self.backgroundColor = [UIColor whiteColor];
	}
	
	if (!self.glowingColor)
	{
		self.glowingColor = [UIColor colorWithRed:(82.f / 255.f) green:(168.f / 255.f) blue:(236.f / 255.f) alpha:0.8];
	}
	
	if (!self.borderColor)
	{
		self.borderColor = [UIColor lightGrayColor];
	}
	
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 4.f;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = self.borderColor.CGColor;
	
    self.layer.shadowColor = self.glowingColor.CGColor;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.f].CGPath;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 5.f;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIColor *)backgroundColor
{
	return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	[super setBackgroundColor:[UIColor clearColor]];
	_backgroundColor = backgroundColor;
}

- (void)setGlowingColor:(UIColor *)glowingColor
{
	if ([self isFirstResponder] || self.alwaysGlowing) {
		[self animateBorderColorFrom:(id)self.layer.borderColor to:(id)glowingColor.CGColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:1.f] to:(id)[NSNumber numberWithFloat:1.f]];
	}
	
	_glowingColor = glowingColor;
	
	self.layer.shadowColor = glowingColor.CGColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
	_borderColor = borderColor;
	
	if (![self isFirstResponder] && !self.alwaysGlowing)
	{
		self.layer.borderColor = self.borderColor.CGColor;
	}
}

- (void)setAlwaysGlowing:(BOOL)alwaysGlowing
{
	if (_alwaysGlowing && !alwaysGlowing && ![self isFirstResponder]) {
		[self hideGlowing];
	} else if (!_alwaysGlowing && alwaysGlowing && ![self isFirstResponder]) {
		[self showGlowing];
	}
	
	_alwaysGlowing = alwaysGlowing;
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self _configureView];
}

- (void)animateBorderColorFrom:(id)fromColor to:(id)toColor shadowOpacityFrom:(id)fromOpacity to:(id)toOpacity
{
    CABasicAnimation *borderColorAnimation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    borderColorAnimation.fromValue = fromColor;
    borderColorAnimation.toValue = toColor;
	
    CABasicAnimation *shadowOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    shadowOpacityAnimation.fromValue = fromOpacity;
    shadowOpacityAnimation.toValue = toOpacity;
	
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.0f / 3.0f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.animations = @[borderColorAnimation, shadowOpacityAnimation];
	
    [self.layer addAnimation:group forKey:nil];
}

- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
	
    if (result && !self.alwaysGlowing)
    {
        [self showGlowing];
    }
    return result;
}

- (BOOL)resignFirstResponder
{
    BOOL result = [super resignFirstResponder];
	
    if (result && !self.alwaysGlowing)
    {
        [self hideGlowing];
    }
    return result;
}

- (void)showGlowing
{
	[self animateBorderColorFrom:(id)self.layer.borderColor to:(id)self.layer.shadowColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:0.f] to:(id)[NSNumber numberWithFloat:1.f]];
}

- (void)hideGlowing
{
	[self animateBorderColorFrom:(id)self.layer.borderColor to:(id)self.borderColor.CGColor shadowOpacityFrom:(id)[NSNumber numberWithFloat:1.f] to:(id)[NSNumber numberWithFloat:0.f]];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 8, 2);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 8, 2);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 8, 2);
}

@end
