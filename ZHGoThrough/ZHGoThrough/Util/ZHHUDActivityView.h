//
//  Created by albert on 15-1-25.
//  Copyright (c) 2015年 albert. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface ZHHUDActivityView : UIView <UIScrollViewDelegate> {
    CGFloat     indicatorWidth;
    CGFloat     indicatorHeight;
    
    UIScrollView                *scrollView;
    UIView                      *maskView;
    UIView                      *backView;
    UIActivityIndicatorView     *activityView;
    UILabel                     *textLabel;
    
    UIImageView                 *imageView;
    
    BOOL						needShowTip;
}

- (void)animateToHide;
- (void)animateShowInView:(UIView *)view;
- (void)animateShowInView:(UIView *)view autoHideAfter:(float)interval;

- (void)sizeToIndicator;

- (void)setIndicatorImage:(UIImage *)image;

- (id)initWithFrame:(CGRect)frame showTip:(BOOL)value;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) CGFloat indicatorWidth, indicatorHeight;
@property (nonatomic, retain) UILabel *textLabel;

@end
