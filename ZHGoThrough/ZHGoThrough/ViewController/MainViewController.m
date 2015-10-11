//
//  MainViewController.m
//  ZHGoThrough
//
//  Created by albert on 15/10/8.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "MainViewController.h"
#import "ZHGameView.h"
#import "ZHPathView1.h"

@interface MainViewController ()<UICollisionBehaviorDelegate>



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView];
    
    
}


- (void)setUpView{
    ZHPathView1 *pathView1 = [[ZHPathView1 alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:pathView1];

}




@end
