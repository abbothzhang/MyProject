//
//  QCLeftMenuViewController.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface QCLeftMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableViewLeft;
    UINavigationController *_navSlideSwitchVC;                //滑动切换视图
    UINavigationController *_navCommonComponentVC;              //通用控件
}

@property (nonatomic, strong) IBOutlet UITableView *tableViewLeft;
@property (nonatomic, strong) IBOutlet UINavigationController *navSlideSwitchVC;
@property (nonatomic, strong) IBOutlet UINavigationController *navCommonComponentVC;

@end

