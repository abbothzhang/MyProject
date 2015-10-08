//
//  MainViewController.m
//  ZHStock
//
//  Created by albert on 15/10/4.
//  Copyright © 2015年 penghui.zh. All rights reserved.
//

#import "MainViewController.h"
#import "ZIOMenuView.h"
#import "ZHLeftView.h"
#import "ZHUtil.h"
#import "SecondViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) ZIOMenuView            *moveView;
@property (nonatomic,strong) NSArray                *tableViewArray;
@property (nonatomic,strong) UITableView            *menuTableView;


@end

@implementation MainViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    
    

}

- (void)setUpView{
    //leftView
    ZHLeftView *leftView = [[ZHLeftView alloc] initWithFrame:self.view.bounds];
    leftView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:leftView];
    
    //add menuView
    [self.view addSubview:self.moveView];
//    UIView *testView = [[UIView alloc] initWithFrame:self.view.bounds];
//    testView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:testView];
    
    //titleBar
    UIView *titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    titleBar.backgroundColor = [UIColor yellowColor];
    [self.moveView addSubview:titleBar];
    
    //tableView
    [self.moveView addSubview:self.menuTableView];
    
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cellIden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    cell.textLabel.text = [self.tableViewArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SecondViewController *secVC = [[SecondViewController alloc] init];
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:secVC animated:YES];
}

#pragma mark -
- (NSArray *)tableViewArray{
    if (_tableViewArray == nil) {
        _tableViewArray = [[NSArray alloc] initWithObjects:
                           @"板块气象",@"个股诊断",@"查自选股",@"早盘金股",
//                           @"午盘金股",@"看涨榜单",@"看跌榜单",@"停牌榜单",
//                           @"投资理财",@"股情早报",@"收市述评",@"新手引导",
                           @"招贤纳士",@"版本更新", nil];
    }
    return _tableViewArray;
}

- (UITableView *)menuTableView{
    if (_menuTableView == nil) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, 100*WITH_SCALE, self.moveView.frame.size.height-210)];
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
    }
    
    return _menuTableView;
}

- (ZIOMenuView *)moveView{
    if (_moveView == nil) {
        _moveView = [[ZIOMenuView alloc] initWithFrame:self.view.bounds];
        //设置颜色 （默认白色背景）
        _moveView.backgroundColor = [UIColor colorWithRed:0.8 green:0.4 blue:0.7 alpha:1];
        //设置左边目录宽度 （默认0）
        _moveView.leftViewWidth = 200;
        //设置右边目录宽度（默认0）
        _moveView.rightViewWidth = 0;
        //代理
//        _moveView.delegate = self;
        //开启遮盖view （默认NO）
        _moveView.cover = YES;
        //设置动画时间 （默认0.3秒）
        _moveView.animateTime = 0.3;
        //设置移动比例 ，（默认0.3）
        _moveView.moveRatio = 0.5;
        _moveView.exclusiveTouch = NO;
        _moveView.userInteractionEnabled = YES;
    }
    return _moveView;
}


@end
