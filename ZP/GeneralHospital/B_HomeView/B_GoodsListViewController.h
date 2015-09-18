//
//  GoodsListViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-28.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B_LeftTableView.h"
@interface B_GoodsListViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray  *BtnArray;
    UITableView     *TableView;
    NSMutableArray  *ListArray;
    BOOL            IsLine;
    UILabel         *NumLabel;
    B_LeftTableView *LeftTable;
    long           SelectIndex;
    long           PageIndex;
    
}
@property(nonatomic,retain)NSArray  *CategoryList;
@property(nonatomic,retain)NSString *ShopId;
@property(nonatomic,retain)NSString *Type;
@property(nonatomic,retain)NSString *CatId;
@end
