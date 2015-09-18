//
//  D_ShoppingCarController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14/11/19.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface D_ShoppingCarController : UcmedViewStyle<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *TableView;
    NSMutableArray *ListArray;
    UILabel        *TitleLabel;
    UILabel        *PriceLabel;
    
}


@end
