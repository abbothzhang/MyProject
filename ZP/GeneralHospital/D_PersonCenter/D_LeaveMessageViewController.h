//
//  D_LeaveMessageViewController.h
//  zhipin
//
//  Created by kjx on 15/3/15.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_LeaveMessageViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *TableView;
    NSMutableArray *ListArray;
    UIView         *ShowView;
    UIImageView    *ShowImage;
}
@property(nonatomic,strong)NSString *ShopId;

@end
