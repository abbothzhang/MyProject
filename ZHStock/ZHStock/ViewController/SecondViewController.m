//
//  SecondViewController.m
//  ZHStock
//
//  Created by albert on 15/10/4.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.backgroundColor = [UIColor yellowColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //titleBar
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    titleBar.backgroundColor = [UIColor yellowColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(11, 31, 20, 20)];
    backBtn.backgroundColor = [UIColor grayColor];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [titleBar addSubview:backBtn];
    [self.view addSubview:titleBar];
    
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
