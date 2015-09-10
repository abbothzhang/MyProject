//
//  ViewController.m
//  TestClient
//
//  Created by albert on 15/9/8.
//  Copyright (c) 2015年 penghui.zh. All rights reserved.
//

#import "ViewController.h"
#import <staticFrameWorkDemo/staticFrameWorkDemo.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    staticFrameWorkDemo *demo = [[staticFrameWorkDemo alloc] init];
    NSString *path = [demo getResourcePath];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"img1" ofType:@"png"];
}


@end
