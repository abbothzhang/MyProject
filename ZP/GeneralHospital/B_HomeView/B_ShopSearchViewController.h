//
//  B_ShopSearchViewController.h
//  GeneralHospital
//
//  Created by 夏科杰 on 14-9-16.
//  Copyright (c) 2014年 夏科杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface B_ShopSearchViewController : UcmedViewStyle<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    UISearchBar     *SearchBar;
    NSMutableArray  *BtnArray;
    UITableView     *TableView;
    NSMutableArray  *ListArray;
    int             NowType;
    int             Type;
}

@property(nonatomic,retain)NSString *KeyWord;
@end
