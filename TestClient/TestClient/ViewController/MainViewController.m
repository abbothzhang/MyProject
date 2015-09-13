//
//  MainViewController.m
//  TestClient
//
//  Created by albert on 15/9/13.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "MainViewController.h"
#import "ZHSocailBar.h"

@interface MainViewController ()


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect socialBarFrame = CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40);
    ZHSocialParam *socialParam = [[ZHSocialParam alloc] initWithTargetId:@"" targetType:1 subType:1];
    ZHSocailBar *socialBar = [[ZHSocailBar alloc] initWithFrame:socialBarFrame socialParam:socialParam];
    
    [self.view addSubview:socialBar];
    
}

@end
