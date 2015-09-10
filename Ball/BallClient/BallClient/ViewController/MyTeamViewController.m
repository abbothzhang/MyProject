//
//  TabOneViewController.m
//  BallClient
//
//  Created by albert on 15/9/10.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "MyTeamViewController.h"

@interface MyTeamViewController ()

@end

@implementation MyTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *navBgImg = [UIImage imageNamed:@"navbg"];
    [self.navigationController.navigationBar setBackgroundImage:navBgImg forBarMetrics:UIBarMetricsDefault];
}



@end
