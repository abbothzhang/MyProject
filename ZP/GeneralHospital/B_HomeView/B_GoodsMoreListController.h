//
//  B_GoodsMoreListController.h
//  zhipin
//
//  Created by 夏科杰 on 15/2/15.
//  Copyright (c) 2015年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
@interface B_GoodsMoreListController : UcmedViewStyle
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *TableView;
    NSMutableArray  *ListArray;
}
@property(nonatomic,retain)NSString *CatId;
@end
