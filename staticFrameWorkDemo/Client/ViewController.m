//
//  ViewController.m
//  Client
//
//  Created by albert on 15/9/7.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "ViewController.h"
#import "staticFrameWorkDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    staticFrameWorkDemo *demo = [[staticFrameWorkDemo alloc] init];
    [demo getResource];
    NSString *path = [demo getResourcePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
