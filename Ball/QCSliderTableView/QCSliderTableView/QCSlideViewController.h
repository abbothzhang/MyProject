//
//  QCSlideViewController.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "QCListViewController.h"
#import "QCViewController.h"

@interface QCSlideViewController : UIViewController<QCSlideSwitchViewDelegate>
{
    QCSlideSwitchView *_slideSwitchView;
    QCListViewController *_vc1;
    QCListViewController *_vc2;
    QCListViewController *_vc3;
    QCListViewController *_vc4;
    QCListViewController *_vc5;
    QCListViewController *_vc6;
}

@property (nonatomic, strong) IBOutlet QCSlideSwitchView *slideSwitchView;

@property (nonatomic, strong) QCListViewController *vc1;
@property (nonatomic, strong) QCListViewController *vc2;
@property (nonatomic, strong) QCListViewController *vc3;
@property (nonatomic, strong) QCListViewController *vc4;
@property (nonatomic, strong) QCListViewController *vc5;
@property (nonatomic, strong) QCListViewController *vc6;

@end

