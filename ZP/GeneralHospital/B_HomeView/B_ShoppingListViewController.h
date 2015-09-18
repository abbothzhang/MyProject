//
//  ShoppingListViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-29.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_ShoppingListViewController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *TableView;
    NSMutableArray *ListArray;
    UILabel        *TitleLabel;
    UILabel        *PriceLabel;
    BOOL           IsBringLeft;
    UIView         *CellMoveView;
}

@end
