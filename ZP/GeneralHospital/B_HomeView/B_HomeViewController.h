//
//  B_HomeViewController.h
//  至品购物
//
//  Created by 夏科杰 on 14-9-6.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B_LeftTableView.h"
@interface B_HomeViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
 
    UISearchBar     *SearchBar;
    B_LeftTableView *LeftTable;
    NSArray         *ListArray;
    UITableView     *TableView;
    NSDictionary    *ActiveDict;
    UIButton        *RightBtn;
    NSString        *LocString;
}

@property (nonatomic, copy) NSString *LocString;
@property (nonatomic, copy) NSString *cityCode;
@end
