//
//  DemoViewController.m
//  CameraDemo
//
//  Created by albert on 15/8/29.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "DemoViewController.h"
#import "TBMirrorViewController.h"
#import "TBMirrorViewControllerFactory.h"

@interface DemoViewController ()

@property (nonatomic,strong) TBMirrorViewController     *mirrorVC;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMirrorVC];
}

-(BOOL)setUpMirrorVC{
    //addChildVC
    _mirrorVC = [TBMirrorViewControllerFactory viewControllerWithType:TBMirrorMakeUpTypeVideo delegate:self];
    if (_mirrorVC == nil) {
        return NO;
    }
    [self addChildViewController:_mirrorVC];
    _mirrorVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20);
    [self.view addSubview:_mirrorVC.view];
    [_mirrorVC didMoveToParentViewController:self];
    return YES;
}



@end
