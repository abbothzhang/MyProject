//
//  IPADemoViewController.m
//  MirrorDemo2
//
//  Created by albert on 15/8/27.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import "IPADemoViewController.h"
#import "MirrorTest.h"
#import "MirrorViewController.h"

@interface IPADemoViewController ()<MirrorViewControllerDelegate>

@property (nonatomic,strong) MirrorViewController *mirrorVC;

@end

@implementation IPADemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    MirrorTest *mirrorTest = [[MirrorTest alloc] init];
    self.mirrorVC = [[MirrorViewController alloc] initWithCameraPreset:AVCaptureSessionPreset640x480];
    [self.mirrorVC initMakeUpModule];
    
    _mirrorVC.delegate = self;
    [self addChildViewController:_mirrorVC];
    _mirrorVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_mirrorVC.view];
    [_mirrorVC didMoveToParentViewController:self];
    
}

#pragma mark - MirrorViewControllerDelegate
// 调用初始化试妆模块接口，成功后调用此回调
- (void)initMakeUpModuleDidSuccess{
    //上妆
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    //TODO:
    
    [self.mirrorVC makeUpWithDict:muDic materialType:MirrorMaterialTypeDefault];
}




@end
