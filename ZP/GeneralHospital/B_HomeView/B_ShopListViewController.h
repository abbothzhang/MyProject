//
//  ShopListViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-13.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface B_ShopListViewController : UcmedViewStyle
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *TableView;
    NSMutableArray  *ListArray;
    long            PageIndex;
}
@property(nonatomic,retain)NSString *CatId;
@end
