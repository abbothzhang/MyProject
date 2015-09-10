//
//  QCLeftMenuViewController.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "QCLeftMenuViewController.h"
#import "QCSlideViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface QCLeftMenuViewController ()

@end

@implementation QCLeftMenuViewController

#pragma mark - 控制器初始化方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        QCSlideViewController *slideSwitchVC = [[QCSlideViewController alloc] init];
        
        self.navSlideSwitchVC = [[UINavigationController alloc] initWithRootViewController:slideSwitchVC];
        
    }
    return self;
}

- (void)setupUI
{
    
}

#pragma mark - 控制器方法

#pragma mark - 视图加载方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


#pragma mark - 表格视图数据源代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    int section = indexPath.section;
    NSString *LeftSideCellId = @"LeftSideCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LeftSideCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LeftSideCellId];
    }
    if (section == 0) {
        if (row == 0) {
            cell.textLabel.text = @"滑动切换视图";
            
        } else if (row == 1) {
            cell.textLabel.text = @"通用自定义样式控件";
        }
        
    }
    
    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    if (section == 0) {
        if (row == 0) { //滑动切换视图
            
            if (!self.navSlideSwitchVC) {
                QCSlideViewController *slideSwitchVC = [[QCSlideViewController alloc] init];
                
                self.navSlideSwitchVC = [[UINavigationController alloc] initWithRootViewController:slideSwitchVC];
            }
            
            [self.mm_drawerController setCenterViewController:self.navSlideSwitchVC
                                           withCloseAnimation:YES completion:nil];
        } else if (row == 1) { //通用自定义控件
            
            if (!self.navCommonComponentVC) {
                
            }
            
            [self.mm_drawerController setCenterViewController:self.navCommonComponentVC
                                           withCloseAnimation:YES completion:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 销毁内存方法

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
