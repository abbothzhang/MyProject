//
//  MirrorBaseViewController.m
//  MirrorSDK
//
//  Created by 龙冥 on 10/15/14.
//  Copyright (c) 2014 Taobao.com. All rights reserved.
//

#import "MirrorBaseViewController.h"

@implementation MirrorUILayoutSubView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [self addSubview:button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.delegate && [(NSObject *)self.delegate respondsToSelector:@selector(layoutSubviews)]) {
        [(NSObject *)self.delegate performSelector:@selector(layoutSubviews)];
    }
}

- (void)dealloc {
    _delegate = nil;
}

@end

@interface MirrorBaseViewController ()

@end

@implementation MirrorBaseViewController

- (void)loadView {
    [super loadView];
    MirrorUILayoutSubView *view = [[MirrorUILayoutSubView alloc] initWithFrame:self.view.bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    view.delegate = self;
    self.view = view;
    self.view.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (void)showToast:(NSString *)text {
    [self showToast:text display:1.5f];
}

- (void)showToast:(NSString *)text display:(CGFloat)time {
    UIView *toastView = [self.view viewWithTag:0x732];
    do {
        if (toastView) {
            break;
        }
        int padding = 30.0f;
        //宽度固定长度扩展
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding / 2, padding / 2, 230, 30)];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        toastView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - label.frame.size.width - padding)/2, (self.view.frame.size.height - label.frame.size.height - padding) / 2,label.frame.size.width + padding, label.frame.size.height + padding)];
        [toastView addSubview:label];
        toastView.tag = 0x732;
        toastView.layer.cornerRadius = 7.0f;
        toastView.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
        [self.view addSubview:toastView];
        [UIView animateWithDuration:.2 delay:time options:UIViewAnimationOptionCurveEaseInOut animations:^{
            toastView.transform = CGAffineTransformMakeScale(.8,.8);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                toastView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [toastView removeFromSuperview];
        }];
        }];
    
    } while (0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSubviews {
    
}

- (void)dealloc {
    if ([self isViewLoaded] && [self.view isKindOfClass:[MirrorUILayoutSubView class]]) {
        ((MirrorUILayoutSubView *)self.view).delegate = nil;
    }
}

@end
